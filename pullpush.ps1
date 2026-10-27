Set-Location "C:\Users\research_logs"

git add .

git diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
    $date = Get-Date -Format "yyyy/MM/dd"
    git commit -m "Update research logs $date"
}

git pull --rebase --autostash
if ($LASTEXITCODE -ne 0) {
    Write-Error "Pull failed. Resolve the issue before pushing."
    exit 1
}

git push

Read-Host "Press Enter to close"