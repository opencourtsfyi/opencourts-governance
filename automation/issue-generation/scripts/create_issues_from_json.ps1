[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$IssuesJsonPath = "automation/issue-generation/out/issues.json",

    [Parameter(Mandatory = $false)]
    [string]$Owner = "opencourtsfyi",

    [Parameter(Mandatory = $false)]
    [bool]$EnsureMilestones = $true,

    [Parameter(Mandatory = $false)]
    [bool]$EnsureLabels = $true,

    [Parameter(Mandatory = $false)]
    [bool]$SkipIfExists = $true,

    [Parameter(Mandatory = $false)]
    [switch]$Apply,

    [Parameter(Mandatory = $false)]
    [int]$Limit = 0,

    [Parameter(Mandatory = $false)]
    [string]$ReportOutPath = "automation/issue-generation/out/created_issues_report.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$DryRun = -not $Apply

function Assert-CommandExists {
    param([Parameter(Mandatory = $true)][string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Invoke-GhJson {
    param(
        [Parameter(Mandatory = $true)][string[]]$Args
    )

    $out = & gh @Args
    if ($LASTEXITCODE -ne 0) {
        throw "gh failed: gh $($Args -join ' ')"
    }

    if (-not $out) {
        return $null
    }

    try {
        return $out | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON from: gh $($Args -join ' ')\nOutput was:\n$out"
    }
}

function Get-MilestonesForRepo {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo
    )

    # GitHub API supports state=open|closed (no 'all'), so query both.
    $open = Invoke-GhJson -Args @(
        'api',
        "repos/$FullRepo/milestones?state=open&per_page=100"
    )
    $closed = Invoke-GhJson -Args @(
        'api',
        "repos/$FullRepo/milestones?state=closed&per_page=100"
    )

    $all = @()
    if ($open) { $all += $open }
    if ($closed) { $all += $closed }
    return $all
}

function Ensure-MilestoneExists {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo,
        [Parameter(Mandatory = $true)][string]$MilestoneTitle
    )

    $milestones = Get-MilestonesForRepo -FullRepo $FullRepo
    $existing = $null
    if ($milestones) {
        $existing = $milestones | Where-Object { $_.title -eq $MilestoneTitle } | Select-Object -First 1
    }

    if ($existing) {
        return $existing
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would create milestone '$MilestoneTitle' in $FullRepo"
        return $null
    }

    Write-Host "Creating milestone '$MilestoneTitle' in $FullRepo"
    return Invoke-GhJson -Args @(
        'api',
        '-X',
        'POST',
        "repos/$FullRepo/milestones",
        '-f',
        "title=$MilestoneTitle"
    )
}

function Get-LabelsForRepo {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo
    )

    return Invoke-GhJson -Args @(
        'api',
        "repos/$FullRepo/labels?per_page=100"
    )
}

function Ensure-LabelExists {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo,
        [Parameter(Mandatory = $true)][string]$LabelName
    )

    $labels = Get-LabelsForRepo -FullRepo $FullRepo
    $existing = $null
    if ($labels) {
        $existing = $labels | Where-Object { $_.name -eq $LabelName } | Select-Object -First 1
    }
    if ($existing) {
        return $existing
    }

    $colorByName = @{
        'backend' = '1D76DB'
        'frontend' = '5319E7'
        'feature' = '0E8A16'
        'infra' = '0052CC'
        'documentation' = '0075CA'
    }

    $color = $colorByName[$LabelName]
    if (-not $color) {
        # Do not invent labels or colors beyond what the generator emits.
        throw "Refusing to create unknown label '$LabelName' in $FullRepo"
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would create label '$LabelName' in $FullRepo"
        return $null
    }

    Write-Host "Creating label '$LabelName' in $FullRepo"
    return Invoke-GhJson -Args @(
        'api',
        '-X',
        'POST',
        "repos/$FullRepo/labels",
        '-f',
        "name=$LabelName",
        '-f',
        "color=$color"
    )
}

function Find-IssueByExactTitle {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo,
        [Parameter(Mandatory = $true)][string]$Title
    )

    # gh issue list search is fuzzy; we still filter exact title in PowerShell.
    $items = Invoke-GhJson -Args @(
        'issue',
        'list',
        '--repo',
        $FullRepo,
        '--state',
        'all',
        '--search',
        $Title,
        '--limit',
        '100',
        '--json',
        'number,title,url'
    )

    if (-not $items) {
        return $null
    }

    return $items | Where-Object { $_.title -eq $Title } | Select-Object -First 1
}

