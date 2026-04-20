# MCP 配置

Model Context Protocol 服务器配置。

## 使用方法

1. 查看 `servers.json` 中的示例配置
2. 根据需要修改配置
3. 手动合并到你的 MCP 配置文件中：
   - macOS/Linux: `~/.claude/mcp.json`
   - Windows: `%USERPROFILE%\.claude\mcp.json`

## 注意事项

- 不要直接覆盖现有的 MCP 配置
- 敏感信息（API keys）使用环境变量
- 确保 MCP 服务器已安装

## 更多信息

参考 [MCP 配置指南](../docs/mcp-guide.md)
