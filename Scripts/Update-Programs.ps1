Write-Host "`n===== Updating GitHub releases..." -ForegroundColor Cyan
Update-GitHubReleases

Write-Host "`n===== Updating Lastrosade builds..." -ForegroundColor Cyan
Update-LastrosadeBuilds

Write-Host "`n===== Sorting binaries..." -ForegroundColor Cyan
Sort-Binaries

Write-Host "`n===== Updating mpv..." -ForegroundColor Cyan
& "D:\Programs\Video\mpv\updater.bat"

Write-Host "`n===== Updating rclone..." -ForegroundColor Cyan
rclone.exe selfupdate

Write-Host "`n===== Updating uv tools..." -ForegroundColor Cyan
uv.exe tool upgrade --all

Write-Host "`n===== Updating winget packages..." -ForegroundColor Cyan
winget.exe upgrade --all

Write-Host "`n===== Updating TinyTex..." -ForegroundColor Cyan
tlmgr.bat update --self --all
