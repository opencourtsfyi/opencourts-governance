param(
  [string]$Owner = 'opencourtsfyi',
  [string]$Title = 'OpenCourts.fyi — MVP Delivery Project',
  [int]$ProjectNumber = 0
)

$ErrorActionPreference = 'Stop'

# OpenCourts.fyi — MVP Delivery Project
# Creates a GitHub Projects (beta) project and adds custom fields.
#
# Constraints (per prompt):
# - Uses ONLY these gh project commands:
#   gh project create | field-create | item-add | view | edit | field-list | field-update
# - No gh api / GraphQL
#
# NOTE: Re-running this script will create a *new* project with the same title.

function Invoke-GhProject {
  param(
    [Parameter(Mandatory=$true)][string[]]$Args
  )
  $output = & gh @Args
  if ($LASTEXITCODE -ne 0) {
    throw "gh $($Args -join ' ') failed with exit code $LASTEXITCODE"
  }
  return $output
}

function Get-ProjectFieldsJson {
  param(
    [Parameter(Mandatory=$true)][int]$Number,
    [Parameter(Mandatory=$true)][string]$Owner
  )
  $json = Invoke-GhProject -Args @('project','field-list',"$Number",'--owner',"$Owner",'--format','json')
  return $json | ConvertFrom-Json
}

function Field-Exists {
  param(
    [Parameter(Mandatory=$true)][object]$FieldsJson,
    [Parameter(Mandatory=$true)][string]$Name
  )
  return @($FieldsJson.fields | Where-Object { $_.name -eq $Name }).Count -gt 0
}

function Ensure-SingleSelectField {
  param(
    [Parameter(Mandatory=$true)][int]$Number,
    [Parameter(Mandatory=$true)][string]$Owner,
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][string]$OptionsCsv
  )

  $fieldsJson = Get-ProjectFieldsJson -Number $Number -Owner $Owner
  if (Field-Exists -FieldsJson $fieldsJson -Name $Name) {
    Write-Host "SKIP field-create (exists): $Name"
    return
  }

  Invoke-GhProject -Args @(
    'project','field-create',"$Number",
    '--owner',"$Owner",
    '--name',"$Name",
    '--data-type','SINGLE_SELECT',
    '--single-select-options',"$OptionsCsv",
    '--format','json'
  ) | Out-Null
  Write-Host "CREATED field: $Name"
}

function Ensure-TextField {
  param(
    [Parameter(Mandatory=$true)][int]$Number,
    [Parameter(Mandatory=$true)][string]$Owner,
    [Parameter(Mandatory=$true)][string]$Name
  )

  $fieldsJson = Get-ProjectFieldsJson -Number $Number -Owner $Owner
  if (Field-Exists -FieldsJson $fieldsJson -Name $Name) {
    Write-Host "SKIP field-create (exists): $Name"
    return
  }

  Invoke-GhProject -Args @(
    'project','field-create',"$Number",
    '--owner',"$Owner",
    '--name',"$Name",
    '--data-type','TEXT',
    '--format','json'
  ) | Out-Null
  Write-Host "CREATED field: $Name"
}

if ($ProjectNumber -le 0) {
  # Create the project and capture its number.
  $ProjectNumber = Invoke-GhProject -Args @('project','create','--owner',"$Owner",'--title',"$Title",'--format','json','--jq','.number')
}

Write-Host "Target project: owner=$Owner number=$ProjectNumber title=$Title"

# Set project description/readme.
$ReadmeContent = @'
This project tracks MVP delivery work across the OpenCourts.fyi repositories:

- opencourts-infra
- opencourts-etl
- opencourts-ckan
- opencourts-mock-website
- opencourts-governance

Use the **Area** field to indicate the target repo/component.
Use **Milestone** to align with the governance milestone plan in `design/project-milestones.md`.
'@

Invoke-GhProject -Args @(
  'project','edit',"$ProjectNumber",
  '--owner',"$Owner",
  '--description','Cross-repo MVP delivery tracking for OpenCourts.fyi.',
  '--readme',"$ReadmeContent",
  '--visibility','PUBLIC',
  '--format','json'
) | Out-Null

# -------------------------
# Custom fields
# -------------------------

# Status
# GitHub Projects include a built-in "Status" field by default and gh does not support updating its options.
# To support "Blocked" explicitly, create a custom field that doesn't conflict.
Ensure-SingleSelectField -Number $ProjectNumber -Owner $Owner -Name 'MVP Status' -OptionsCsv 'Todo,In Progress,Blocked,Done'

# Priority (single-select: High, Medium, Low)
Ensure-SingleSelectField -Number $ProjectNumber -Owner $Owner -Name 'Priority' -OptionsCsv 'High,Medium,Low'

# Area (single-select: Infra, ETL, CKAN, Website, Governance)
Ensure-SingleSelectField -Number $ProjectNumber -Owner $Owner -Name 'Area' -OptionsCsv 'Infra,ETL,CKAN,Website,Governance'

# Milestone
# GitHub Projects include a built-in "Milestone" field tied to GitHub issue milestones, so a custom field
# with the exact name conflicts. Create a custom field with a distinct name for the program milestones.
$MilestoneOptions = 'Milestone 1: Secure Infrastructure & Local Development,Milestone 2: National Court Registry & State Seeding,Milestone 3: Discovery Portal & Dataset Management,Milestone 4: Automated Ingestion & Medallion Pipeline,Milestone 5: Community Governance & AI Review,Milestone 6: Reliability & Long-term Operations'
Ensure-SingleSelectField -Number $ProjectNumber -Owner $Owner -Name 'Program Milestone' -OptionsCsv $MilestoneOptions

# Target Release (text)
Ensure-TextField -Number $ProjectNumber -Owner $Owner -Name 'Target Release'

# Notes (text)
Ensure-TextField -Number $ProjectNumber -Owner $Owner -Name 'Notes'

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
$ActivityOptions = 'DevOps,Software Development,Data Visualization,AI,Data Collection and Cleaning,Outreach'
Ensure-SingleSelectField -Number $ProjectNumber -Owner $Owner -Name 'Activity Type' -OptionsCsv $ActivityOptions

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
$ProjectUrl = Invoke-GhProject -Args @('project','view',"$ProjectNumber",'--owner',"$Owner",'--format','json','--jq','.url')
Write-Host "Project URL: $ProjectUrl"
Write-Host 'Done.'
