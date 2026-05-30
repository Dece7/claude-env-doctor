# claude-env-doctor

> Claude Code 环境诊断工具 — 一条命令检查你的 CC 环境是否健康。

装完 Claude Code 不知道配没配好？出了问题不知道哪里坏了？换电脑后不确定环境恢复了没？跑一下 `doctor.sh` 就知道。

## 适用场景

| 场景 | 说明 |
|------|------|
| 🆕 首次安装 CC | 确认环境是否配齐，缺什么一目了然 |
| 🔧 排查问题 | CC 行为异常时快速定位是配置问题还是环境问题 |
| 💻 换电脑/重装 | 验证新环境是否恢复完整 |
| 📋 团队协作 | 新成员加入时确认开发环境就绪 |
| 🔄 版本升级后 | 确认升级没有破坏已有配置 |

## 快速开始

```bash
# 克隆并运行（不安装）
git clone https://github.com/Dece7/claude-env-doctor.git
cd claude-env-doctor
bash doctor.sh
```

或安装到本地后随时调用：

```bash
bash install.sh
bash ~/.claude/doctor.sh
```

## 效果展示

```
━━━ Claude Code 环境诊断 ━━━
2026-05-31 02:39:32

🔧 基础环境
  [✅] Node.js v20.17.0
  [✅] Git 2.44.0.windows.1
  [✅] jq jq-1.8.1
  [✅] Claude Code 2.1.143

⚙️ 配置检查
  [✅] settings.json 存在
  [✅] settings.json 格式正确
  [✅] API 代理已配置: https://token-plan-cn.xiaomimimo.com/anthropic
  [✅] API Token 已配置
  [✅] 默认模型: mimo-v2.5-pro
  [✅] GitHub PAT 已配置
  [✅] 主题: dark
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
  [✅] 用户 Commands: 18 个
  [✅] Rules: 7 个

🌐 网络连通性
  [⚠️] GitHub API 不可达（可能需要代理）
  [⚠️] API 端点不可达: https://token-plan-cn.xiaomimimo.com/anthropic

━━━ 诊断结果 ━━━

  ✅ 通过: 20   ⚠️ 警告: 2   ❌ 失败: 0

  ⚠️ 有 2 个警告，建议处理
```

## 检查项目详解

### 🔧 基础环境

检查 Claude Code 运行所需的最低依赖：

| 工具 | 用途 | 缺失影响 |
|------|------|---------|
| Node.js | CC 运行时 | CC 无法启动 |
| Git | 版本控制、分支信息 | Git 相关功能不可用 |
| jq | JSON 解析 | HUD、配置读取等脚本失效 |
| Claude Code | 本身 | — |

### ⚙️ 配置检查

解析 `~/.claude/settings.json`，逐项验证：

| 检查项 | 说明 | 严重程度 |
|--------|------|---------|
| 文件存在 | settings.json 是否存在 | 缺失=首次运行前正常 |
| JSON 格式 | 是否为合法 JSON | 错误=CC 无法读取配置 |
| API 代理 | ANTHROPIC_BASE_URL 是否配置 | 缺失=使用官方 API |
| API Token | 认证凭据是否配置 | 缺失=无法调用 API |
| 默认模型 | ANTHROPIC_MODEL 是否设置 | 缺失=使用 CC 默认 |
| GitHub PAT | 用于 gh CLI 认证 | 缺失=gh 功能受限 |
| 主题 | 显示主题设置 | 信息项 |
| StatusLine | 自定义状态栏脚本 | 缺失=无自定义 HUD |

### 🔌 MCP 服务

读取 `~/.claude.json` 中的 `mcpServers`，列出所有已配置的 MCP 服务。

### 🧩 插件服务

读取 `settings.json` 中的 `enabledPlugins`，区分已启用和已禁用的插件。

### 🛠️ 可选工具

| 工具 | 用途 | 缺失影响 |
|------|------|---------|
| gh CLI | GitHub 操作（PR/Issue/推送） | 无法在 CC 内操作 GitHub |
| agent-browser | 浏览器自动化 | 无法自动验证网页 |
| ccusage | Token 用量追踪 | 无法查看费用统计 |

### 📂 Skills & Commands

统计 `~/.claude/` 下已安装的 Skills、Commands 和 Rules 数量。

### 🌐 网络连通性

| 测试目标 | 说明 |
|----------|------|
| GitHub API | gh CLI 和 GitHub 操作是否可用 |
| API 端点 | 配置的 ANTHROPIC_BASE_URL 是否可达 |

## 通用性

本工具 **100% 通用**，不绑定任何特定机器或配置：

- ✅ 检查的是所有 CC 用户都会遇到的通用项
- ✅ 不依赖特定的 API 代理、模型或第三方服务
- ✅ 任何人 clone 下来都能直接运行
- ✅ 结果因环境而异——配齐了显示全绿，缺什么显示什么

## 依赖

| 依赖 | 必需？ | 说明 |
|------|--------|------|
| `bash` | 是 | 脚本运行环境 |
| `jq` | 是 | 解析 JSON 配置文件 |
| `curl` | 否 | 网络连通性检查（缺失则跳过） |

## 卸载

```bash
bash uninstall.sh
```

如已添加别名，手动从 `~/.bashrc` 或 `~/.zshrc` 中移除：
```bash
alias cc-doctor='bash ~/.claude/doctor.sh'
```

## 文件结构

```
claude-env-doctor/
├── README.md        # 本文档
├── doctor.sh        # 诊断脚本（核心）
├── install.sh       # 一键安装
├── uninstall.sh     # 一键卸载
└── .gitignore
```

安装后：
```
~/.claude/
└── doctor.sh        # 诊断脚本
```

## 许可证

[MIT](https://opensource.org/licenses/MIT)
