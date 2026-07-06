# init.ps1 — 首次部署脚本
# 用法：.\init.ps1 -RepoName "用户名/仓库名" -Token "ghp_xxx"

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,

    [Parameter(Mandatory=$true)]
    [string]$Token
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== 方太·职前 AI 工作台 · 首次部署 ===`n" -ForegroundColor Yellow

# 1. 检查 git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "✗ 未找到 git，请先安装 Git for Windows" -ForegroundColor Red
    exit 1
}

# 2. 设置本仓库的 git user
git config user.name "yongkang-zx"
git config user.email "yongkang-zx@users.noreply.github.com"
Write-Host "✓ git user 配置完成" -ForegroundColor Green

# 3. 初始化仓库
if (-not (Test-Path ".git")) {
    git init -b main | Out-Null
    Write-Host "✓ git 仓库初始化完成" -ForegroundColor Green
} else {
    Write-Host "✓ git 仓库已存在" -ForegroundColor Green
}

# 4. 配置 remote
$remoteUrl = "https://${Token}@github.com/${RepoName}.git"
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    git remote set-url origin $remoteUrl
    Write-Host "✓ remote URL 已更新" -ForegroundColor Green
} else {
    git remote add origin $remoteUrl
    Write-Host "✓ remote 已添加" -ForegroundColor Green
}

# 5. 添加并提交
git add .
$status = git status --porcelain
if ($status) {
    git commit -m "feat: 初始化方太·职前 AI 课程设计工作台"
    Write-Host "✓ 首次提交完成" -ForegroundColor Green
} else {
    Write-Host "✓ 没有改动需要提交" -ForegroundColor Green
}

# 6. 推送到 main
Write-Host "`n→ 推送到 $RepoName ..." -ForegroundColor Cyan
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ 部署完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Yellow
    Write-Host "  1. 打开 https://github.com/$RepoName/settings/pages"
    Write-Host "  2. Source 选 'main' 分支 → Save"
    Write-Host "  3. 等 30 秒，访问 https://$(($RepoName -split '/')[0]).github.io/$(($RepoName -split '/')[1])/"
    Write-Host ""
    Write-Host "以后修改后，双击 push.ps1 即可一键更新" -ForegroundColor Cyan
} else {
    Write-Host "`n✗ 推送失败，请检查 token 是否有 'repo' 权限" -ForegroundColor Red
    exit 1
}