function Create-Issue {
    param(
        [Parameter(Mandatory = $true)][string]$FullRepo,
        [Parameter(Mandatory = $true)][object]$Issue
    )

    $title = [string]$Issue.title
    $body = [string]$Issue.body
    $milestone = [string]$Issue.milestone
    $labels = @()
    if ($Issue.labels -is [System.Collections.IEnumerable]) {
        foreach ($l in $Issue.labels) {
            if ($l -is [string] -and $l.Trim()) {
                $labels += $l.Trim()
            }
        }
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would create issue in $($FullRepo): $title"
        return $null
    }

    $args = @(
        'issue',
        'create',
        '--repo',
        $FullRepo,
        '--title',
        $title,
        '--body',
        $body
    )

    if ($milestone) {
        $args += @('--milestone', $milestone)
    }

    foreach ($l in $labels) {
        $args += @('--label', $l)
    }

    # gh issue create prints the created URL on stdout.
    $createdUrl = & gh @args
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create issue '$title' in $FullRepo"
    }

    return [string]$createdUrl
}

Assert-CommandExists -Name 'gh'

$issuesFile = Resolve-Path -Path $IssuesJsonPath -ErrorAction Stop
$issuesRaw = Get-Content -Path $issuesFile -Raw -Encoding UTF8
$issues = $issuesRaw | ConvertFrom-Json

if (-not ($issues -is [System.Collections.IEnumerable])) {
    throw "Issues JSON must be an array: $IssuesJsonPath"
}

$requiredKeys = @('title','body','repo','milestone','activity_type','labels','priority')

$report = [System.Collections.Generic.List[object]]::new()
$createdCount = 0
$skippedCount = 0
$failedCount = 0

$ensuredMilestones = @{}
$ensuredLabels = @{}

$index = 0
foreach ($issue in $issues) {
    if ($Limit -gt 0 -and $index -ge $Limit) {
        break
    }
    $index++

    foreach ($k in $requiredKeys) {
        if (-not ($issue.PSObject.Properties.Name -contains $k)) {
            throw "Issue #$index is missing required key '$k'"
        }
    }

    $repoSlug = [string]$issue.repo
    $fullRepo = "$Owner/$repoSlug"

    if ($EnsureMilestones -eq $true) {
        $msTitle = [string]$issue.milestone
        $msKey = "$fullRepo|$msTitle"
        if (-not $ensuredMilestones.ContainsKey($msKey)) {
            Ensure-MilestoneExists -FullRepo $fullRepo -MilestoneTitle $msTitle | Out-Null
            $ensuredMilestones[$msKey] = $true
        }
    }

    if ($EnsureLabels -eq $true) {
        foreach ($l in $issue.labels) {
            if ($l -is [string] -and $l.Trim()) {
                $labelName = $l.Trim()
                $labelKey = "$fullRepo|$labelName"
                if (-not $ensuredLabels.ContainsKey($labelKey)) {
                    Ensure-LabelExists -FullRepo $fullRepo -LabelName $labelName | Out-Null
                    $ensuredLabels[$labelKey] = $true
                }
            }
        }
    }

    $existing = $null
    if ($SkipIfExists -eq $true) {
        $existing = Find-IssueByExactTitle -FullRepo $fullRepo -Title ([string]$issue.title)
        if ($existing) {
            Write-Host "Skipping (exists): $fullRepo #$($existing.number) $($existing.title)"
            $skippedCount++
            $report.Add([pscustomobject]@{
                action = 'skipped'
                repo = $fullRepo
                title = [string]$issue.title
                url = $existing.url
                number = $existing.number
            })
            continue
        }
    }

    try {
        $url = Create-Issue -FullRepo $fullRepo -Issue $issue
        $createdCount++
        $report.Add([pscustomobject]@{
            action = ($DryRun ? 'dry_run' : 'created')
            repo = $fullRepo
            title = [string]$issue.title
            url = $url
        })
    } catch {
        $failedCount++
        $report.Add([pscustomobject]@{
            action = 'failed'
            repo = $fullRepo
            title = [string]$issue.title
            error = $_.Exception.Message
        })
        Write-Host "FAILED: $fullRepo :: $($issue.title)"
        Write-Host $_.Exception.Message
    }
}

$reportObj = [pscustomobject]@{
    owner = $Owner
    issues_json = $issuesFile.Path
    ensure_milestones = [bool]$EnsureMilestones
    ensure_labels = [bool]$EnsureLabels
    skip_if_exists = [bool]$SkipIfExists
    dry_run = [bool]$DryRun
    limit = $Limit
    totals = [pscustomobject]@{
        processed = $index
        created = $createdCount
        skipped = $skippedCount
        failed = $failedCount
    }
    results = $report
}

$reportPath = Join-Path -Path (Get-Location) -ChildPath $ReportOutPath
$reportDir = Split-Path -Path $reportPath -Parent
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$reportObj | ConvertTo-Json -Depth 50 | Set-Content -Path $reportPath -Encoding UTF8

Write-Host "Report written to: $ReportOutPath"
Write-Host ("Totals: processed={0} created={1} skipped={2} failed={3} dry_run={4}" -f $index,$createdCount,$skippedCount,$failedCount,[bool]$DryRun)
