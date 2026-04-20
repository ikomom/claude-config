#!/bin/bash

# Claude Config 更新脚本
# 更新已安装的 skills 和配置

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔄 Claude Config 更新脚本"
echo "=========================="
echo ""

# 检查 Claude 目录是否存在
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: ~/.claude 目录不存在"
    exit 1
fi

# 更新 Skills
echo "📦 更新 Skills..."
if [ -d "$PROJECT_DIR/skills" ]; then
    for skill_dir in "$PROJECT_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")

            # 只更新已安装的 skills
            if [ -d "$CLAUDE_DIR/skills/$skill_name" ]; then
                echo "  🔄 更新: $skill_name"
                cp -r "$skill_dir"/* "$CLAUDE_DIR/skills/$skill_name/"
                echo "  ✅ 已更新: $skill_name"
            else
                echo "  ⏭️  跳过未安装的 skill: $skill_name"
            fi
        fi
    done
else
    echo "  ⚠️  未找到 skills 目录"
fi

echo ""
echo "=========================="
echo "✅ 更新完成！"
echo ""
echo "📚 下一步:"
echo "  1. 重启 Claude Code 或运行 /reload"
echo "  2. 查看更新日志: $PROJECT_DIR/CHANGELOG.md"
echo ""
