[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectUrl = "https://github.com/orgs/opencourtsfyi/projects/1",

    [Parameter(Mandatory = $false)]
    [string]$Owner = "opencourtsfyi",

    [Parameter(Mandatory = $false)]
    [int]$ProjectNumber = 1,

    [Parameter(Mandatory = $false)]
    [string]$CreatedIssuesReportPath = "automation/issue-generation/out/created_issues_report.json",

    [Parameter(Mandatory = $false)]
    [string]$IssuesJsonPath = "automation/issue-generation/out/issues.json",

    [Parameter(Mandatory = $false)]
    [string]$ProjectItemAddReportPath = "automation/project-generation/out/project_item_add_report.json",

    [Parameter(Mandatory = $false)]
    [switch]$SyncOnly,

    [Parameter(Mandatory = $false)]
    [switch]$UpdateIssues,

    [Parameter(Mandatory = $false)]
    [switch]$UpdateProjectFields,

    [Parameter(Mandatory = $false)]
    [string]$ProjectProgramMilestoneFieldName = "Program Milestone",

    [Parameter(Mandatory = $false)]
    [string]$ProjectActivityTypeFieldName = "Activity Type",

    [Parameter(Mandatory = $false)]
    [switch]$Apply,

    [Parameter(Mandatory = $false)]
    [int]$Limit = 0,

    [Parameter(Mandatory = $false)]
    [int]$ThrottleSeconds = 0,

    [Parameter(Mandatory = $false)]
    [switch]$StopOnRateLimit,

    [Parameter(Mandatory = $false)]
    [string]$OutReportPath = "automation/project-generation/out/project_item_add_report.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('StopOnRateLimit')) {
    $StopOnRateLimit = $true
}

