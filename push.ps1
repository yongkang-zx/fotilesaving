# push.ps1 — 后续一键 push 到 GitHub
# 已配置好仓库 yongkang-zx/fotilesaving

$ErrorActionPreference = "Stop"

Write-Host "`n=== 方太·职前 AI 工作台 · 推送更新 ===`n" -ForegroundColor Cyan

if (-not (Test-Path ".git")) {
    Write-Host "✗ 当前目录不是 git 仓库，请先运行 init.ps1" -ForegroundColor Red
    exit 1
}

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    Write-Host "✗ 未配置 remote，请先运行 init.ps1" -ForegroundColor Red
    exit 1
}

$status = git status --short
if (-not $status) {
    Write-Host "✓ 没有改动，无需推送" -ForegroundColor Green
    Read-Host "按回车退出"
    exit 0
}

Write-Host "待提交改动：" -ForegroundColor Yellow
git status --short
Write-Host ""

$defaultMsg = "update: " + (Get-Date -Format "yyyy-MM-dd HH:mm")
$msg = Read-Host "commit message [$defaultMsg]"
if ([string]::IsNullOrWhiteSpace($msg)) { $msg = $defaultMsg }

git add .
git commit -m $msg 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 提交失败" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

Write-Host "`n→ 推送到远程 ..." -ForegroundColor Cyan
git push origin main 2>&1 | Tee-Object -Variable pushOutput | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ 推送完成！" -ForegroundColor Green
    Write-Host "GitHub Pages 通常 10-30 秒后自动更新" -ForegroundColor Cyan
} else {
    Write-Host "`n✗ 推送失败，错误信息：" -ForegroundColor Red
    Write-Host $pushOutput -ForegroundColor Red
}

Read-Host "按回车退出"