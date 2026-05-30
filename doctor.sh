#!/usr/bin/env bash
set -euo pipefail

# claude-env-doctor: Claude Code environment diagnostic tool

# Colors
GREEN=$'\033[32m'
RED=$'\033[31m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

pass=0
warnings=0
fail=0

ok()   { echo "  ${GREEN}[✅]${RESET} $1"; pass=$((pass + 1)); }
warn() { echo "  ${YELLOW}[⚠️]${RESET} $1"; warnings=$((warnings + 1)); }
err()  { echo "  ${RED}[❌]${RESET} $1"; fail=$((fail + 1)); }
info() { echo "  ${DIM}$1${RESET}"; }
header() { echo ""; echo "${BOLD}$1${RESET}"; }

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo ""
echo "${BOLD}${CYAN}━━━ Claude Code 环境诊断 ━━━${RESET}"
echo "${DIM}$(date '+%Y-%m-%d %H:%M:%S')${RESET}"

# --- 1. Basic tools ---
header "🔧 基础环境"

if command -v node &>/dev/null; then
  node_ver=$(node --version 2>/dev/null)
  ok "Node.js ${node_ver}"
else
  err "Node.js 未安装 → https://nodejs.org"
fi

if command -v git &>/dev/null; then
  git_ver=$(git --version 2>/dev/null | awk '{print $3}')
  ok "Git ${git_ver}"
else
  err "Git 未安装 → https://git-scm.com"
fi

if command -v jq &>/dev/null; then
  jq_ver=$(jq --version 2>/dev/null)
  ok "jq ${jq_ver}"
else
  err "jq 未安装 → brew install jq / apt install jq / winget install jqlang.jq"
fi

if command -v claude &>/dev/null; then
  cc_ver=$(claude --version 2>/dev/null || echo "unknown")
  ok "Claude Code ${cc_ver}"
else
  err "Claude Code 未安装 → npm i -g @anthropic-ai/claude-code"
fi

# --- 2. Settings ---
header "⚙️ 配置检查"

