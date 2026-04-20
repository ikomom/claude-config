# MCP 配置

Model Context Protocol 服务器配置。

## 使用方法

### 方式 1：使用 Claude CLI（推荐）

Claude Code 提供了 CLI 命令来管理 MCP 服务器：

```bash
# 添加 Exa MCP 服务器
claude mcp add exa -e EXA_API_KEY=YOUR_API_KEY -- npx -y exa-mcp-server

# 添加 Context7 MCP 服务器
claude mcp add context7 -- npx -y @context7/mcp-server

# 添加 Filesystem MCP 服务器
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/dir

# 列出所有 MCP 服务器
claude mcp list

# 移除 MCP 服务器
claude mcp remove exa
```

### 方式 2：手动编辑配置文件

1. 查看 `servers.json` 中的示例配置
2. 根据需要修改配置（替换 API keys、路径等）
3. 手动合并到你的 MCP 配置文件中：
   - macOS/Linux: `~/.claude/mcp.json`
   - Windows: `%USERPROFILE%\.claude\mcp.json`

### 方式 3：直接复制（仅首次安装）

```bash
# 如果你还没有 MCP 配置文件
cp mcp/servers.json ~/.claude/mcp.json

# 然后编辑文件，替换占位符
nano ~/.claude/mcp.json
```

## 配置的 MCP 服务器

### 1. Context7
访问最新的库文档和 API 参考。

**CLI 安装**：
```bash
claude mcp add context7 -- npx -y @context7/mcp-server
```

**无需配置**，开箱即用。

### 2. Exa AI Search
AI 驱动的网页搜索和内容提取。

**CLI 安装**：
```bash
claude mcp add exa -e EXA_API_KEY=YOUR_API_KEY -- npx -y exa-mcp-server
```

**需要配置**：
1. 访问 https://exa.ai/ 注册账号
2. 获取 API key
3. 替换命令中的 `YOUR_API_KEY`

**功能**：
- 智能网页搜索
- 内容提取和总结
- 相似内容发现

### 3. Filesystem
访问本地文件系统。

**CLI 安装**：
```bash
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/dir
```

**需要配置**：
- 替换 `/path/to/allowed/dir` 为实际路径
- 可以配置多个路径

## 注意事项

- ⚠️ 不要直接覆盖现有的 MCP 配置
- 🔒 敏感信息（API keys）使用环境变量或单独存储
- ✅ 确保 MCP 服务器已安装（使用 `npx -y` 会自动安装）
- 🔄 修改配置后需要重启 Claude Code

## 环境变量方式（推荐）

为了安全，建议使用环境变量存储 API keys：

**使用 CLI**：
```bash
# 从环境变量读取
export EXA_API_KEY="your-api-key-here"
claude mcp add exa -e EXA_API_KEY=$EXA_API_KEY -- npx -y exa-mcp-server
```

**手动配置**：
```json
{
  "mcpServers": {
    "exa": {
      "command": "npx",
      "args": ["-y", "exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "${EXA_API_KEY}"
      }
    }
  }
}
```

然后在 shell 配置中设置：

```bash
# ~/.bashrc 或 ~/.zshrc
export EXA_API_KEY="your-api-key-here"
```

## 更多信息

参考 [MCP 配置指南](../docs/mcp-guide.md)
