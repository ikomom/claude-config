# Hooks 使用指南

Claude Code 支持自定义 hooks，在特定事件发生时自动执行脚本。

## Hook 类型

### 1. Tool Hooks

在工具调用前后执行：

- `pre-<tool-name>`: 工具调用前
- `post-<tool-name>`: 工具调用后

示例：
- `pre-bash`: Bash 命令执行前
- `post-read`: 文件读取后

### 2. Event Hooks

在特定事件发生时执行：

- `user-prompt-submit`: 用户提交消息后
- `assistant-response-complete`: Claude 响应完成后

## Hook 配置

Hooks 通过 `settings.json` 配置：

```json
{
  "hooks": {
    "pre-bash": "~/.claude/hooks/pre-bash.sh",
    "post-read": "~/.claude/hooks/post-read.sh",
    "user-prompt-submit": "~/.claude/hooks/on-submit.sh"
  }
}
```

## Hook 脚本

Hook 脚本接收环境变量和标准输入：

### 环境变量

- `CLAUDE_TOOL`: 工具名称
- `CLAUDE_CWD`: 当前工作目录
- `CLAUDE_USER`: 用户名

### 标准输入

工具参数以 JSON 格式传入：

```bash
#!/bin/bash
# pre-bash.sh

# 读取工具参数
read -r params

# 解析 JSON
command=$(echo "$params" | jq -r '.command')

# 执行检查
if [[ "$command" == *"rm -rf"* ]]; then
    echo "⚠️  警告: 危险命令"
    exit 1
fi
```

## 示例 Hooks

### 1. 代码提交前检查

```bash
#!/bin/bash
# pre-bash.sh

read -r params
command=$(echo "$params" | jq -r '.command')

# 检查是否为 git commit
if [[ "$command" == "git commit"* ]]; then
    # 运行测试
    npm test
    if [ $? -ne 0 ]; then
        echo "❌ 测试失败，阻止提交"
        exit 1
    fi
fi
```

### 2. 文件读取后记录

```bash
#!/bin/bash
# post-read.sh

read -r params
file_path=$(echo "$params" | jq -r '.file_path')

# 记录到日志
echo "$(date): Read $file_path" >> ~/.claude/read.log
```

## 调试 Hooks

1. **查看 hook 输出**：
   - Hook 的 stdout/stderr 会显示在 Claude 对话中

2. **测试 hook 脚本**：
   ```bash
   echo '{"command":"ls"}' | bash ~/.claude/hooks/pre-bash.sh
   ```

3. **禁用 hook**：
   - 从 `settings.json` 中移除或注释掉

## 注意事项

- Hook 脚本必须有执行权限：`chmod +x hook.sh`
- Hook 失败（exit 1）会阻止工具执行
- 避免在 hook 中执行耗时操作
- Hook 脚本应该快速返回（< 1 秒）

## 更多资源

- [Claude Code Hooks 文档](https://docs.anthropic.com/claude-code/hooks)
