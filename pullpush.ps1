
$repo = $PSScriptRoot
Set-Location $repo

git add .
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git add failed."
    exit 1
}

git diff --cached --quiet

if ($LASTEXITCODE -eq 1) {
    $date = Get-Date -Format "yyyy/MM/dd"
    git commit -m "Update research logs $date"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Commit failed."
        exit 1
    }
}
elseif ($LASTEXITCODE -ne 0) {
    Write-Error "Unable to check staged changes."
    exit 1
}

git pull --rebase --autostash origin main

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pull failed. Resolve the issue before pushing."
    exit 1
}

git push origin main

if ($LASTEXITCODE -ne 0) {
    Write-Error "Push failed."
    exit 1
}

Write-Host "Research logs synchronized successfully!"

Read-Host "Press Enter to close"