if [ -f "$SETTINGS" ]; then
  ok "settings.json 存在"

  if jq empty "$SETTINGS" 2>/dev/null; then
    ok "settings.json 格式正确"
  else
    err "settings.json 格式错误（JSON 语法问题）"
  fi

  # API proxy
  base_url=$(jq -r '.env.ANTHROPIC_BASE_URL // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$base_url" ]; then
    ok "API 代理已配置: ${base_url}"
  else
    warn "未配置 API 代理（使用官方 API）"
  fi

  # Auth token
  auth_token=$(jq -r '.env.ANTHROPIC_AUTH_TOKEN // .env.ANTHROPIC_API_KEY // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$auth_token" ]; then
    ok "API Token 已配置"
  else
    err "未配置 ANTHROPIC_AUTH_TOKEN 或 ANTHROPIC_API_KEY"
  fi

  # Model
  model=$(jq -r '.env.ANTHROPIC_MODEL // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$model" ]; then
    ok "默认模型: ${model}"
  else
    info "未设置默认模型（使用 CC 默认）"
  fi

  # GitHub PAT
  gh_pat=$(jq -r '.env.GITHUB_PERSONAL_ACCESS_TOKEN // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$gh_pat" ]; then
    ok "GitHub PAT 已配置"
  else
    warn "未配置 GITHUB_PERSONAL_ACCESS_TOKEN → gh CLI 功能受限"
  fi

  # Theme
  theme=$(jq -r '.theme // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$theme" ]; then
    ok "主题: ${theme}"
  fi

  # StatusLine
  statusline=$(jq -r '.statusLine.command // empty' "$SETTINGS" 2>/dev/null)
  if [ -n "$statusline" ]; then
    ok "StatusLine 已配置: ${statusline}"
  else
    info "StatusLine 未配置（可选）"
  fi

  # Permissions count
  perm_count=$(jq '.permissions.allow | length' "$SETTINGS" 2>/dev/null || echo "0")
  info "权限白名单: ${perm_count} 条规则"

else
  warn "settings.json 不存在（首次运行 CC 时自动创建）"
fi

# --- 3. MCP servers ---
header "🔌 MCP 服务"

claude_json="$HOME/.claude.json"
if [ -f "$claude_json" ]; then
  mcp_count=$(jq '.mcpServers | length' "$claude_json" 2>/dev/null || echo "0")
  if [ "$mcp_count" -gt 0 ]; then
    ok "已配置 ${mcp_count} 个 MCP 服务"
    jq -r '.mcpServers | keys[]' "$claude_json" 2>/dev/null | while read -r name; do
      info "  → ${name}"
    done
  else
    info "未配置 MCP 服务"
  fi
else
  info "未找到 ~/.claude.json"
fi

# --- 4. Plugins ---
header "🧩 插件服务"

plugin_count=$(jq '.enabledPlugins | length' "$SETTINGS" 2>/dev/null || echo "0")
if [ "$plugin_count" -gt 0 ]; then
  ok "已配置 ${plugin_count} 个插件"
  jq -r '.enabledPlugins | to_entries[] | select(.value == true) | "  ✅ " + .key' "$SETTINGS" 2>/dev/null || true
  jq -r '.enabledPlugins | to_entries[] | select(.value == false) | "  ⏸️ " + .key + " (已禁用)"' "$SETTINGS" 2>/dev/null || true
else
  info "未配置插件"
fi

# --- 5. Optional tools ---
header "🛠️ 可选工具"

if command -v gh &>/dev/null; then
  gh_ver=$(gh --version 2>/dev/null | head -1 | awk '{print $3}')
  if gh auth status &>/dev/null; then
    ok "gh CLI ${gh_ver}（已认证）"
  else
    warn "gh CLI ${gh_ver}（未认证）→ gh auth login"
  fi
else
  info "gh CLI 未安装（可选）→ https://cli.github.com"
fi

if command -v agent-browser &>/dev/null; then
  ab_ver=$(agent-browser --version 2>/dev/null || echo "unknown")
  ok "agent-browser ${ab_ver}"
else
  info "agent-browser 未安装（可选）→ npm i -g agent-browser"
fi

if command -v ccusage &>/dev/null; then
  ok "ccusage 已安装"
else
  info "ccusage 未安装（可选）→ npm i -g ccusage"
fi

# --- 6. Skills & Commands ---
header "📂 Skills & Commands"

skill_count=$(ls -1 "$CLAUDE_DIR/skills" 2>/dev/null | wc -l | tr -d ' ')
if [ "$skill_count" -gt 0 ]; then
  ok "用户 Skills: ${skill_count} 个"
else
  info "未安装用户 Skills"
fi

cmd_count=$(ls -1 "$CLAUDE_DIR/commands" 2>/dev/null | wc -l | tr -d ' ')
if [ "$cmd_count" -gt 0 ]; then
  ok "用户 Commands: ${cmd_count} 个"
else
  info "未安装用户 Commands"
fi

rule_count=$(ls -1 "$CLAUDE_DIR/rules" 2>/dev/null | wc -l | tr -d ' ')
if [ "$rule_count" -gt 0 ]; then
  ok "Rules: ${rule_count} 个"
fi

# --- 7. Network ---
header "🌐 网络连通性"

if command -v curl &>/dev/null; then
  # Test GitHub API
  if curl -sSf --max-time 5 "https://api.github.com" &>/dev/null; then
    ok "GitHub API 可达"
  else
    warn "GitHub API 不可达（可能需要代理）"
  fi

  # Test Anthropic API
  api_url=$(jq -r '.env.ANTHROPIC_BASE_URL // "https://api.anthropic.com"' "$SETTINGS" 2>/dev/null)
  if curl -sSf --max-time 5 "$api_url" &>/dev/null 2>&1; then
    ok "API 端点可达: ${api_url}"
  else
    warn "API 端点不可达: ${api_url}"
  fi
else
  info "curl 未安装，跳过网络检查"
fi

# --- Summary ---
echo ""
echo "${BOLD}${CYAN}━━━ 诊断结果 ━━━${RESET}"
echo ""
echo "  ${GREEN}✅ 通过: ${pass}${RESET}   ${YELLOW}⚠️ 警告: ${warnings}${RESET}   ${RED}❌ 失败: ${fail}${RESET}"
echo ""

if [ "$fail" -eq 0 ] && [ "$warnings" -eq 0 ]; then
  echo "  ${GREEN}${BOLD}🎉 环境完全健康！${RESET}"
elif [ "$fail" -eq 0 ]; then
  echo "  ${YELLOW}${BOLD}⚠️ 有 ${warnings} 个警告，建议处理${RESET}"
else
  echo "  ${RED}${BOLD}❌ 有 ${fail} 个问题需要修复${RESET}"
fi

echo ""
