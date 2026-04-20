# Claude Config

个人 Claude Code 配置集合，包含自定义 skills、hooks、MCP 配置等。

## 📦 包含内容

- **Skills**: 自定义技能集合
  - `project-analyzer`: 项目分析工具，生成中文技术文档
  - 更多 skills 持续添加中...
- **Hooks**: 自定义钩子脚本
- **MCP**: Model Context Protocol 配置
- **Settings**: 配置文件模板

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone <your-repo-url> claude-config
cd claude-config

# 运行安装脚本
bash scripts/install.sh
```

### 手动安装

```bash
# 复制 skills
cp -r skills/* ~/.claude/skills/

# 复制 hooks（可选）
cp -r hooks/* ~/.claude/hooks/

# 合并 MCP 配置（需要手动编辑）
# 参考 mcp/README.md
```

## 📚 Skills 列表

### project-analyzer

快速分析项目结构、技术栈、核心模块和架构设计，生成完整的中文技术文档。

**触发方式**：
- "分析这个项目"
- "生成项目文档"
- `/analyze-project`

**特性**：
- 使用 Haiku 子代理并行分析
- 自动生成 Mermaid 图表
- 支持 Node.js、Python、Go、Java、Rust 项目
- 质量检查和自动修复
- 分析完成后自动调用 `/init` 初始化 CLAUDE.md

**详细文档**: [skills/project-analyzer/README.md](skills/project-analyzer/README.md)

## 🔧 配置

### Settings

配置文件模板位于 `settings/` 目录：
- `settings.example.json`: 全局配置示例
- `keybindings.example.json`: 快捷键配置示例

### Hooks

自定义钩子脚本位于 `hooks/` 目录，参考 `hooks/README.md` 了解如何使用。

### MCP

MCP 服务器配置位于 `mcp/` 目录，参考 `mcp/README.md` 了解如何配置。

## 📖 文档

- [Skills 开发指南](docs/skills-guide.md)
- [Hooks 使用指南](docs/hooks-guide.md)
- [MCP 配置指南](docs/mcp-guide.md)

## 🔄 更新

```bash
cd claude-config
git pull
bash scripts/update.sh
```

## 📝 版本历史

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新内容。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

MIT License
