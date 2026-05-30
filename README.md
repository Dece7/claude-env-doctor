# claude-env-doctor

> Claude Code 环境诊断工具 — 一条命令检查你的 CC 环境是否健康。

装完 Claude Code 不知道配没配好？出了问题不知道哪里坏了？跑一下 `doctor.sh` 就知道。

## 效果

```
━━━ Claude Code 环境诊断 ━━━
2026-05-30 14:30:00

🔧 基础环境
  [✅] Node.js v22.0.0
  [✅] Git 2.40.0
  [✅] jq jq-1.8.1
  [✅] Claude Code 2.1.143

⚙️ 配置检查
  [✅] settings.json 存在
  [✅] settings.json 格式正确
  [✅] API 代理已配置: https://token-plan-cn.xiaomimimo.com/anthropic
  [✅] API Token 已配置
  [✅] GitHub PAT 已配置
  [⚠️] 未配置 ANTHROPIC_MODEL（使用 CC 默认）
  [✅] StatusLine 已配置: bash ~/.claude/statusline-command.sh

🔌 MCP 服务
  [✅] 已配置 1 个 MCP 服务
    → context7

🧩 插件服务
  [✅] 已配置 2 个插件
    ✅ claude-mem@thedotmack
    ⏸️ github@claude-plugins-official (已禁用)

🛠️ 可选工具
  [✅] gh CLI v2.74.2（已认证）
  [✅] agent-browser v0.27.0
  [✅] ccusage 已安装

📂 Skills & Commands
  [✅] 用户 Skills: 21 个
  [✅] 用户 Commands: 17 个
  [✅] Rules: 7 个

🌐 网络连通性
  [⚠️] GitHub API 不可达（可能需要代理）
  [✅] API 端点可达: https://token-plan-cn.xiaomimimo.com/anthropic

━━━ 诊断结果 ━━━

  ✅ 通过: 16   ⚠️ 警告: 2   ❌ 失败: 0

  ⚠️ 有 2 个警告，建议处理
```

## 快速开始

```bash
git clone https://github.com/Dece7/claude-env-doctor.git
cd claude-env-doctor
bash install.sh

# 运行诊断
bash ~/.claude/doctor.sh
```

## 检查项目

| 分类 | 检查项 | 说明 |
|------|--------|------|
| 基础环境 | Node.js、Git、jq、Claude Code | 是否安装及版本 |
| 配置检查 | settings.json | 格式、API 代理、Token、模型、主题、StatusLine |
| MCP 服务 | ~/.claude.json | 已配置的 MCP 服务列表 |
| 插件服务 | enabledPlugins | 已启用/禁用的插件 |
| 可选工具 | gh、agent-browser、ccusage | 是否安装及认证状态 |
| Skills & Commands | ~/.claude/skills、commands | 已安装的技能和命令数量 |
| 网络连通性 | curl 测试 | GitHub API、API 端点是否可达 |

## 卸载

```bash
bash uninstall.sh
```

## 许可证

MIT
