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

#### Exa 搜索集成

Exa 是一个 AI 驱动的搜索引擎，可以通过 MCP 集成到 Claude Code 中。

配置示例：
```json
{
  "extraKnownMarketplaces": {
    "exa": {
      "source": {
        "source": "url",
        "url": "https://mcp.exa.ai/mcp?exaApiKey=YOUR_EXA_API_KEY"
      },
      "enabled": true,
      "autoUpdate": false
    }
  }
}
```

**获取 Exa API Key**：
1. 访问 https://exa.ai/
2. 注册账号
3. 获取 API key
4. 替换配置中的 `YOUR_EXA_API_KEY`

**Exa 功能**：
- 智能网页搜索
- 内容提取和总结
- 相似内容发现

## 使用方法

1. 复制 `settings.example.json` 到 `~/.claude/settings.json`
2. 根据需要修改配置
3. 替换所有 `YOUR_*` 占位符为实际值
4. 重启 Claude Code 或运行 `/reload`

## 配置层级

- **全局配置**: `~/.claude/settings.json`
- **项目配置**: `<project>/.claude/settings.json`

项目配置会覆盖全局配置。

## 注意事项

- 不要将包含 API keys 的配置文件提交到 Git
- 使用环境变量存储敏感信息
- 定期更新 API keys
