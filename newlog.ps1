
$repo = "C:\Users\research_logs"

$today = Get-Date
$date = $today.ToString("yyyy_MM_dd")
$displayDate = $today.ToString("yyyy/MM/dd")

# Today's monthly directory: YYYY_MM
$monthName = $today.ToString("yyyy_MM")
$monthDir = Join-Path $repo $monthName

# Automatically create the directory if it doesn't exist
New-Item -ItemType Directory -Path $monthDir -Force | Out-Null

$file = Join-Path $monthDir "$date.md"

# Don't overwrite an existing log
if (Test-Path $file) {
    Write-Host "Today's log already exists."
    code $file
    return
}

# Find the most recent previous log, month by month
$previousLog = $null
$searchMonth = $today

while (-not $previousLog) {
    $searchDir = Join-Path $repo $searchMonth.ToString("yyyy_MM")

    if (Test-Path $searchDir) {
        $previousLog = Get-ChildItem $searchDir -Filter "*.md" -File |
            Where-Object {
                $_.BaseName -match '^\d{4}_\d{2}_\d{2}$' -and
                $_.BaseName -lt $date
            } |
            Sort-Object BaseName -Descending |
            Select-Object -First 1
    }

    if ($previousLog) { break }

    # Search backward, up to 10 years
    $searchMonth = $searchMonth.AddMonths(-1)

    if ($searchMonth -lt $today.AddYears(-10)) {
        break
    }
}

if ($previousLog) {
    $previousDate = [datetime]::ParseExact(
        $previousLog.BaseName,
        "yyyy_MM_dd",
        $null
    ).ToString("yyyy/MM/dd")
}
else {
    $previousDate = "N/A"
}

# Generate today's log
$content = @"
# personal and research log
### $displayDate

---
## personal
1.

---
## research

*1. review of previous workday, $previousDate*
2. Optionally review a recent news.
3.
---
## 1. review $previousDate

---

"@

Set-Content -Path $file -Value $content -Encoding UTF8

Write-Host "Created: $file"
Write-Host "Previous log: $previousDate"

code $file
