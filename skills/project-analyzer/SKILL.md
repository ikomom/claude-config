---
name: project-analyzer
description: 快速分析项目结构、技术栈、核心模块和架构设计，生成完整的中文技术文档。当用户说"分析这个项目"、"生成项目文档"、"我想了解这个代码库"、"帮我理解这个项目的架构"时自动触发。使用 Haiku 子代理并行分析，包含 Mermaid 图表。
trigger: /analyze-project
version: 1.0.0
author: Claude
---

# Project Analyzer Skill

快速分析项目的结构、技术栈、核心模块和架构设计，并生成完整的**中文**技术文档。使用多个 Haiku 子代理并行分析，加快生成速度。

## 执行流程（重要）

当这个 skill 被触发时，**立即**按以下步骤执行，不要询问用户：

1. **扫描项目**（主线程，1-2 分钟）
   - 读取 package.json, README.md, CLAUDE.md
   - 检测项目类型（单体/Monorepo/微服务）
   - 统计代码规模，确定分析深度

2. **启动子代理**（并行，在同一个消息中）
   - 根据分析深度启动 1-5 个 Haiku 子代理
   - 每个子代理分析不同模块（核心逻辑、API、组件等）
   - 使用 `agents/` 目录中的 prompt 模板

3. **告诉用户**
   - "我正在分析这个项目，已启动 N 个子代理并行分析。预计 X 分钟完成。"

4. **等待子代理完成**（10-30 分钟）
   - 不要主动输出，等待所有子代理返回结果

5. **生成文档**（主线程，5-10 分钟）
   - 基于子代理报告生成中文文档
   - 每个文档分 2-3 次写入（避免超过 8192 token 限制）
   - 添加 Mermaid 图表和代码引用

6. **质量检查**（并行子代理 + 主线程，3-5 分钟）
   - 启动 3 个 Haiku 子代理并行检查文档质量
   - 运行验证脚本
   - 整合审查结果并修复严重问题

7. **报告结果**
   - 列出生成的文档清单
   - 提供文档链接

8. **初始化 CLAUDE.md**（自动，1-2 分钟）
   - 分析完成后，自动调用 `/init` skill
   - 基于生成的文档创建或更新 CLAUDE.md
   - 将项目架构、技术栈等关键信息写入 CLAUDE.md

## 核心原则

1. **所有文档必须使用中文**：章节标题、正文、列表项全部中文
2. **使用 Haiku 模型的子代理**：通过 `Agent` 工具并行分析，`model: "haiku"` 参数
3. **动态调整文档数量**：根据项目复杂度生成 3-12 个文档
4. **包含 Mermaid 图表**：每个文档至少 1 个图表（流程图、架构图、状态图等）
5. **分块写入**：避免超过 8192 token 限制，每个文档分 2-3 次写入
6. **不要询问用户**：直接开始分析，使用默认 Medium 模式

## 使用方法

用户可以直接说：
- "分析这个项目"
- "生成项目文档"
- "帮我理解这个代码库的架构"
- 或使用命令：`/analyze-project [选项]`

### 选项

- `--output <dir>` - 指定输出目录（默认：`docs/`）
- `--depth <level>` - 分析深度（quick/medium/deep，默认：medium）
- `--focus <module>` - 聚焦特定模块（如：api, services, components）
- `--update` - 更新模式：原地更新现有文档，而不是创建新目录

## 分析流程

### 阶段 1：项目扫描（主线程，1-2 分钟）

在启动子代理之前，先快速扫描项目：

1. **读取配置文件**：
   - 使用 Read 工具读取 `package.json`、`README.md`、`CLAUDE.md`
   - 使用 Glob 工具检测 monorepo 标志文件：
     - `pnpm-workspace.yaml` - pnpm workspace
     - `lerna.json` - Lerna
     - `nx.json` - Nx

