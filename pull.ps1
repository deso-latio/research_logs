
$repo = $PSScriptRoot
Set-Location $repo

git pull --ff-only origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "Pull failed. Check for local changes or conflicts."
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host "Research logs are up to date!"

Read-Host "Press Enter to close"
