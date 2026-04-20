# Skills 开发指南

本指南介绍如何为 Claude Code 开发自定义 skills。

## Skill 结构

一个标准的 skill 目录结构：

```
skill-name/
├── SKILL.md              # Skill 定义文件（必需）
├── README.md             # 用户文档（推荐）
├── agents/               # 子代理 prompt 模板（可选）
│   ├── agent1.md
│   └── agent2.md
├── references/           # 参考文档（可选）
│   └── guide.md
└── scripts/              # 辅助脚本（可选）
    └── helper.py
```

## SKILL.md 格式

```markdown
---
name: skill-name
description: 简短描述，用于触发匹配
trigger: /skill-name
version: 1.0.0
author: Your Name
---

# Skill Name

详细说明...

## 执行流程

1. 步骤 1
2. 步骤 2
...

## 使用方法

...
```

## Frontmatter 字段

- **name** (必需): skill 名称，用于命令触发
- **description** (必需): 简短描述，Claude 用于判断是否触发
- **trigger** (可选): 显式触发命令，如 `/skill-name`
- **version** (推荐): 版本号，遵循 semver
- **author** (可选): 作者信息

## 最佳实践

### 1. 清晰的执行流程

在 SKILL.md 中明确列出执行步骤：

```markdown
## 执行流程（重要）

当这个 skill 被触发时，**立即**按以下步骤执行：

1. **步骤 1**（时间估算）
   - 具体操作
   - 使用的工具

2. **步骤 2**（时间估算）
   - 具体操作
```

### 2. 使用子代理

对于复杂任务，使用子代理并行处理：

```markdown
## 阶段 2：并行分析

**在同一个消息中并行启动 3 个 Haiku 子代理**：

**代理 1 - 任务描述**：
- **description**: "简短描述"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/agent1.md` 获取详细指令...
```

### 3. 错误处理

提供完善的错误处理策略：

```markdown
## 错误处理

### 子代理超时或失败
- 等待子代理完成，不设置硬性超时限制
- 如果某个子代理失败，继续使用其他子代理的结果
- 在输出中标注"部分分析未完成"
```

### 4. 分块写入

避免超过 8192 token 限制：

```markdown
## 分块写入判断

- **何时需要分块**：文档预计超过 50 行
- **如何分块**：
  - 第一次：使用 Write 工具创建文件
  - 后续：使用 Edit 工具追加内容
```

### 5. 路径引用

使用相对路径引用 skill 内部文件：

```markdown
- 阅读 skill 目录下的 `agents/agent1.md`
- 运行 skill 目录下的 `scripts/validate.py`
```

## 测试 Skill

1. 将 skill 复制到 `~/.claude/skills/`
2. 重启 Claude Code 或运行 `/reload`
3. 测试触发：
   - 自然语言触发：说出 description 中的关键词
   - 显式触发：运行 `/skill-name`

## 调试技巧

1. **查看 skill 是否加载**：
   - 运行 `/help` 查看可用 skills

2. **测试触发准确性**：
   - 尝试不同的自然语言表达
   - 优化 description 字段

3. **检查子代理输出**：
   - 子代理的输出会显示在主对话中
   - 检查是否按预期执行

## 发布 Skill

1. 确保 SKILL.md 包含完整的 frontmatter
2. 添加 README.md 用户文档
3. 更新 CHANGELOG.md
4. 提交到仓库

## 示例

参考 `skills/project-analyzer/` 作为完整示例。
