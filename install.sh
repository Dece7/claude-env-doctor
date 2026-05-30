#!/usr/bin/env bash
set -euo pipefail

# claude-env-doctor installer

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "━━━ claude-env-doctor 安装 ━━━"
echo ""

# Check jq
if ! command -v jq &>/dev/null; then
  echo "⚠️  jq 未安装，部分检查功能将受限"
  echo "   安装方式: brew install jq / apt install jq / winget install jqlang.jq"
  echo ""
fi

# Copy script
cp "$SCRIPT_DIR/doctor.sh" "$CLAUDE_DIR/doctor.sh"
chmod +x "$CLAUDE_DIR/doctor.sh"
echo "✅ 已安装到 ~/.claude/doctor.sh"
echo ""

# Create alias hint
echo "━━━ 安装完成 ━━━"
echo ""
echo "运行方式:"
echo "  bash ~/.claude/doctor.sh"
echo ""
echo "或创建快捷别名（添加到 ~/.bashrc 或 ~/.zshrc）:"
echo "  alias cc-doctor='bash ~/.claude/doctor.sh'"
echo ""