2. **检测项目类型**：
   - **单体项目**：标准的 lib/, app/, components/ 结构
   - **Monorepo**：有 packages/, apps/, libs/ 目录
   - **微服务**：有 services/, microservices/ 目录

3. **统计代码规模**：
   - 使用 Glob 工具统计文件数量：
     - TypeScript/JavaScript: `**/*.{ts,tsx,js,jsx}`
     - Python: `**/*.py`
     - Go: `**/*.go`
     - Java: `**/*.java`
   - 排除 node_modules、.git、dist、build 等目录

4. **确定分析深度和文档数量**：
   - **简单项目**（<50 文件）：Quick 模式，生成 3-5 个文档
   - **中等项目**（50-200 文件）：Medium 模式，生成 6-9 个文档
   - **复杂项目**（>200 文件）：Deep 模式，生成 10-12 个文档
   - **Monorepo/微服务**：每个子包/服务生成独立文档 + 总览文档

### 阶段 2：并行分析（使用 Haiku 子代理）

根据分析深度，启动多个子代理并行探索。**重要**：在同一个消息中启动所有子代理。

#### Quick 模式（1 个代理，5 分钟）

**使用 Agent 工具启动 1 个 Haiku 子代理**：

- **description**: "快速项目分析"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/core-logic-analyzer.md` 获取详细指令。分析项目概览和主要目录结构。报告控制在 200 词以内，中文输出。

生成文档：
- `00-overview.md` - 项目总览
- `01-tech-stack.md` - 技术栈
- `02-directory-structure.md` - 目录结构

#### Medium 模式（3 个代理，10-15 分钟）

**在同一个消息中并行启动 3 个 Haiku 子代理**：

**代理 1 - 核心业务逻辑**：
- **description**: "分析核心业务逻辑"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/core-logic-analyzer.md` 获取详细指令。分析 lib/ 或 src/ 目录的核心业务逻辑。报告控制在 300 词以内，中文输出。

**代理 2 - API 和路由**：
- **description**: "分析 API 路由"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/api-analyzer.md` 获取详细指令。分析 app/api/ 或 pages/api/ 或 routes/ 目录的 API 端点。报告控制在 300 词以内，中文输出。

**代理 3 - 前端组件**：
- **description**: "分析前端组件"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/component-analyzer.md` 获取详细指令。分析 components/ 或 views/ 目录的组件结构。报告控制在 300 词以内，中文输出。

生成文档：
- `00-overview.md` - 项目总览
- `01-architecture.md` - 整体架构
- `02-core-modules.md` - 核心模块
- `03-api-reference.md` - API 参考
- `04-components.md` - 组件结构
- `05-tech-stack.md` - 技术栈详解

#### Deep 模式（5 个代理，20-30 分钟）

**在同一个消息中并行启动 5 个 Haiku 子代理**：

1. **核心业务逻辑深度分析**（使用 core-logic-analyzer.md，报告 400 词）
2. **API 和数据流分析**（使用 api-analyzer.md，报告 400 词）
3. **前端架构分析**（使用 component-analyzer.md，报告 400 词）
4. **状态管理分析**（分析状态管理方案、Store 结构、持久化策略）
5. **测试和构建分析**（分析测试框架、构建工具、部署流程）

### 阶段 3：文档生成（主线程，5-10 分钟）

等待所有子代理完成后，基于分析结果生成文档：

1. **创建输出目录**：
   ```bash
   # 检查是否为更新模式
   if [ "$UPDATE_MODE" = "true" ]; then
     # 更新模式：原地更新，依赖 Git 管理历史
     OUTPUT_DIR="docs"
     mkdir -p "$OUTPUT_DIR"
     
     if [ -d "docs" ] && [ "$(ls -A docs/*.md 2>/dev/null)" ]; then
       echo "更新模式：将更新现有文档（Git 会记录变更历史）"
     fi
   else
     # 快照模式：创建新目录
     if [ -d "docs" ] && [ "$(ls -A docs 2>/dev/null)" ]; then
       # 如果 docs/ 已存在且非空，创建带时间戳的子目录
       OUTPUT_DIR="docs/analysis-$(date +%Y%m%d-%H%M%S)"
       mkdir -p "$OUTPUT_DIR"
       
       # 创建 latest 符号链接
       ln -sfn "$(basename $OUTPUT_DIR)" docs/latest
       echo "检测到 docs/ 已存在，输出到 $OUTPUT_DIR"
       echo "最新文档链接: docs/latest/"
     else
       # 如果 docs/ 不存在或为空，直接使用 docs/
       OUTPUT_DIR="docs"
       mkdir -p "$OUTPUT_DIR"
     fi
   fi
   ```