function Assert-CommandExists {
    param([Parameter(Mandatory = $true)][string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Invoke-GhJson {
    param(
        [Parameter(Mandatory = $true)][string[]]$GhArgs
    )

    $out = & gh @GhArgs
    if ($LASTEXITCODE -ne 0) {
        throw "gh failed: gh $($GhArgs -join ' ')"
    }

    if (-not $out) {
        return $null
    }

    try {
        return $out | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON from: gh $($GhArgs -join ' ')\nOutput was:\n$out"
    }
}

function Normalize-Key {
    param([Parameter(Mandatory = $true)][string]$Value)

    $v = $Value.ToLowerInvariant()
    $v = $v -replace "\s+", " "
    # Normalize common dash variants used in titles.
    $v = $v -replace "[\u2010\u2011\u2012\u2013\u2014\u2212]", "-"
    return $v.Trim()
}

function Parse-IssueUrl {
    param([Parameter(Mandatory = $true)][string]$Url)

    $m = [regex]::Match($Url, "^https://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/issues/(?<num>\d+)(?:$|\?.*)")
    if (-not $m.Success) {
        throw "Unrecognized GitHub issue URL: $Url"
    }

    return [pscustomobject]@{
        owner  = $m.Groups['owner'].Value
        repo   = $m.Groups['repo'].Value
        number = [int]$m.Groups['num'].Value
    }
}

function Get-ProjectMeta {
    param(
        [Parameter(Mandatory = $true)][int]$Number,
        [Parameter(Mandatory = $true)][string]$Owner
    )

    return Invoke-GhJson -GhArgs @(
        'project',
        'view',
        "$Number",
        '--owner',
        $Owner,
        '--format',
        'json'
    )
}

function Get-ProjectFields {
    param(
        [Parameter(Mandatory = $true)][int]$Number,
        [Parameter(Mandatory = $true)][string]$Owner
    )

    return Invoke-GhJson -GhArgs @(
        'project',
        'field-list',
        "$Number",
        '--owner',
        $Owner,
        '--format',
        'json'
    )
}

function Get-ProjectItems {
    param(
        [Parameter(Mandatory = $true)][int]$Number,
        [Parameter(Mandatory = $true)][string]$Owner,
        [Parameter(Mandatory = $false)][int]$Limit = 200
    )

    return Invoke-GhJson -GhArgs @(
        'project',
        'item-list',
        "$Number",
        '--owner',
        $Owner,
        '--limit',
        "$Limit",
        '--format',
        'json'
    )
}

function Get-ActivityLabelColor {
    param([Parameter(Mandatory = $true)][string]$ActivityType)

    switch ($ActivityType) {
        'DevOps' { return '1f6feb' }
        'Software Development' { return 'a371f7' }
        'Data Visualization' { return '0969da' }
        'AI' { return '8250df' }
        'Data Collection and Cleaning' { return '0e8a16' }
        'Outreach' { return 'fbca04' }
        default { return '57606a' }
    }
}

function Invoke-GhApiJson {
    param(
        [Parameter(Mandatory = $true)][string[]]$GhApiArgs
    )

    $out = & gh api @GhApiArgs
    if ($LASTEXITCODE -ne 0) {
        throw "gh api failed: gh api $($GhApiArgs -join ' ')"
    }

    if (-not $out) {
        return $null
    }

    try {
        return $out | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON from: gh api $($GhApiArgs -join ' ')\nOutput was:\n$out"
    }
}

function Get-MilestoneNumberByTitle {
    param(
        [Parameter(Mandatory = $true)][string]$RepoFull,
        [Parameter(Mandatory = $true)][string]$MilestoneTitle
    )

    $RepoFull = $RepoFull.Trim()
    $MilestoneTitle = $MilestoneTitle.Trim()

    if (-not (Get-Variable -Name 'MilestoneCache' -Scope Script -ErrorAction SilentlyContinue)) {
        $script:MilestoneCache = @{}
    }

    $cacheKey = Normalize-Key -Value ($RepoFull + "|" + $MilestoneTitle)
    if ($script:MilestoneCache.ContainsKey($cacheKey)) {
        return $script:MilestoneCache[$cacheKey]
    }

    $list = Invoke-GhApiJson -GhApiArgs @(
        'repos/' + $RepoFull + '/milestones'
    )

    $ms = $null
    foreach ($m in $list) {
        if ($m.title -eq $MilestoneTitle) {
            $ms = $m
            break
        }
    }

    if (-not $ms) {
        throw "Milestone not found in ${RepoFull}: '$MilestoneTitle'"
    }

    $script:MilestoneCache[$cacheKey] = [int]$ms.number
    return [int]$ms.number
}

Assert-CommandExists -Name 'gh'

$dryRun = -not $Apply

if (-not $UpdateIssues -and -not $UpdateProjectFields) {
    # If the user didn't specify, default to doing both when applying (safe defaults).
    $UpdateIssues = $true
    $UpdateProjectFields = $true
}

$needsProjectOps = (-not $SyncOnly) -or $UpdateProjectFields

if ($needsProjectOps) {
    try {
        $rl = (& gh api rate_limit) | ConvertFrom-Json
        if ($rl -and $rl.resources -and $rl.resources.graphql -and ($rl.resources.graphql.remaining -le 0)) {
            $reset = [DateTimeOffset]::FromUnixTimeSeconds([int64]$rl.resources.graphql.reset).ToLocalTime()
            throw "GitHub GraphQL rate limit is exhausted. Re-run after: $reset"
        }
    } catch {
        # If rate-limit preflight fails, proceed and let underlying commands report errors.
    }
}

$project = $null
$projectId = $null
$fieldList = $null
$programMilestoneField = $null
$activityTypeField = $null

if ($needsProjectOps) {
    # Basic sanity check: confirm we can view the project.
    $project = Get-ProjectMeta -Number $ProjectNumber -Owner $Owner
    if (-not $project) {
        throw "Unable to retrieve project metadata. Check auth scopes: gh auth status"
    }
    if ($project.url -ne $ProjectUrl) {
        Write-Host "Warning: Project URL mismatch. Script is configured for $ProjectUrl but gh returned $($project.url)"
    }

    $projectId = $project.id
    if (-not $projectId) {
        throw "Project metadata did not include an id; cannot edit project items."
    }

    $fieldList = Get-ProjectFields -Number $ProjectNumber -Owner $Owner
    if (-not $fieldList -or -not $fieldList.fields) {
        throw "Unable to retrieve project fields."
    }

    $programMilestoneField = $fieldList.fields | Where-Object { $_.name -eq $ProjectProgramMilestoneFieldName } | Select-Object -First 1
    $activityTypeField = $fieldList.fields | Where-Object { $_.name -eq $ProjectActivityTypeFieldName } | Select-Object -First 1

    if ($UpdateProjectFields) {
        if (-not $programMilestoneField) {
            throw "Project field '$ProjectProgramMilestoneFieldName' not found."
        }
        if (-not $activityTypeField) {
            throw "Project field '$ProjectActivityTypeFieldName' not found."
        }
        if (-not $programMilestoneField.options) {
            throw "Project field '$ProjectProgramMilestoneFieldName' has no options; expected a single-select field."
        }
        if (-not $activityTypeField.options) {
            throw "Project field '$ProjectActivityTypeFieldName' has no options; expected a single-select field."
        }
    }
}

$reportPath = Resolve-Path -Path $CreatedIssuesReportPath -ErrorAction Stop
$report = (Get-Content -Path $reportPath -Raw -Encoding UTF8) | ConvertFrom-Json

if (-not $report.results) {
    throw "No 'results' array found in $CreatedIssuesReportPath"
}

$issuesPath = Resolve-Path -Path $IssuesJsonPath -ErrorAction Stop
$issues = (Get-Content -Path $issuesPath -Raw -Encoding UTF8) | ConvertFrom-Json

if (-not $issues) {
    throw "No issues found in $IssuesJsonPath"
}

# Build lookup by (repo, title) with normalization.
$issueLookup = @{}
foreach ($iss in $issues) {
    $key = (Normalize-Key -Value ($iss.repo + "|" + $iss.title))
    $issueLookup[$key] = $iss
}

$targets = New-Object System.Collections.Generic.List[object]
foreach ($r in $report.results) {
    if ($null -eq $r.url -or -not ([string]$r.url).Trim()) {
        continue
    }
    if ($null -eq $r.title -or -not ([string]$r.title).Trim()) {
        continue
    }
    if ($null -eq $r.repo -or -not ([string]$r.repo).Trim()) {
        continue
    }

    $targets.Add([pscustomobject]@{
        repo_full = ([string]$r.repo).Trim()
        title = ([string]$r.title).Trim()
        url = ([string]$r.url).Trim()
    })
}

# de-dupe by URL
$targets = $targets | Sort-Object -Property url -Unique

$processed = 0
$added = 0
$updatedIssues = 0
$updatedProjectItems = 0
$skipped = 0
$failed = 0

$results = New-Object System.Collections.Generic.List[object]

$rateLimitHit = $false

# Build item-id map from the last add report (useful for SyncOnly runs).
$itemIdByUrl = @{}
try {
    $priorAddReportPath = Resolve-Path -Path $ProjectItemAddReportPath -ErrorAction Stop
    $priorAddReport = (Get-Content -Path $priorAddReportPath -Raw -Encoding UTF8) | ConvertFrom-Json
    if ($priorAddReport -and $priorAddReport.results) {
        foreach ($rr in $priorAddReport.results) {
            if ($rr.item -and $rr.item.id -and $rr.url) {
                $itemIdByUrl[([string]$rr.url).Trim()] = ([string]$rr.item.id).Trim()
            }
        }
    }
} catch {
    # Optional; if missing we'll resolve via item-list.
}

if ($UpdateProjectFields -and $needsProjectOps -and $itemIdByUrl.Count -lt $targets.Count) {
    # Prefetch all project items once and map URL -> item ID to avoid per-issue lookups.
    try {
        $items = Get-ProjectItems -Number $ProjectNumber -Owner $Owner -Limit 200
        if ($items -and $items.items) {
            foreach ($it in $items.items) {
                if ($it.content -and $it.content.url -and $it.id) {
                    $u = ([string]$it.content.url).Trim()
                    if (-not $itemIdByUrl.ContainsKey($u)) {
                        $itemIdByUrl[$u] = ([string]$it.id).Trim()
                    }
                }
            }
        }
    } catch {
        # We'll fail later when setting fields if an item id can't be resolved.
    }
}

$ensuredActivityLabels = @{}

foreach ($t in $targets) {
    if ($rateLimitHit) {
        break
    }
    if ($Limit -gt 0 -and $processed -ge $Limit) {
        break
    }
    $processed++

    $url = $t.url
    $repoFull = $t.repo_full
    $title = $t.title

    $repoName = $repoFull
    if ($repoName.StartsWith($Owner + '/')) {
        $repoName = $repoName.Substring($Owner.Length + 1)
    } elseif ($repoName -match '^[^/]+/.+$') {
        $repoName = $repoName.Split('/')[1]
    }

    $expectedKey = Normalize-Key -Value ($repoName + "|" + $title)
    $expected = $null
    if ($issueLookup.ContainsKey($expectedKey)) {
        $expected = $issueLookup[$expectedKey]
    } else {
        $results.Add([pscustomobject]@{ action='failed'; url=$url; error="Could not find matching issue in issues.json for repo='$repoName' title='$title'" })
        $failed++
        continue
    }

    $expectedMilestone = [string]$expected.milestone
    $expectedActivityType = [string]$expected.activity_type

    $activityLabel = "activity: $expectedActivityType"
    $activityLabelColor = Get-ActivityLabelColor -ActivityType $expectedActivityType
    $activityLabelDesc = "Volunteer activity type: $expectedActivityType"

    if ($dryRun) {
        if (-not $SyncOnly) {
            Write-Host "[DRY RUN] Would add to project #$ProjectNumber ($Owner): $url"
        }
        if ($UpdateIssues) {
            Write-Host "[DRY RUN] Would update issue: $repoFull :: $title (milestone='$expectedMilestone', add-label='$activityLabel')"
        }
        if ($UpdateProjectFields) {
            Write-Host "[DRY RUN] Would set project fields for item: Program Milestone='$expectedMilestone', Activity Type='$expectedActivityType'"
        }

        $skipped++
        $results.Add([pscustomobject]@{ action='dry_run'; url=$url; repo=$repoFull; title=$title; milestone=$expectedMilestone; activity_type=$expectedActivityType })
        continue
    }

    try {
        $item = $null

        if (-not $SyncOnly) {
            # gh project item-add returns JSON only with --format json.
            $item = Invoke-GhJson -Args @(
                'project',
                'item-add',
                "$ProjectNumber",
                '--owner',
                $Owner,
                '--url',
                $url,
                '--format',
                'json'
            )
            $added++
            if ($item -and $item.id) {
                $itemIdByUrl[$url] = $item.id
            }
        }

        if ($UpdateIssues) {
            $parsed = Parse-IssueUrl -Url $url
            $issueRepo = "$($parsed.owner)/$($parsed.repo)"

            # Ensure the activity label exists, then add it + sync milestone.
            $labelEnsureKey = Normalize-Key -Value ($issueRepo + "|" + $activityLabel)
            if (-not $ensuredActivityLabels.ContainsKey($labelEnsureKey)) {
                & gh label create "$activityLabel" -R $issueRepo -c $activityLabelColor -d "$activityLabelDesc" -f | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    throw "Failed ensuring label '$activityLabel' on $issueRepo"
                }
                $ensuredActivityLabels[$labelEnsureKey] = $true
            }

            $milestoneNumber = Get-MilestoneNumberByTitle -RepoFull $issueRepo -MilestoneTitle $expectedMilestone

            # PATCH milestone via REST.
            & gh api ("repos/{0}/issues/{1}" -f $issueRepo, $parsed.number) -X PATCH -f milestone=$milestoneNumber | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed updating issue milestone: $issueRepo#$($parsed.number)"
            }

            # Add activity label via REST without replacing existing labels.
            & gh api ("repos/{0}/issues/{1}/labels" -f $issueRepo, $parsed.number) -X POST -f "labels[]=$activityLabel" | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed adding activity label: $issueRepo#$($parsed.number)"
            }

            $updatedIssues++
        }

        if ($UpdateProjectFields) {
            $itemId = $null
            if ($item -and $item.id) {
                $itemId = $item.id
            } else {
                if ($itemIdByUrl.ContainsKey($url)) {
                    $itemId = $itemIdByUrl[$url]
                }
            }

            if (-not $itemId) {
                throw "Unable to resolve project item id for URL: $url"
            }

            $pmOption = $programMilestoneField.options | Where-Object { $_.name -eq $expectedMilestone } | Select-Object -First 1
            if (-not $pmOption) {
                throw "No option '$expectedMilestone' found for project field '$ProjectProgramMilestoneFieldName'"
            }

            $atOption = $activityTypeField.options | Where-Object { $_.name -eq $expectedActivityType } | Select-Object -First 1
            if (-not $atOption) {
                throw "No option '$expectedActivityType' found for project field '$ProjectActivityTypeFieldName'"
            }

            & gh project item-edit --project-id $projectId --id $itemId --field-id $programMilestoneField.id --single-select-option-id $pmOption.id --format json | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed setting Program Milestone for item $itemId"
            }

            & gh project item-edit --project-id $projectId --id $itemId --field-id $activityTypeField.id --single-select-option-id $atOption.id --format json | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed setting Activity Type for item $itemId"
            }

            $updatedProjectItems++
        }

        $results.Add([pscustomobject]@{ action='ok'; url=$url; repo=$repoFull; title=$title; item=$item; milestone=$expectedMilestone; activity_type=$expectedActivityType })

        if ($ThrottleSeconds -gt 0) {
            Start-Sleep -Seconds $ThrottleSeconds
        }
    } catch {
        if ($_.Exception.Message -match 'rate limit') {
            $rateLimitHit = $true
        }
        $failed++
        $results.Add([pscustomobject]@{ action='failed'; url=$url; repo=$repoFull; title=$title; error=$_.Exception.Message })
        Write-Host "FAILED: $url"
        Write-Host $_.Exception.Message

        if ($rateLimitHit -and $StopOnRateLimit) {
            Write-Host "Stopping early due to API rate limit. Re-run later to continue."
            break
        }
    }
}

$outObj = [pscustomobject]@{
    project_url = $ProjectUrl
    owner = $Owner
    project_number = $ProjectNumber
    dry_run = [bool]$dryRun
    created_issues_report = $reportPath.Path
    totals = [pscustomobject]@{
        processed = $processed
        added = $added
        updated_issues = $updatedIssues
        updated_project_items = $updatedProjectItems
        skipped = $skipped
        failed = $failed
    }
    results = $results
}

$outFile = Join-Path -Path (Get-Location) -ChildPath $OutReportPath
$outDir = Split-Path -Path $outFile -Parent
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$outObj | ConvertTo-Json -Depth 50 | Set-Content -Path $outFile -Encoding UTF8

Write-Host "Report written to: $OutReportPath"
Write-Host ("Totals: processed={0} added={1} updated_issues={2} updated_project_items={3} skipped={4} failed={5} dry_run={6}" -f $processed,$added,$updatedIssues,$updatedProjectItems,$skipped,$failed,[bool]$dryRun)
