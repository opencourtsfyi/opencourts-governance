#!/usr/bin/env python
"""Generate entries-only SDD from the SRS.

Rules:
- One entry per SRS requirement.
- Do not invent behaviors; Acceptance Criteria is sourced from SRS bullets.
- Deterministic Target Repository routing based on repo-routing-rules decision tree.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional


REQ_RE = re.compile(r"^\s*-\s*\*\*(?P<id>[A-Z]+-\d+[A-Z]?)\s*:\s*(?P<title>.*?)\*\*\s*$")


@dataclass(frozen=True)
class Requirement:
    req_id: str
    title: str
    bullets: List[str]


def _strip_md_inline(text: str) -> str:
    # Keep it conservative: remove bold markers/backticks only.
    return text.replace("**", "").replace("`", "")


def parse_requirements(markdown: str) -> List[Requirement]:
    lines = markdown.splitlines()
    requirements: List[Requirement] = []

    current_id: Optional[str] = None
    current_title: Optional[str] = None
    current_bullets: List[str] = []

    def flush() -> None:
        nonlocal current_id, current_title, current_bullets
        if current_id and current_title:
            # Preserve bullet meaning; strip only minimal inline markers.
            bullets = [_strip_md_inline(b).strip() for b in current_bullets if b.strip()]
            requirements.append(Requirement(current_id, _strip_md_inline(current_title).strip(), bullets))
        current_id = None
        current_title = None
        current_bullets = []

    i = 0
    while i < len(lines):
        line = lines[i]
        m = REQ_RE.match(line)
        if m:
            flush()
            current_id = m.group("id")
            current_title = m.group("title")
            i += 1
            continue

        if current_id:
            # Capture ONLY indented bullet lines under the requirement.
            # This avoids accidentally absorbing section headers / paragraphs / separators.
            if (line.startswith("  -") or line.startswith("\t-") or line.startswith("    -")):
                stripped = line.lstrip()
                current_bullets.append(stripped[1:].strip())

        i += 1

    flush()
    return requirements


def find_nice_to_have(markdown: str) -> List[str]:
    # Extract bullet lines under "## Nice to Have".
    lines = markdown.splitlines()
    nice: List[str] = []
    in_section = False
    for line in lines:
        if line.strip().lower() == "## nice to have":
            in_section = True
            continue
        if in_section and line.startswith("## ") and line.strip().lower() != "## nice to have":
            break
        if in_section:
            stripped = line.lstrip()
            if stripped.startswith("-"):
                nice.append(_strip_md_inline(stripped[1:].strip()))
    return [n for n in nice if n]


def choose_actor_phrase(req: Requirement) -> str:
    haystack = (req.title + "\n" + "\n".join(req.bullets)).lower()
    if "authorized user" in haystack or "authorized users" in haystack:
        return "an authorized user"
    if "registered community contributors" in haystack or "contributor" in haystack or "contributors" in haystack:
        return "a contributor"
    if "moderator" in haystack or "moderators" in haystack:
        return "a moderator"
    if "admin" in haystack or "admins" in haystack:
        return "an admin"
    if "developer" in haystack or "developers" in haystack:
        return "a developer"
    if "automated agent" in haystack or "ai-assisted" in haystack or "ai" in haystack:
        return "an AI agent"
    if "user" in haystack or "users" in haystack:
        return "a user"
    return "a user"


def user_stories_for(req: Requirement) -> List[str]:
    """Derive user stories from SRS bullets when possible (no invented behavior)."""
    stories: List[str] = []

    prefix_mappings = [
        ("authorized users can ", "an authorized user"),
        ("users can ", "a user"),
        ("registered community contributors can ", "a contributor"),
        ("contributors can ", "a contributor"),
        ("moderators see ", "a moderator"),
        ("maintainers shall be able to ", "a maintainer"),
        ("maintainers can ", "a maintainer"),
    ]

    for b in req.bullets:
        b_norm = b.strip()
        b_low = b_norm.lower()
        for prefix, actor_phrase in prefix_mappings:
            if b_low.startswith(prefix):
                remainder = b_norm[len(prefix):].strip()
                if not remainder:
                    continue

                # Normalize to a standard user-story pattern.
                if prefix.startswith("moderators see"):
                    story = f"As {actor_phrase}, I can see {remainder}."
                else:
                    story = f"As {actor_phrase}, I can {remainder}."
                stories.append(story)
                break
        if stories:
            break

    if not stories:
        actor_phrase = choose_actor_phrase(req)
        stories = [f"As {actor_phrase}, I can {req.title}.".rstrip(".") + "."]

    return stories


def dependencies_for(req: Requirement) -> List[str]:
    # Dependencies must be limited to the SRS System Overview layers.
    prefix = req.req_id.split("-")[0]
    deps_by_prefix = {
        "FR": [
            "Web portal and API layer",
            "Storage layer",
        ],
        "DG": [
            "Data ingestion and processing",
            "Storage layer",
            "AI review and governance layer",
        ],
        "GC": [
            "AI review and governance layer",
            "Web portal and API layer",
        ],
        "SEC": [
            "Web portal and API layer",
            "Storage layer",
            "Infrastructure-as-code",
        ],
        "MON": [
            "Web portal and API layer",
            "Data ingestion and processing",
            "Storage layer",
            "AI review and governance layer",
        ],
        "DR": [
            "Storage layer",
            "Infrastructure-as-code",
        ],
        "INF": [
            "Infrastructure-as-code",
        ],
        "NFR": [
            "Web portal and API layer",
            "Storage layer",
            "Infrastructure-as-code",
        ],
    }

    deps = list(deps_by_prefix.get(prefix, ["Web portal and API layer"]))

    text = (req.title + "\n" + "\n".join(req.bullets)).lower()
    if "visual" in text:
        if "Visualization layer" not in deps:
            deps.append("Visualization layer")
    if "terraform" in text:
        if "Infrastructure-as-code" not in deps:
            deps.append("Infrastructure-as-code")
    if "ingest" in text or "pipeline" in text or "recrawl" in text or "parquet" in text or "medallion" in text:
        if "Data ingestion and processing" not in deps:
            deps.append("Data ingestion and processing")
    if "ai" in text or "automated agent" in text:
        if "AI review and governance layer" not in deps:
            deps.append("AI review and governance layer")

    return deps


def target_repo_for(req: Requirement) -> str:
    # Deterministic, single-repo routing approximating repo-routing-rules decision tree.
    # Order matters.
    rid = req.req_id
    text = (req.title + "\n" + "\n".join(req.bullets)).lower()

    # Infra / IaC / monitoring / secrets / backups
    if rid.startswith(("INF-", "MON-", "DR-")):
        return "opencourts-infra"
    if rid.startswith("SEC-") and rid in {"SEC-3", "SEC-4", "SEC-5", "SEC-7", "SEC-8"}:
        return "opencourts-infra"

    # ETL / ingestion / provenance logging / registry validation
    if rid in {"FR-2A", "FR-10", "FR-10A", "FR-20", "FR-22", "NFR-6", "INF-3A"}:
        return "opencourts-etl"
    if "ingestion" in text or "pipeline" in text or "recrawl" in text or "parquet" in text or "medallion" in text:
        return "opencourts-etl"

    # Governance / docs / prompts
    if rid.startswith("GC-") and rid in {"GC-1", "GC-6", "GC-7"}:
        return "opencourts-governance"
    if rid.startswith("DG-") and rid == "DG-7":
        return "opencourts-governance"

    # CKAN / portal / metadata / UI extensions
    if rid.startswith(("FR-", "DG-", "GC-", "SEC-", "NFR-")):
        return "opencourts-ckan"

    # Fallback
    return "opencourts-governance"


def labels_for(req: Requirement, target_repo: str) -> List[str]:
    text = (req.title + "\n" + "\n".join(req.bullets)).lower()

    if target_repo == "opencourts-infra":
        return ["infra", "feature"]

    if target_repo == "opencourts-governance":
        return ["documentation"]

    # ckan/etl default to backend work, unless clearly UI/UX.
    if "ui" in text or "accessible" in text or "accessibility" in text or "public-facing" in text:
        return ["frontend", "feature"]

    return ["backend", "feature"]


def priority_for(req: Requirement) -> str:
    rid = req.req_id
    if rid.startswith(("FR-", "SEC-", "MON-", "DR-", "INF-")):
        return "High"
    if rid.startswith(("DG-", "GC-", "NFR-")):
        return "Medium"
    return "Medium"


def format_entry(feature_name: str, problem: str, user_stories: List[str], acceptance: List[str], deps: List[str], target_repo: str, labels: List[str], priority: str) -> str:
    def md_list(items: Iterable[str]) -> str:
        if not items:
            return "  -"
        return "\n".join(f"  - {item}" for item in items)

    labels_json = "[" + ", ".join(f'"{l}"' for l in labels) + "]"

    return (
        "### SDD Entry\n"
        f"- **Feature Name:**  \n  {feature_name}\n\n"
        f"- **Problem Statement:**  \n  {problem}\n\n"
        "- **User Stories:**  \n"
        f"{md_list(user_stories)}\n\n"
        "- **Acceptance Criteria:**  \n"
        f"{md_list(acceptance)}\n\n"
        "- **Dependencies:**  \n"
        f"{md_list(deps)}\n\n"
        f"- **Target Repository:**  \n  {target_repo}\n\n"
        f"- **Labels:**  \n  {labels_json}\n\n"
        f"- **Priority:**  \n  {priority}\n"
    )


def requirements_to_entries(requirements: List[Requirement], nice_to_have: List[str]) -> str:
    out_parts: List[str] = []

    for req in requirements:
        feature_name = f"{req.req_id}: {req.title}"
        problem = f"Implement {req.req_id} as specified in the SRS."  # conservative; avoids adding behavior
        user_stories = user_stories_for(req)

        # Acceptance criteria is the requirement's bullet list; if empty, restate the title.
        acceptance = req.bullets[:] if req.bullets else [req.title]

        deps = dependencies_for(req)
        target_repo = target_repo_for(req)
        labels = labels_for(req, target_repo)
        priority = priority_for(req)

        out_parts.append(format_entry(feature_name, problem, user_stories, acceptance, deps, target_repo, labels, priority))

    for nh in nice_to_have:
        feature_name = f"Nice to Have: {nh}"
        problem = "Implement the Nice to Have item as described in the SRS."
        user_stories = [f"As an AI agent, I can {nh}.".rstrip(".") + "."]
        acceptance = [nh]
        deps = ["Web portal and API layer"]
        target_repo = "opencourts-governance"
        labels = ["documentation"]
        priority = "Low"
        out_parts.append(format_entry(feature_name, problem, user_stories, acceptance, deps, target_repo, labels, priority))

    return "\n\n".join(out_parts).strip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--srs", type=Path, default=Path("design/software-requirements-specification.md"))
    parser.add_argument("--out", type=Path, default=Path("design/software-design-document.md"))
    parser.add_argument("--check-only", action="store_true")
    args = parser.parse_args()

    srs_text = args.srs.read_text(encoding="utf-8")
    requirements = parse_requirements(srs_text)
    nice_to_have = find_nice_to_have(srs_text)

    if not requirements:
        raise SystemExit("No requirements parsed from SRS")

    # Basic sanity: ensure unique IDs.
    ids = [r.req_id for r in requirements]
    dupes = sorted({rid for rid in ids if ids.count(rid) > 1})
    if dupes:
        raise SystemExit(f"Duplicate requirement IDs found: {dupes}")

    output = requirements_to_entries(requirements, nice_to_have)

    if args.check_only:
        print(f"Parsed {len(requirements)} requirements; {len(nice_to_have)} nice-to-have bullets.")
        return 0

    args.out.write_text(output, encoding="utf-8")
    print(f"Wrote {len(requirements)} entries (+{len(nice_to_have)} nice-to-have) to {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