2. **为每个文档生成内容**：
   - 使用子代理的分析结果
   - 添加 Mermaid 图表（参考 `references/mermaid-guide.md`）
   - 引用关键代码文件（文件路径 + 行号）
   - **分块写入**：每个文档分 2-3 次写入
     - **判断标准**：如果文档包含 2+ 个 Mermaid 图表或 3+ 个代码示例，则需要分块
     - **第一次**：使用 Write 工具创建文件，写入标题、简介、第一个主要章节和第一个图表
     - **后续**：使用 Edit 工具追加内容，替换 `<!-- 待续 -->` 标记

3. **分块写入判断**：
   - **何时需要分块**：文档预计超过 50 行
   - **如何分块**：
     - 第一次：标题 + 简介 + 第一个主要章节 + 第一个图表
     - 第二次：剩余章节 + 代码示例
     - 第三次（如需要）：附录、参考链接
   - **分块标记**：使用 `<!-- 待续 -->` 作为分块点

4. **文档模板**：参考 `references/doc-template.md`

### 阶段 4：质量检查（并行子代理 + 主线程，3-5 分钟）

生成文档后，使用多个 Haiku 子代理并行检查文档质量：

#### 4.1 启动质量检查子代理（并行，在同一个消息中）

**在同一个消息中并行启动 3 个 Haiku 子代理**：

**代理 1 - 结构与完整性审查员**：
- **description**: "检查文档结构与完整性"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/structure-reviewer.md` 获取详细指令。检查所有生成的文档，验证：
  - 文档数量是否符合预期
  - YAML frontmatter 是否完整（title, description, created, version, tags）
  - 章节结构是否清晰（标题层级、目录导航）
  - 文档间交叉引用是否正确
  - 报告控制在 200 词以内，中文输出

**代理 2 - 内容质量审查员**：
- **description**: "检查内容质量与准确性"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/content-reviewer.md` 获取详细指令。检查所有生成的文档，验证：
  - 中文表达是否准确流畅（标题、正文、列表）
  - 代码引用格式是否正确（文件路径:行号）
  - 代码引用是否指向实际存在的文件
  - 技术描述是否准确（避免臆测）
  - 报告控制在 200 词以内，中文输出

**代理 3 - 图表质量审查员**：
- **description**: "检查 Mermaid 图表质量"
- **model**: "haiku"
- **prompt**: 阅读 skill 目录下的 `agents/diagram-reviewer.md` 获取详细指令。检查所有生成的文档，验证：
  - 每个文档是否至少包含 1 个 Mermaid 图表
  - Mermaid 代码块是否正确闭合
  - 图表语法是否正确（可在 mermaid.live 验证）
  - 节点和边标签是否使用中文
  - 图表是否准确反映代码逻辑
  - 报告控制在 200 词以内，中文输出

#### 4.2 等待子代理完成（3-5 分钟）

不要主动输出，等待所有 3 个子代理返回结果。

#### 4.3 主线程质量检查

在子代理检查的同时或之后，主线程执行：

1. **运行验证脚本**：
   ```bash
   # 验证所有文档的 metadata（使用 skill 目录下的脚本）
   python ~/.claude/skills/project-analyzer/scripts/validate-docs.py "$OUTPUT_DIR"
   ```
   
   验证内容：
   - 每个文档是否包含 YAML frontmatter
   - frontmatter 是否包含必需字段（title, description, created）
   - 日期格式是否正确
   - 是否至少包含 1 个 Mermaid 图表

