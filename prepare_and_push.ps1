<#
prepare_and_push.ps1

Usage:
  - Open PowerShell
  - cd to the parent folder that contains the Web_Author_Profile folder (or pass a full source path)
  - Run: .\prepare_and_push.ps1

What this script does (interactive):
  1. Clones your GitHub repo to a temp folder
  2. Copies the contents of the Web_Author_Profile folder into the cloned repo
  3. Checks for files > 50MB and lists them
  4. Asks you to confirm (you can remove large files manually or let script skip videos)
  5. Commits and pushes to origin/main

Note: You must have git installed and be authenticated to GitHub (PAT, credential manager, or SSH).
#>

Param()

# Change this if your repo URL is different
$RepoUrl = 'https://github.com/rdhall1963/profile.rdewebsites.com.git'

Write-Host "\n--- Web Author Profile -> GitHub push helper ---\n" -ForegroundColor Cyan

# Determine source folder
$cwd = Get-Location
$defaultSource = Join-Path $cwd 'Web_Author_Profile'
if (-Not (Test-Path $defaultSource)) {
    $source = Read-Host "Enter full path to your Web_Author_Profile folder"
    if (-Not (Test-Path $source)) {
        Write-Error "Source folder doesn't exist. Aborting."
        exit 1
    }
} else {
    $source = $defaultSource
}

# Create temp clone folder
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
Write-Host "Cloning repo $RepoUrl to temporary folder: $tmp" -ForegroundColor Yellow

git --version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "git not found in PATH. Please install git and try again."; exit 1
}

git clone $RepoUrl $tmp
if ($LASTEXITCODE -ne 0) { Write-Error "git clone failed. Check the repo URL and your network/auth."; exit 1 }

# Copy files into clone
Write-Host "Copying files from $source into $tmp (this will overwrite files in the cloned repo)" -ForegroundColor Yellow
Copy-Item -Path (Join-Path $source '*') -Destination $tmp -Recurse -Force

# Ensure .gitignore from source (if present) is used; otherwise create a default .gitignore
if (-Not (Test-Path (Join-Path $tmp '.gitignore'))) {
    if (Test-Path (Join-Path $source '.gitignore')) {
        Copy-Item (Join-Path $source '.gitignore') (Join-Path $tmp '.gitignore') -Force
    }
}

# Check for large files (>50MB)
Write-Host "\nScanning for files > 50MB in the repo copy..." -ForegroundColor Cyan
$large = Get-ChildItem -Path $tmp -Recurse -File | Where-Object { $_.Length -gt 50MB } | Sort-Object Length -Descending
if ($large) {
    Write-Host "Found the following large files (>50MB):" -ForegroundColor Red
    $large | Select-Object FullName, @{Name='MB';Expression={[math]::Round($_.Length/1MB,2)}} | Format-Table -AutoSize
    Write-Host "\nGitHub will reject files >100MB; consider removing or hosting them externally (YouTube/Vimeo) or using Git LFS." -ForegroundColor Yellow
    $choice = Read-Host "Do you want to continue and omit .mp4/.mov files automatically? (y/N)"
    if ($choice -match '^[yY]') {
        Get-ChildItem -Path $tmp -Recurse -Include *.mp4,*.mov | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "Removed .mp4/.mov files from the repo copy." -ForegroundColor Green
    } else {
        Write-Host "Please remove large files from $tmp before pushing, or press Ctrl+C to abort." -ForegroundColor Yellow
        Read-Host "Press Enter to continue after cleanup (or Ctrl+C to abort)"
    }
} else {
    Write-Host "No files over 50MB found." -ForegroundColor Green
}

# Commit & push
Push-Location $tmp
Write-Host "\nReady to add/commit/push changes in: $tmp" -ForegroundColor Cyan
git status --porcelain
$confirm = Read-Host "Add all changes, commit with message 'Add Web_Author_Profile site' and push to origin/main? (y/N)"
if ($confirm -match '^[yY]') {
    git add .
    git commit -m "Add Web_Author_Profile site"
    if ($LASTEXITCODE -ne 0) { Write-Host "Nothing to commit or commit failed." -ForegroundColor Yellow }
    git push origin main
    if ($LASTEXITCODE -eq 0) { Write-Host "Push completed successfully." -ForegroundColor Green }
    else { Write-Error "Push failed. Check authentication / branch protection." }
} else {
    Write-Host "Aborted by user. No push was performed." -ForegroundColor Yellow
}
Pop-Location

Write-Host "\nTemporary repo copy remains at: $tmp (you can delete it)" -ForegroundColor Cyan
Write-Host "If you want, enable GitHub Pages in repository settings -> Pages, branch 'main' and root (/)." -ForegroundColor Cyan
