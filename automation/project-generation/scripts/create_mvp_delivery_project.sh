#!/usr/bin/env bash
set -euo pipefail

# OpenCourts.fyi — MVP Delivery Project
# Creates a GitHub Projects (beta) project and adds custom fields.
#
# Constraints (per prompt):
# - Uses ONLY these gh project commands:
#   gh project create | field-create | item-add | view | edit | field-list | field-update
# - No gh api / GraphQL
#
# NOTE: Re-running this script will create a *new* project with the same title.

OWNER="opencourtsfyi"
TITLE="OpenCourts.fyi — MVP Delivery Project"

# Create the project and capture its number.
PROJECT_NUMBER="$(gh project create --owner "$OWNER" --title "$TITLE" --format json --jq '.number')"

echo "Created project: owner=$OWNER number=$PROJECT_NUMBER title=$TITLE"

# Set project description/readme.
# (These are editable later via the UI; this just provides a useful default.)
README_CONTENT=$(cat <<'EOF'
This project tracks MVP delivery work across the OpenCourts.fyi repositories:

- opencourts-infra
- opencourts-etl
- opencourts-ckan
- opencourts-mock-website
- opencourts-governance

Use the **Area** field to indicate the target repo/component.
Use **Milestone** to align with the governance milestone plan in `design/project-milestones.md`.
EOF
)

gh project edit "$PROJECT_NUMBER" \
  --owner "$OWNER" \
  --description "Cross-repo MVP delivery tracking for OpenCourts.fyi." \
  --readme "$README_CONTENT" \
  --visibility PUBLIC \
  --format json > /dev/null

# -------------------------
# Custom fields
# -------------------------

# Status (single-select: Todo, In Progress, Blocked, Done)
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Status" --data-type "SINGLE_SELECT" \
  --single-select-options "Todo,In Progress,Blocked,Done" \
  --format json > /dev/null

# Priority (single-select: High, Medium, Low)
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Priority" --data-type "SINGLE_SELECT" \
  --single-select-options "High,Medium,Low" \
  --format json > /dev/null

# Area (single-select: Infra, ETL, CKAN, Website, Governance)
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Area" --data-type "SINGLE_SELECT" \
  --single-select-options "Infra,ETL,CKAN,Website,Governance" \
  --format json > /dev/null

# Milestone (single-select: values from design/project-milestones.md; extracted exactly)
# - Milestone 1: Secure Infrastructure & Local Development
# - Milestone 2: National Court Registry & State Seeding
# - Milestone 3: Discovery Portal & Dataset Management
# - Milestone 4: Automated Ingestion & Medallion Pipeline
# - Milestone 5: Community Governance & AI Review
# - Milestone 6: Reliability & Long-term Operations
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Milestone" --data-type "SINGLE_SELECT" \
  --single-select-options "Milestone 1: Secure Infrastructure & Local Development,Milestone 2: National Court Registry & State Seeding,Milestone 3: Discovery Portal & Dataset Management,Milestone 4: Automated Ingestion & Medallion Pipeline,Milestone 5: Community Governance & AI Review,Milestone 6: Reliability & Long-term Operations" \
  --format json > /dev/null

# Target Release (text)
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Target Release" --data-type "TEXT" \
  --format json > /dev/null

# Notes (text)
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Notes" --data-type "TEXT" \
  --format json > /dev/null

# Activity Type
# Prompt requirement: multiple-select with values from volunteer-activity-categories.md.
# Limitation: gh v2.72.0 only supports TEXT|SINGLE_SELECT|DATE|NUMBER for project fields.
# Workaround here: create Activity Type as SINGLE_SELECT using the extracted values exactly.
# Extracted values:
# - DevOps
# - Software Development
# - Data Visualization
# - AI
# - Data Collection and Cleaning
# - Outreach
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Activity Type" --data-type "SINGLE_SELECT" \
  --single-select-options "DevOps,Software Development,Data Visualization,AI,Data Collection and Cleaning,Outreach" \
  --format json > /dev/null

# -------------------------
# Default views & auto-add
# -------------------------
# Prompt requirement: configure default views (Board, Table, Roadmap) and auto-add issues.
# Limitation: the allowed gh project commands do not provide view creation or workflow/auto-add configuration.
# Manual steps in the GitHub UI (Project -> ... menu -> Settings):
# - Views: Create Board, Table, and Roadmap views as desired.
# - Workflows: Enable "Auto-add to project" for issues/PRs from:
#   opencourts-infra, opencourts-etl, opencourts-ckan, opencourts-mock-website, opencourts-governance.

# Print a link to the created project.
PROJECT_URL="$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.url')"
echo "Project URL: $PROJECT_URL"

echo "Done."
