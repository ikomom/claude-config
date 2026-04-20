# Hooks

自定义 hooks 脚本集合。

## 使用方法

1. 将 hooks 复制到 `~/.claude/hooks/`
2. 在 `~/.claude/settings.json` 中配置 hooks
3. 确保脚本有执行权限：`chmod +x hook.sh`

## 配置示例

```json
{
  "hooks": {
    "pre-bash": "~/.claude/hooks/pre-bash.sh",
    "post-read": "~/.claude/hooks/post-read.sh"
  }
}
```

## 可用 Hooks

（目前为空，添加自定义 hooks 后更新此列表）

## 更多信息

参考 [Hooks 使用指南](../docs/hooks-guide.md)