2. **生成文档索引**：
   在 `00-overview.md` 中添加完整的文档导航链接

#### 4.4 整合审查结果并修复

收集所有子代理的审查报告和验证脚本的输出：

1. **分类问题**：
   - **严重问题**（必须修复）：缺少 frontmatter、Mermaid 语法错误、代码引用指向不存在的文件
   - **中等问题**（建议修复）：中文表达不准确、图表节点过多、章节结构不清晰
   - **轻微问题**（可选修复）：格式细节、措辞优化

2. **修复严重问题**：
   - 如果发现严重问题，立即修复相关文档
   - 使用 Edit 工具更新文档内容
   - **Mermaid 图表错误修复策略**：
     - 如果图表语法错误，尝试修复语法（检查节点 ID、箭头、引号）
     - 如果图表过于复杂（节点 >20），简化为核心流程
     - 如果修复失败，替换为简单的 `graph TB` 或 `flowchart TD` 图表
     - 确保每个文档至少有 1 个有效的 Mermaid 图表

3. **记录问题清单**：
   - 将所有问题（包括已修复和未修复）记录到 `$OUTPUT_DIR/quality-report.md`
   - 格式：
     ```markdown
     # 质量检查报告
     
     生成时间：YYYY-MM-DD HH:MM:SS
     
     ## 严重问题（已修复）
     - [文档名] 问题描述 → 修复方案
     
     ## 中等问题（建议修复）
     - [文档名] 问题描述
     
     ## 轻微问题
     - [文档名] 问题描述
     
     ## 验证脚本输出
     [粘贴 validate-docs.py 的输出]
     
     ## 子代理审查摘要
     ### 结构审查员
     [摘要]
     
     ### 内容审查员
     [摘要]
     
     ### 图表审查员
     [摘要]
     ```

## 错误处理

### 子代理超时或失败
- 等待子代理完成，不设置硬性超时限制
- 如果某个子代理失败，继续使用其他子代理的结果
- 在文档中标注"部分分析未完成"
- 在质量报告中记录失败的子代理及原因

### /init 调用失败
- 如果 `/init` skill 不可用或调用失败，记录错误信息
- 继续完成文档生成流程，不中断整体执行
- 在最终报告中提示用户可以手动运行 `/init`

### 项目结构不标准
- 如果找不到 package.json，检查是否为非 Node.js 项目
  - **Python 项目**：查找 `requirements.txt`、`pyproject.toml`、`setup.py`
  - **Go 项目**：查找 `go.mod`、`go.sum`
  - **Java 项目**：查找 `pom.xml`、`build.gradle`
  - **Rust 项目**：查找 `Cargo.toml`
- 如果目录结构不清晰，生成简化版文档（3-5 个）
- 在总览文档中说明项目结构特殊性

### Mermaid 图表生成失败
- 如果图表过于复杂，简化节点数量（控制在 20 个以内）
- 如果语法错误，使用简单的 graph TB 替代
- 确保至少有 1 个有效图表
- **常见 Mermaid 错误及修复**：
  - **节点 ID 包含特殊字符**：使用引号包裹，如 `["API 路由"]`
  - **箭头语法错误**：使用 `-->` 而不是 `->`
  - **中文标签未加引号**：节点标签包含中文时使用引号，如 `A["用户登录"]`
  - **代码块未闭合**：确保 ` ```mermaid` 和 ` ``` ` 成对出现
  - **图表类型错误**：使用 `graph TB`、`flowchart TD`、`sequenceDiagram`、`classDiagram` 等标准类型
  - **如果修复失败**：降级为最简单的 3-5 节点流程图

## 文档版本管理策略

### 更新模式 vs 快照模式

