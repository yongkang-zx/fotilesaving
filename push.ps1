# push.ps1 — 后续一键 push 脚本
# 双击即可把当前目录的改动推送到 GitHub

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

# 显示当前状态
$status = git status --short
if (-not $status) {
    Write-Host "✓ 没有改动" -ForegroundColor Green
    exit 0
}

Write-Host "待提交的改动：" -ForegroundColor Yellow
git status --short
Write-Host ""

# 询问 commit message（默认带时间戳）
$defaultMsg = "update: " + (Get-Date -Format "yyyy-MM-dd HH:mm")
$msg = Read-Host "commit message [$defaultMsg]"
if ([string]::IsNullOrWhiteSpace($msg)) { $msg = $defaultMsg }

git add .
git commit -m $msg

Write-Host "`n→ 推送到远程 ..." -ForegroundColor Cyan
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ 推送完成！GitHub Pages 通常 10-30 秒后自动更新" -ForegroundColor Green
} else {
    Write-Host "`n✗ 推送失败" -ForegroundColor Red
    exit 1
}