#!/bin/bash

# Claude Config 安装脚本
# 自动将 skills、hooks、配置复制到 ~/.claude/

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Claude Config 安装脚本"
echo "=========================="
echo ""

# 检查 Claude 目录是否存在
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: ~/.claude 目录不存在"
    echo "请先安装 Claude Code"
    exit 1
fi

echo "✅ 找到 Claude 目录: $CLAUDE_DIR"
echo ""

# 安装 Skills
echo "📦 安装 Skills..."
if [ -d "$PROJECT_DIR/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"

    # 列出所有 skills
    for skill_dir in "$PROJECT_DIR/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")

            # 检查是否已存在
            if [ -d "$CLAUDE_DIR/skills/$skill_name" ]; then
                read -p "  Skill '$skill_name' 已存在，是否覆盖? (y/n) " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    echo "  ⏭️  跳过 $skill_name"
                    continue
                fi
            fi

            cp -r "$skill_dir" "$CLAUDE_DIR/skills/"
            echo "  ✅ 已安装: $skill_name"
        fi
    done
else
    echo "  ⚠️  未找到 skills 目录"
fi

echo ""

# 安装 Hooks（可选）
if [ -d "$PROJECT_DIR/hooks" ] && [ "$(ls -A "$PROJECT_DIR/hooks")" ]; then
    read -p "🔗 是否安装自定义 hooks? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$CLAUDE_DIR/hooks"
        cp -r "$PROJECT_DIR/hooks"/* "$CLAUDE_DIR/hooks/"
        echo "  ✅ Hooks 已安装"
    else
        echo "  ⏭️  跳过 hooks 安装"
    fi
    echo ""
fi

# MCP 配置提示
if [ -d "$PROJECT_DIR/mcp" ] && [ -f "$PROJECT_DIR/mcp/servers.json" ]; then
    echo "⚙️  MCP 配置"
    echo "  MCP 配置文件位于: $PROJECT_DIR/mcp/servers.json"
    echo "  请手动合并到你的 MCP 配置中"
    echo "  参考: $PROJECT_DIR/mcp/README.md"
    echo ""
fi

# Settings 配置提示
if [ -d "$PROJECT_DIR/settings" ]; then
    echo "⚙️  Settings 配置"
    echo "  配置模板位于: $PROJECT_DIR/settings/"
    echo "  请根据需要手动复制和修改"
    echo ""
fi

echo "=========================="
echo "✅ 安装完成！"
echo ""
echo "📚 下一步:"
echo "  1. 重启 Claude Code 或运行 /reload"
echo "  2. 查看文档: $PROJECT_DIR/README.md"
echo "  3. 尝试运行: /analyze-project"
echo ""
