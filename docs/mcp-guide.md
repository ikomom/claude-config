# MCP 配置指南

Model Context Protocol (MCP) 允许 Claude Code 连接到外部服务和数据源。

## MCP 服务器配置

MCP 服务器通过配置文件定义，通常位于：
- macOS/Linux: `~/.claude/mcp.json`
- Windows: `%USERPROFILE%\.claude\mcp.json`

## 配置格式

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["/path/to/server.js"],
      "env": {
        "API_KEY": "your-api-key"
      }
    }
  }
}
```

## 常用 MCP 服务器

### 1. Filesystem MCP

访问本地文件系统：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    }
  }
}
```

### 2. GitHub MCP

访问 GitHub API：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

### 3. PostgreSQL MCP

连接 PostgreSQL 数据库：

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost:5432/dbname"
      }
    }
  }
}
```

### 4. Context7 MCP

访问最新的库文档：

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

## 安装 MCP 服务器

### 使用 npm

```bash
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github
```

### 使用 npx（推荐）

配置中使用 `npx -y` 会自动下载和运行：

```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-name"]
}
```

## 环境变量

敏感信息（API keys、密码）应该使用环境变量：

```json
{
  "env": {
    "API_KEY": "${API_KEY}",
    "DATABASE_URL": "${DATABASE_URL}"
  }
}
```

然后在 shell 配置中设置：

```bash
# ~/.bashrc 或 ~/.zshrc
export API_KEY="your-api-key"
export DATABASE_URL="postgresql://..."
```

## 调试 MCP 服务器

1. **查看 MCP 日志**：
   - Claude Code 会显示 MCP 连接状态

2. **测试 MCP 服务器**：
   ```bash
   node /path/to/server.js
   ```

3. **检查权限**：
   - 确保 MCP 服务器有访问所需资源的权限

## 自定义 MCP 服务器

你可以创建自定义 MCP 服务器：

```javascript
// custom-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'custom-server',
  version: '1.0.0',
});

// 定义工具
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'my-tool',
      description: 'My custom tool',
      inputSchema: {
        type: 'object',
        properties: {
          input: { type: 'string' }
        }
      }
    }
  ]
}));

// 处理工具调用
server.setRequestHandler('tools/call', async (request) => {
  // 实现工具逻辑
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

## 更多资源

- [MCP 官方文档](https://modelcontextprotocol.io/)
- [MCP 服务器列表](https://github.com/modelcontextprotocol/servers)
