# Settings 配置说明

## 配置文件

### settings.example.json

包含推荐的 Claude Code 配置：

#### 模型设置
- `model`: 默认模型（如 `"opus[1m]"` 表示 Opus 快速模式）
- `effortLevel`: 努力级别（`"low"`, `"medium"`, `"high"`）

#### 插件
- `typescript-lsp`: TypeScript 语言服务器
- `pyright-lsp`: Python 语言服务器
- `context7`: 访问最新的库文档

#### 环境变量
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`: 启用实验性团队功能
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`: 自动压缩阈值（80%）
- `CLAUDE_CODE_SUBAGENT_MODEL`: 子代理使用的模型

## 使用方法

1. 复制 `settings.example.json` 到 `~/.claude/settings.json`
2. 根据需要修改配置
3. 重启 Claude Code 或运行 `/reload`

## 配置层级

- **全局配置**: `~/.claude/settings.json`
- **项目配置**: `<project>/.claude/settings.json`

项目配置会覆盖全局配置。

## MCP 服务器配置

MCP 服务器（如 Exa、Filesystem）应该配置在 `~/.claude/mcp.json` 中，而不是 `settings.json`。

参考 [../mcp/README.md](../mcp/README.md) 了解如何配置 MCP 服务器。

## 注意事项

- 不要将包含 API keys 的配置文件提交到 Git
- 使用环境变量存储敏感信息
- 定期更新 API keys