**更新模式**（`--update`）：
- 适用场景：项目持续迭代，需要保持文档最新
- 行为：原地更新 `docs/` 中的文档，**依赖 Git 管理历史版本**
- 优点：文档路径固定，链接不会失效，Git 提供完整的版本历史
- 示例：`/analyze-project --update`

**快照模式**（默认）：
- 适用场景：重大版本变更，需要在文件系统中保留多个版本
- 行为：创建 `docs/analysis-TIMESTAMP/` 新目录，保留所有历史版本
- 优点：无需 Git 即可对比不同时期的架构，适合非 Git 项目
- 示例：`/analyze-project`（默认）

### 推荐使用场景

| 场景 | 推荐模式 | 命令 |
|------|---------|------|
| 首次分析项目 | 快照模式 | `/analyze-project` |
| 日常代码更新（Git 项目） | 更新模式 | `/analyze-project --update` |
| 重大架构调整（需要对比） | 快照模式 | `/analyze-project` |
| 版本发布前（需要归档） | 快照模式 | `/analyze-project` |
| 定期维护文档（Git 项目） | 更新模式 | `/analyze-project --update` |
| 非 Git 项目 | 快照模式 | `/analyze-project` |

### 目录结构示例

**更新模式**（依赖 Git）：
```
docs/
├── 00-overview.md          # 始终是最新版本
├── 01-architecture.md
├── 02-core-modules.md
└── ...

# Git 历史记录
git log docs/
git diff HEAD~1 docs/00-overview.md  # 查看上次更新的差异
```

**快照模式**（文件系统保留历史）：
```
docs/
├── analysis-20260414-120000/  # 第一次分析（v1.0）
│   ├── 00-overview.md
│   └── ...
├── analysis-20260420-150000/  # 第二次分析（v2.0）
│   ├── 00-overview.md
│   └── ...
└── latest -> analysis-20260420-150000/  # 符号链接指向最新
```

### 检测方法

检查以下文件/目录：
- `pnpm-workspace.yaml` - pnpm workspaces
- `lerna.json` - Lerna
- `nx.json` - Nx
- `packages/` 或 `apps/` 目录
- `services/` 或 `microservices/` 目录

### 分析策略

对于 Monorepo 或微服务项目：

1. **生成总览文档**（`00-overview.md`）：
   - 项目整体架构
   - 所有子包/服务列表
   - 子包/服务间依赖关系
   - Mermaid 图表展示服务拓扑

2. **为每个子包/服务生成独立文档**：
   ```
   docs/
   ├── 00-overview.md              # 总览
   ├── 01-architecture.md          # 整体架构
   ├── packages/                   # 子包文档
   │   ├── package-a.md
   │   ├── package-b.md
   │   └── package-c.md
   └── services/                   # 服务文档
       ├── service-auth.md
       ├── service-api.md
       └── service-worker.md
   ```

3. **并行分析子包/服务**：
   为每个子包启动一个 Haiku 子代理

## 完整执行示例

用户说："分析这个项目"

**你的执行步骤**：

1. **扫描项目**（不输出，1 分钟）：
   - 读取 package.json：检测到 Next.js 16, React 19, TypeScript
   - 统计文件：156 个 .ts/.tsx 文件
   - 判断：中等复杂度，使用 Medium 模式

2. **启动 3 个子代理**（并行，在同一个消息中）：
   ```typescript
   Agent({ description: "分析核心业务逻辑", model: "haiku", ... })
   Agent({ description: "分析 API 路由", model: "haiku", ... })
   Agent({ description: "分析前端组件", model: "haiku", ... })
   ```

3. **告诉用户**：
   "我正在分析这个项目，已启动 3 个子代理并行分析核心模块、API 和组件。预计 10-15 分钟完成。"

4. **等待子代理完成**（10-15 分钟，不输出）

5. **生成文档**（5 分钟，分块写入）：
   - 00-overview.md（2 次写入）
   - 01-architecture.md（2 次写入）
   - 02-core-modules.md（2 次写入）
   - 03-api-reference.md（2 次写入）
   - 04-components.md（2 次写入）
   - 05-tech-stack.md（1 次写入）

