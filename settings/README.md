# Settings

配置文件模板。

## 使用方法

1. 复制 `.example.json` 文件并重命名（去掉 `.example`）
2. 根据需要修改配置
3. 复制到对应位置：
   - 全局配置: `~/.claude/settings.json`
   - 项目配置: `<project>/.claude/settings.json`

## 配置文件

- `settings.example.json`: 全局配置示例
- `keybindings.example.json`: 快捷键配置示例

## 注意事项

- 项目配置会覆盖全局配置
- 修改配置后需要重启 Claude Code 或运行 `/reload`
