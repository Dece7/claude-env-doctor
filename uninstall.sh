#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"

echo "━━━ claude-env-doctor 卸载 ━━━"
echo ""

if [ -f "$CLAUDE_DIR/doctor.sh" ]; then
  rm "$CLAUDE_DIR/doctor.sh"
  echo "✅ 已删除 ~/.claude/doctor.sh"
fi

echo ""
echo "如已添加别名，请手动从 ~/.bashrc 或 ~/.zshrc 中移除:"
echo "  alias cc-doctor='bash ~/.claude/doctor.sh'"
echo ""