6. **质量检查**（3-5 分钟，并行子代理）：
   - 启动 3 个 Haiku 子代理并行检查文档质量
   - 运行验证脚本
   - 整合审查结果并修复严重问题
   - 生成质量报告

7. **报告结果**：
   ```
   ✅ 分析完成！已生成 6 个中文技术文档：
   
   - [00-overview.md](docs/00-overview.md) - 项目总览
   - [01-architecture.md](docs/01-architecture.md) - 整体架构
   - [02-core-modules.md](docs/02-core-modules.md) - 核心模块
   - [03-api-reference.md](docs/03-api-reference.md) - API 参考
   - [04-components.md](docs/04-components.md) - 组件结构
   - [05-tech-stack.md](docs/05-tech-stack.md) - 技术栈详解
   
   所有文档包含 Mermaid 图表和代码引用。
   
   质量检查：
   - 结构完整性：✅
   - 内容准确性：✅
   - 图表质量：✅
   - 详细报告：[quality-report.md](docs/quality-report.md)
   ```

8. **初始化 CLAUDE.md**（1-2 分钟）：
   - 使用 Skill 工具调用 `/init`
   - `/init` 会基于生成的文档创建或更新项目根目录的 `.claude/CLAUDE.md`
   - 如果 `/init` 调用失败，记录错误但不影响整体流程
   - 告诉用户：
     ```
     正在初始化 CLAUDE.md...
     ```

## 参考文档

详细指南参考 `references/` 目录：

- `references/mermaid-guide.md` - Mermaid 图表指南
- `references/doc-template.md` - 文档模板

## 子代理指令

子代理的详细指令参考 `agents/` 目录：

**分析子代理**：
- `agents/core-logic-analyzer.md` - 核心业务逻辑分析
- `agents/api-analyzer.md` - API 路由分析
- `agents/component-analyzer.md` - 前端组件分析

**质量检查子代理**：
- `agents/structure-reviewer.md` - 结构与完整性审查
- `agents/content-reviewer.md` - 内容质量与准确性审查
- `agents/diagram-reviewer.md` - Mermaid 图表质量审查

## 最佳实践

1. **首次分析**：使用 Medium 模式获得全面了解
2. **聚焦分析**：使用 `--focus` 深入特定模块或子包
3. **Monorepo 分析**：自动检测并为每个子包生成独立文档
4. **微服务分析**：自动检测并为每个服务生成独立文档
5. **定期更新**：项目重大变更后重新运行分析
6. **人工审核**：生成的文档基于静态分析，建议人工审核补充

## 注意事项

- 分析大型项目（>1000 文件）时，建议使用 `--focus` 选项
- Deep 模式会消耗较多 token，建议在需要详细文档时使用
- 所有子代理使用 Haiku 模型（`model: "haiku"`）以降低成本
- Mermaid 图表节点数量建议控制在 20 个以内
- 每个文档分 2-3 次写入，避免超过 8192 token 限制
- **不要询问用户**：直接开始分析，使用默认设置
- **输出目录规则**：
  - **快照模式**（默认）：如果 `docs/` 已存在，创建 `docs/analysis-TIMESTAMP/`，并创建 `docs/latest/` 符号链接
  - **更新模式**（`--update`）：原地更新 `docs/`，依赖 Git 管理历史版本
- **文档元数据**：每个文档必须包含 YAML frontmatter（title, description, created 等）
- **验证脚本**：生成完成后运行 skill 目录下的 `scripts/validate-docs.py` 验证文档质量
- **非 Node.js 项目**：自动检测 Python、Go、Java、Rust 等项目的配置文件

## 相关 Skills

- `/init` - 初始化 CLAUDE.md（分析完成后自动调用）
- `/commit` - 提交生成的文档
- `/simplify` - 简化生成的文档
