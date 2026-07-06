# init.ps1 — 首次部署脚本（已配置好仓库，直接用）
# 如需部署到别的仓库：.\init.ps1 -RepoName "用户名/仓库名" -Token "ghp_xxx"

param(
    [string]$RepoName = "yongkang-zx/fotilesaving",
    [string]$Token
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== 方太·职前 AI 工作台 · 首次部署 ===`n" -ForegroundColor Yellow

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "✗ 未找到 git，请先安装 Git for Windows" -ForegroundColor Red
    exit 1
}

# 如果没传 token，从 git credential helper / 环境变量读取
if ([string]::IsNullOrWhiteSpace($Token)) {
    $Token = $env:GH_TOKEN
}
if ([string]::IsNullOrWhiteSpace($Token)) {
    $secure = Read-Host "请输入 GitHub PAT（需要 repo 权限）" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}

# 1. git user
git config user.name "yongkang-zx"
git config user.email "yongkang-zx@users.noreply.github.com"
Write-Host "✓ git user 配置完成" -ForegroundColor Green

# 2. git init
if (-not (Test-Path ".git")) {
    git init -b main | Out-Null
    Write-Host "✓ git 仓库初始化" -ForegroundColor Green
}

# 3. remote
$remoteUrl = "https://${Token}@github.com/${RepoName}.git"
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    git remote set-url origin $remoteUrl
} else {
    git remote add origin $remoteUrl
}
Write-Host "✓ remote: $RepoName" -ForegroundColor Green

# 4. add + commit
git add .
$status = git status --porcelain
if ($status) {
    git commit -m "feat: 初始化方太·职前 AI 课程设计工作台"
    Write-Host "✓ 首次提交完成" -ForegroundColor Green
}

# 5. push
Write-Host "`n→ 推送到 $RepoName ..." -ForegroundColor Cyan
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    $userName = ($RepoName -split '/')[0]
    $repoOnly = ($RepoName -split '/')[1]
    Write-Host "`n✓ 部署完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步启用 GitHub Pages（首次需要 30 秒手动操作）：" -ForegroundColor Yellow
    Write-Host "  1. 打开 https://github.com/$RepoName/settings/pages"
    Write-Host "  2. Source 选 'Deploy from a branch' → Branch: main → /(root) → Save"
    Write-Host "  3. 等 1-2 分钟，访问 https://$userName.github.io/$repoOnly/"
    Write-Host ""
    Write-Host "以后修改后，双击 push.ps1 一键推送即可" -ForegroundColor Cyan
} else {
    Write-Host "`n✗ 推送失败" -ForegroundColor Red
    exit 1
}