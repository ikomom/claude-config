# Project Analyzer

快速分析项目结构、技术栈、核心模块和架构设计，生成完整的中文技术文档。

## 特性

- ✅ 使用 Haiku 子代理并行分析，加快生成速度
- ✅ 自动生成 Mermaid 图表（流程图、架构图、状态图等）
- ✅ 支持多种编程语言：Node.js、Python、Go、Java、Rust
- ✅ 质量检查和自动修复（Mermaid 语法、中文表达、代码引用）
- ✅ 分析完成后自动调用 `/init` 初始化 CLAUDE.md
- ✅ 支持 Monorepo 和微服务项目

## 使用方法

### 自然语言触发

- "分析这个项目"
- "生成项目文档"
- "我想了解这个代码库"
- "帮我理解这个项目的架构"

### 命令触发

```bash
/analyze-project [选项]
```

### 选项

- `--output <dir>` - 指定输出目录（默认：`docs/`）
- `--depth <level>` - 分析深度（quick/medium/deep，默认：medium）
- `--focus <module>` - 聚焦特定模块（如：api, services, components）
- `--update` - 更新模式：原地更新现有文档，而不是创建新目录

## 分析深度

### Quick 模式（1 个代理，5 分钟）

生成 3-5 个文档：
- 项目总览
- 技术栈
- 目录结构

适合快速了解项目。

### Medium 模式（3 个代理，10-15 分钟）

生成 6-9 个文档：
- 项目总览
- 整体架构
- 核心模块
- API 参考
- 组件结构
- 技术栈详解

适合全面了解项目（默认）。

### Deep 模式（5 个代理，20-30 分钟）

生成 10-12 个文档：
- 包含 Medium 模式的所有文档
- 状态管理分析
- 测试和构建分析
- 更详细的代码引用

适合深入研究项目。

## 输出文档

### 文档格式

每个文档包含：
- YAML frontmatter（title, description, created, version, tags）
- 中文章节标题和正文
- Mermaid 图表（至少 1 个）
- 代码引用（文件路径:行号）

### 文档版本管理

**快照模式**（默认）：
```
docs/
├── analysis-20260420-150000/  # 第一次分析
├── analysis-20260421-100000/  # 第二次分析
└── latest -> analysis-20260421-100000/  # 符号链接
```

**更新模式**（`--update`）：
```
docs/
├── 00-overview.md          # 原地更新
├── 01-architecture.md
└── ...
```

## 质量检查

分析完成后，会自动进行质量检查：

1. **结构与完整性**：
   - 文档数量是否符合预期
   - YAML frontmatter 是否完整
   - 章节结构是否清晰

2. **内容质量**：
   - 中文表达是否准确流畅
   - 代码引用格式是否正确
   - 技术描述是否准确

3. **图表质量**：
   - 每个文档是否至少包含 1 个 Mermaid 图表
   - Mermaid 语法是否正确
   - 图表是否准确反映代码逻辑

质量检查报告会保存到 `quality-report.md`。

## 支持的项目类型

- **Node.js**: 检测 `package.json`
- **Python**: 检测 `requirements.txt`, `pyproject.toml`, `setup.py`
- **Go**: 检测 `go.mod`, `go.sum`
- **Java**: 检测 `pom.xml`, `build.gradle`
- **Rust**: 检测 `Cargo.toml`
- **Monorepo**: 检测 `pnpm-workspace.yaml`, `lerna.json`, `nx.json`

## 示例

### 分析 Next.js 项目

```bash
cd my-nextjs-project
/analyze-project
```

输出：
```
✅ 分析完成！已生成 6 个中文技术文档：

- [00-overview.md](docs/00-overview.md) - 项目总览
- [01-architecture.md](docs/01-architecture.md) - 整体架构
- [02-core-modules.md](docs/02-core-modules.md) - 核心模块
- [03-api-reference.md](docs/03-api-reference.md) - API 参考
- [04-components.md](docs/04-components.md) - 组件结构
- [05-tech-stack.md](docs/05-tech-stack.md) - 技术栈详解

质量检查：
- 结构完整性：✅
- 内容准确性：✅
- 图表质量：✅

正在初始化 CLAUDE.md...
```

### 聚焦分析 API 模块

```bash
/analyze-project --focus api --depth deep
```

### 更新现有文档

```bash
/analyze-project --update
```

## 注意事项

- 分析大型项目（>1000 文件）时，建议使用 `--focus` 选项
- Deep 模式会消耗较多 token，建议在需要详细文档时使用
- 所有子代理使用 Haiku 模型以降低成本
- Mermaid 图表节点数量建议控制在 20 个以内
- 每个文档分 2-3 次写入，避免超过 8192 token 限制

## 相关 Skills

- `/init` - 初始化 CLAUDE.md（分析完成后自动调用）
- `/commit` - 提交生成的文档
- `/simplify` - 简化生成的文档

## 版本

v1.0.0

## 作者

Claude
