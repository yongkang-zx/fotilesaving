# 方太 · 职前 AI 课程设计工作台

方太 26 届校招 AI 课程设计的整套工具：群通知文案、需求问卷、课程设计（实时编辑 + 子课程勾选确认）、共创伙伴招募、配置 & 导出。

## 本地预览

直接双击 `index.html` 即可在浏览器打开，所有数据走 localStorage，无后端依赖。

## 一键部署到 GitHub Pages

### 首次部署

1. 在 GitHub 上创建一个空仓库（**不要**勾选 Add README）
2. 记下仓库名，假设是 `FOTILE-pre`
3. 在本目录打开 PowerShell，运行：

```powershell
.\init.ps1 -RepoName "yongkang-zx/FOTILE-pre" -Token "ghp_你的PAT"
```

脚本会自动：
- 设置 git user
- 初始化仓库
- 写入 token 到 git credential helper（仅本仓库，不会泄漏到其他项目）
- 提交并推送到 main

### 启用 GitHub Pages

仓库 → Settings → Pages → Source 选 `main` 分支 → Save。
等 30 秒，访问 `https://yongkang-zx.github.io/FOTILE-pre/` 即可。

### 后续修改 + 一键 push

改完 `index.html` 或 `logo.png` 后，双击 `push.ps1` 即可推送到 GitHub。

```powershell
.\push.ps1
```

GitHub Pages 通常 10-30 秒后自动重新部署，刷新页面即可看到最新版。

## 文件清单

- `index.html` — 单文件应用（HTML + CSS + JS）
- `logo.png` — 方太阳光伙伴 LOGO
- `init.ps1` — 首次部署脚本
- `push.ps1` — 后续一键 push 脚本

## 数据持久化

- 所有课程设计改动通过 `localStorage` 自动保存在用户浏览器
- 刷新页面数据不丢
- 课程设计支持实时编辑 + 每个子课程独立勾选确认
- 导出 JSON 功能可手动备份完整设计数据