#!/bin/bash

# Claude Config 卸载脚本
# 移除已安装的 skills 和配置

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🗑️  Claude Config 卸载脚本"
echo "=========================="
echo ""

read -p "⚠️  确定要卸载所有 Claude Config 内容吗? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消卸载"
    exit 0
fi

echo ""

# 卸载 Skills
echo "📦 卸载 Skills..."
if [ -d "$PROJECT_DIR/skills" ]; then
    for skill_dir in "$PROJECT_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")

            if [ -d "$CLAUDE_DIR/skills/$skill_name" ]; then
                rm -rf "$CLAUDE_DIR/skills/$skill_name"
                echo "  ✅ 已卸载: $skill_name"
            fi
        fi
    done
fi

echo ""
echo "=========================="
echo "✅ 卸载完成！"
echo ""
