"""Generate GitHub issue JSON from the SDD/SRS.

This script is intentionally lightweight and dependency-free to keep volunteer setup easy.

It implements the contract in:
    automation/issue-generation/prompts/create-issues-prompt

Usage:
    python automation/issue-generation/scripts/generate_issues.py \
        --out automation/issue-generation/out/issues.json
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ALLOWED_REPOS: set[str] = {
    "opencourts-infra",
    "opencourts-etl",
    "opencourts-ckan",
    "opencourts-mock-website",
    "opencourts-governance",
}


@dataclass(frozen=True)
class SddEntry:
    feature_name: str
    problem_statement: str
    user_stories: list[str]
    acceptance_criteria: list[str]
    dependencies: list[str]
    target_repo: str
    labels: list[str]
    priority: str

    @property
    def requirement_id(self) -> str | None:
        match = re.match(r"^([A-Z]+-\d+[A-Z]?)\b", self.feature_name.strip())
        return match.group(1) if match else None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate volunteer-friendly issues from the SDD")
    parser.add_argument(
        "--sdd",
        default="design/software-design-document.md",
        help="Path to software-design-document.md",
    )
    parser.add_argument(
        "--srs",
        default="design/software-requirements-specification.md",
        help="Path to software-requirements-specification.md",
    )
    parser.add_argument(
        "--milestones",
        default="design/project-milestones.md",
        help="Path to project-milestones.md",
    )
    parser.add_argument(
        "--activity-types",
        default="automation/project-generation/volunteer-activity-categories.md",
        help="Path to volunteer-activity-categories.md",
    )
    parser.add_argument(
        "--out",
        default="automation/issue-generation/out/issues.json",
        help="Output JSON path",
    )
    parser.add_argument(
        "--max-criteria-per-issue",
        type=int,
        default=5,
        help="Maximum acceptance-criteria checklist items per generated issue",
    )
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON")
    return parser.parse_args()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def normalize_text(text: str) -> str:
    # Lowercase and turn punctuation into spaces for stable substring matching.
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def chunked(items: list[str], size: int) -> Iterable[list[str]]:
    if size <= 0:
        raise ValueError("--max-criteria-per-issue must be > 0")
    for i in range(0, len(items), size):
        yield items[i : i + size]


def parse_milestones(path: Path) -> list[str]:
    text = read_text(path)
    milestones: list[str] = []
    for line in text.splitlines():
        match = re.match(r"^##\s+(Milestone\s+\d+:\s+.+)\s*$", line)
        if match:
            milestones.append(match.group(1).strip())

    if len(milestones) != 6:
        raise ValueError(f"Expected 6 milestones in {path.as_posix()}, found {len(milestones)}")
    return milestones


def parse_activity_types(path: Path) -> list[str]:
    text = read_text(path)
    activity_types: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped.startswith("*") and not stripped.startswith("-"):
            continue
        stripped = stripped.lstrip("*- ").strip()
        if not stripped:
            continue
        # Format: "DevOps (...." or "DevOps - ...."
        match = re.match(r"^([^\(\-]+?)\s*(\(|\-|$)", stripped)
        if match:
            activity_types.append(match.group(1).strip())

    # De-dupe while preserving order
    seen: set[str] = set()
    deduped: list[str] = []
    for value in activity_types:
        if value not in seen:
            seen.add(value)
            deduped.append(value)

    expected = {
        "DevOps",
        "Software Development",
        "Data Visualization",
        "AI",
        "Data Collection and Cleaning",
        "Outreach",
    }
    if set(deduped) != expected:
        raise ValueError(
            "Unexpected activity types extracted from "
            f"{path.as_posix()}: {deduped}. Expected exactly: {sorted(expected)}"
        )
    return deduped


def extract_srs_requirement_ids(path: Path) -> set[str]:
    text = read_text(path)
    ids = set(re.findall(r"\*\*([A-Z]+-\d+[A-Z]?):", text))
    if not ids:
        raise ValueError(f"No SRS requirement IDs found in {path.as_posix()}")
    return ids


def split_sdd_entries(text: str) -> list[str]:
    # Keep the '### SDD Entry' marker out of the chunks for simpler parsing.
    parts = re.split(r"^###\s+SDD\s+Entry\s*$", text, flags=re.MULTILINE)
    # parts[0] may be empty or preamble
    chunks = [p.strip("\r\n") for p in parts[1:] if p.strip()]
    if not chunks:
        raise ValueError("No SDD entries found (expected '### SDD Entry' headings)")
    return chunks


def parse_field_block(lines: list[str], start_index: int) -> tuple[list[str], int]:
    """Return (block_lines, next_index) where block_lines are the lines after a field marker.

    Field marker line is expected at lines[start_index]. This function returns the subsequent
    lines until the next field marker or end of entry.
    """
    i = start_index + 1
    block: list[str] = []
    while i < len(lines):
        line = lines[i]
        if re.match(r"^\s*-\s+\*\*.+?\*\*:?\s*$", line):
            break
        block.append(line.rstrip("\r"))
        i += 1
    return block, i


def first_nonempty_line(block: list[str]) -> str:
    for line in block:
        stripped = line.strip()
        if stripped:
            return stripped
    return ""


def parse_bullets(block: list[str]) -> list[str]:
    bullets: list[str] = []
    for line in block:
        stripped = line.strip()
        if not stripped.startswith("-"):
            continue
        # Exclude any accidental nested field markers
        if re.match(r"^-\s+\*\*.+\*\*:\s*$", stripped):
            continue
        bullet_text = stripped.lstrip("- ").strip()
        if bullet_text:
            bullets.append(bullet_text)
    return bullets


def parse_labels(block: list[str]) -> list[str]:
    raw = first_nonempty_line(block)
    if not raw:
        return []
    try:
        labels = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise ValueError(f"Failed to parse Labels JSON array: {raw}") from exc
    if not isinstance(labels, list) or not all(isinstance(x, str) for x in labels):
        raise ValueError(f"Labels must be a JSON array of strings, got: {raw}")
    return labels


def parse_sdd_entry(chunk: str) -> SddEntry:
    lines = [ln.rstrip("\r\n") for ln in chunk.splitlines()]
    fields: dict[str, list[str]] = {}

    i = 0
    while i < len(lines):
        line = lines[i]
        match = re.match(r"^\s*-\s+\*\*(.+?)\*\*:?\s*$", line)
        if not match:
            i += 1
            continue
        field_name = match.group(1).strip().rstrip(":").strip()
        block, next_i = parse_field_block(lines, i)
        fields[field_name] = block
        i = next_i

    feature_name = first_nonempty_line(fields.get("Feature Name", []))
    if not feature_name:
        raise ValueError("SDD entry missing Feature Name")

    problem_statement_block = fields.get("Problem Statement", [])
    problem_statement = "\n".join([ln.rstrip() for ln in problem_statement_block]).strip()
    if not problem_statement:
        raise ValueError(f"SDD entry '{feature_name}' missing Problem Statement")

    user_stories = parse_bullets(fields.get("User Stories", []))
    acceptance_criteria = parse_bullets(fields.get("Acceptance Criteria", []))
    if not acceptance_criteria:
        raise ValueError(f"SDD entry '{feature_name}' missing Acceptance Criteria")

    dependencies = parse_bullets(fields.get("Dependencies", []))
    target_repo = first_nonempty_line(fields.get("Target Repository", [])).strip()
    if not target_repo:
        raise ValueError(f"SDD entry '{feature_name}' missing Target Repository")
    if target_repo not in ALLOWED_REPOS:
        raise ValueError(
            f"SDD entry '{feature_name}' has invalid Target Repository '{target_repo}'. "
            f"Allowed: {sorted(ALLOWED_REPOS)}"
        )

    labels = parse_labels(fields.get("Labels", []))
    priority = first_nonempty_line(fields.get("Priority", [])).strip()
    if priority not in {"High", "Medium", "Low"}:
        raise ValueError(f"SDD entry '{feature_name}' has invalid Priority '{priority}'")

    return SddEntry(
        feature_name=feature_name,
        problem_statement=problem_statement,
        user_stories=user_stories,
        acceptance_criteria=acceptance_criteria,
        dependencies=dependencies,
        target_repo=target_repo,
        labels=labels,
        priority=priority,
    )


def infer_activity_type(labels: list[str], allowed_activity_types: list[str]) -> str:
    allowed = set(allowed_activity_types)

    # Labels-based defaults (first match wins)
    if "infra" in labels:
        return "DevOps"
    if any(x in labels for x in ["backend", "frontend", "feature"]):
        return "Software Development"
    if "documentation" in labels:
        return "Outreach"

    default = "Software Development"
    if default not in allowed:
        raise ValueError(f"Default activity type '{default}' is not in allowed list")
    return default


def infer_milestone(entry: SddEntry, milestones: list[str]) -> str:
    # Keyword-based mapping (first match wins)
    m1, m2, m3, m4, m5, m6 = milestones

    # Nice to Have override requested by user
    if entry.requirement_id is None and entry.feature_name.lower().startswith("nice to have"):
        return m5

    haystack = normalize_text(
        "\n".join(
            [
                entry.feature_name,
                entry.problem_statement,
                " ".join(entry.acceptance_criteria),
                " ".join(entry.dependencies),
                " ".join(entry.labels),
                entry.target_repo,
            ]
        )
    )

    def has_any(keywords: list[str]) -> bool:
        return any(kw in haystack for kw in keywords)

    # Order 1: Reliability & long-term operations
    if has_any(
        [
            "uptime",
            "health check",
            "monitoring",
            "alerts",
            "logging",
            "backup",
            "restore",
            "disaster recovery",
            "retention",
            "availability",
            "performance",
            "bus factor",
            "access recovery",
            "annual review",
            "operations",
            "long term",
            "takedown",
        ]
    ):
        return m6

    # Order 2: Secure infrastructure & local development
    if has_any(
        [
            "terraform",
            "infrastructure as code",
            "key vault",
            "secret",
            "secrets",
            "rbac",
            "roles and permissions",
            "authentication",
            "https",
            "encryption",
            "network",
            "xss",
            "sanitization",
            "docker compose",
            "ci cd",
            "deployment",
            "staging",
            "production",
            "local development",
        ]
    ):
        return m1

    # Order 3: National court registry & state seeding
    if has_any(
        [
            "court registry",
            "canonical court registry",
            "registry",
            "organization sync",
            "bootstrap",
            "north carolina",
            "south carolina",
            "duplicate detection",
            "identity resolution",
            "state adapter",
            "taxonomy",
            "court id",
            "dry run",
        ]
    ):
        return m2

    # Order 4: Automated ingestion & medallion pipeline
    if has_any(
        [
            "ingestion",
            "etl",
            "pipeline",
            "bronze",
            "silver",
            "gold",
            "medallion",
            "parquet",
            "lineage",
            "hash",
            "transform",
            "adf",
            "data factory",
            "min recrawl interval seconds",
            "min_recrawl_interval_seconds",
            "recrawl",
            "scheduler",
            "custody mode",
            "custody_mode",
            "link only",
            "link_only",
            "copied to blob",
            "copied_to_blob",
            "blob storage",
            "source preservation",
        ]
    ):
        return m4

    # Order 5: Community governance & AI review
    if has_any(
        [
            "submission",
            "pending",
            "moderation",
            "moderator",
            "approve",
            "reject",
            "ai assisted",
            "ai assisted review",
            "ai review",
            "pii",
            "policy violation",
            "badges",
            "review indicator",
            "decision log",
            "audit",
        ]
    ):
        return m5

    # Order 6: Discovery portal & dataset management
    if has_any(
        [
            "create dataset",
            "manage datasets",
            "dataset versions",
            "dataset page",
            "search",
            "discovery",
            "facets",
            "catalog",
            "catalogue",
            "dcat",
            "api endpoint",
            "api endpoints",
            "csv",
            "json",
            "schema metadata",
            "field metadata",
            "provenance summary",
            "terms of use",
        ]
    ):
        return m3

    return m3


def render_issue_body(
    entry: SddEntry,
    criteria_subset: list[str],
    part_index: int,
    part_total: int,
) -> str:
    requirement_line = (
        f"SRS Requirement: {entry.requirement_id}"
        if entry.requirement_id
        else "SRS Section: Nice to Have"
    )

    task_line = (
        f"Implement acceptance criteria for this SDD entry (Part {part_index}/{part_total})."
        if part_total > 1
        else "Implement the acceptance criteria for this SDD entry."
    )

    lines: list[str] = []
    lines.append(f"SDD Feature Name: {entry.feature_name}")
    lines.append(requirement_line)
    lines.append("")
    lines.append("Problem Statement:")
    lines.append(entry.problem_statement)
    lines.append("")
    lines.append("Task:")
    lines.append(task_line)
    lines.append("")
    lines.append("Acceptance Criteria:")
    for criterion in criteria_subset:
        lines.append(f"- [ ] {criterion}")
    lines.append("")
    lines.append("Dependencies:")
    if entry.dependencies:
        for dep in entry.dependencies:
            lines.append(f"- {dep}")
    else:
        lines.append("- None")

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    args = parse_args()

    sdd_path = Path(args.sdd)
    srs_path = Path(args.srs)
    milestones_path = Path(args.milestones)
    activity_types_path = Path(args.activity_types)
    out_path = Path(args.out)

    milestones = parse_milestones(milestones_path)
    activity_types = parse_activity_types(activity_types_path)
    srs_requirement_ids = extract_srs_requirement_ids(srs_path)

    sdd_text = read_text(sdd_path)
    entry_chunks = split_sdd_entries(sdd_text)
    entries: list[SddEntry] = []
    for idx, chunk in enumerate(entry_chunks, start=1):
        try:
            entries.append(parse_sdd_entry(chunk))
        except Exception as exc:  # noqa: BLE001
            snippet = "\n".join(chunk.splitlines()[:40])
            raise ValueError(
                f"Failed to parse SDD entry #{idx}. First lines:\n\n{snippet}\n"
            ) from exc

    issues: list[dict] = []
    covered_ids: set[str] = set()

    for entry in entries:
        milestone = infer_milestone(entry, milestones)
        activity_type = infer_activity_type(entry.labels, activity_types)

        criteria_groups = list(chunked(entry.acceptance_criteria, args.max_criteria_per_issue))
        total = len(criteria_groups)
        for idx, criteria_subset in enumerate(criteria_groups, start=1):
            if total > 1:
                title = f"{entry.feature_name} — Part {idx}/{total}"
            else:
                title = f"{entry.feature_name}"

            body = render_issue_body(entry, criteria_subset, idx, total)
            issues.append(
                {
                    "title": title,
                    "body": body,
                    "repo": entry.target_repo,
                    "milestone": milestone,
                    "activity_type": activity_type,
                    "labels": entry.labels,
                    "priority": entry.priority,
                }
            )

            if entry.requirement_id:
                covered_ids.add(entry.requirement_id)

    missing = sorted(srs_requirement_ids - covered_ids)
    if missing:
        raise SystemExit(
            "ERROR: Missing SRS coverage. The following requirement IDs were not mapped to any issue: "
            + ", ".join(missing)
        )

    out_path.parent.mkdir(parents=True, exist_ok=True)
    if args.pretty:
        out_path.write_text(json.dumps(issues, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    else:
        out_path.write_text(json.dumps(issues, ensure_ascii=False) + "\n", encoding="utf-8")

    print(f"Wrote {len(issues)} issues to {out_path.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
