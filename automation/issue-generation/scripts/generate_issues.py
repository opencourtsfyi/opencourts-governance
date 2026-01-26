"""Generate GitHub-issue JSON from project documents.

This is intentionally lightweight and dependency-free to keep volunteer setup easy.

Usage:
  python automation/issue-generation/scripts/generate_issues.py \
        --input charter/project-charter.md design/software-requirements-specification.md design/software-design-document.md \
    --output automation/issue-generation/examples/sample-output.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", nargs="+", required=True, help="Input markdown files")
    parser.add_argument("--output", required=True, help="Output JSON path")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    inputs = [Path(p) for p in args.input]
    output = Path(args.output)

    # Placeholder implementation: emit a minimal manifest until AI integration is wired up.
    issues: list[dict[str, Any]] = []
    for path in inputs:
        text = path.read_text(encoding="utf-8")
        issues.append(
            {
                "title": f"Review and break down: {path.as_posix()}",
                "body": "Create volunteer-sized tasks from this document.\n\n"
                + "Document excerpt (first 400 chars):\n\n"
                + text[:400],
                "labels": ["triage", "automation"],
                "priority": "medium",
                "source": path.as_posix(),
            }
        )

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(issues, indent=2), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
