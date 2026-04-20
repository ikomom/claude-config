# Mermaid 图表指南

本文档提供 Mermaid 图表的使用指南，帮助生成清晰、准确的技术文档图表。

## 常用图表类型

### 1. 架构图（graph TB/LR）

用于展示系统模块关系、数据流向。

**语法**：
```mermaid
graph TB
    A[模块A] --> B[模块B]
    B --> C[模块C]
    C --> D[模块D]
```

**适用场景**：
- 系统架构图
- 模块依赖关系
- 数据流向图

**示例**：
```mermaid
graph TB
    用户[用户] --> 前端[前端应用]
    前端 --> API[API 服务]
    API --> 数据库[(数据库)]
    API --> 缓存[(缓存)]
```

### 2. 流程图（flowchart TD）

用于展示业务流程、算法逻辑。

**语法**：
```mermaid
flowchart TD
    Start[开始] --> Process[处理]
    Process --> Decision{判断条件}
    Decision -->|是| Success[成功]
    Decision -->|否| Retry[重试]
    Retry --> Process
    Success --> End[结束]
```

**适用场景**：
- 业务流程
- 算法逻辑
- 决策树

### 3. 时序图（sequenceDiagram）

用于展示组件间的交互时序。

**语法**：
```mermaid
sequenceDiagram
    participant 用户
    participant 前端
    participant API
    participant 数据库
    
    用户->>前端: 发起请求
    前端->>API: 调用接口
    API->>数据库: 查询数据
    数据库-->>API: 返回结果
    API-->>前端: 返回响应
    前端-->>用户: 显示结果
```

**适用场景**：
- API 调用流程
- 组件交互
- 消息传递

### 4. 状态图（stateDiagram-v2）

用于展示状态机、生命周期。

**语法**：
```mermaid
stateDiagram-v2
    [*] --> 空闲
    空闲 --> 运行: 启动
    运行 --> 暂停: 暂停
    暂停 --> 运行: 恢复
    运行 --> 停止: 停止
    停止 --> [*]
```

**适用场景**：
- 状态机
- 生命周期
- 工作流状态

### 5. 类图（classDiagram）

用于展示类结构、继承关系。

**语法**：
```mermaid
classDiagram
    class 用户 {
        +姓名: string
        +邮箱: string
        +登录()
        +登出()
    }
    class 管理员 {
        +权限: string[]
        +管理用户()
    }
    用户 <|-- 管理员
```

**适用场景**：
- 类结构
- 继承关系
- 接口定义

## 中文标签规范

### 节点命名

✅ **推荐**：使用有意义的中文名称
```mermaid
graph TB
    用户输入 --> 数据验证
    数据验证 --> 业务处理
```

❌ **不推荐**：使用抽象的字母
```mermaid
graph TB
    A --> B
    B --> C
```

### 边标签

使用中文描述关系：
```mermaid
graph TB
    A[前端] -->|HTTP 请求| B[API]
    B -->|SQL 查询| C[数据库]
```

### 分组（subgraph）

使用中文分组名称：
```mermaid
graph TB
    subgraph "前端层"
        Web[Web 应用]
        Mobile[移动应用]
    end
    
    subgraph "后端层"
        API[API 服务]
        Worker[后台任务]
    end
    
    Web --> API
    Mobile --> API
```

## 图表优化技巧

### 1. 控制节点数量

- 单个图表节点数量控制在 **20 个以内**
- 超过 20 个节点时，考虑拆分为多个图表

### 2. 合理使用方向

- `TB`（Top to Bottom）：适合层级结构
- `LR`（Left to Right）：适合流程图
- `TD`（Top Down）：同 TB

### 3. 使用样式

```mermaid
graph TB
    A[正常节点]
    B[重要节点]
    C[警告节点]
    
    style B fill:#4a90e2,color:#fff
    style C fill:#f5a623,color:#fff
```

### 4. 避免交叉线

调整节点顺序，减少连线交叉：

❌ **不好**：
```mermaid
graph LR
    A --> C
    B --> D
    C --> B
```

✅ **更好**：
```mermaid
graph LR
    A --> C
    C --> B
    B --> D
```

## 常见错误

### 1. 缺少闭合的反引号

❌ **错误**：
```markdown
\`\`\`mermaid
graph TB
    A --> B
（缺少闭合的 \`\`\`）
```

✅ **正确**：
```markdown
\`\`\`mermaid
graph TB
    A --> B
\`\`\`
```

### 2. 特殊字符未转义

❌ **错误**：
```mermaid
graph TB
    A[用户(管理员)] --> B
```

✅ **正确**：
```mermaid
graph TB
    A["用户(管理员)"] --> B
```

### 3. 箭头语法错误

❌ **错误**：
```mermaid
graph TB
    A -> B  （单箭头）
```

✅ **正确**：
```mermaid
graph TB
    A --> B  （双箭头）
```

## 实际示例

### 系统架构图

```mermaid
graph TB
    subgraph "表现层"
        UI[前端组件]
        View[视图渲染器]
    end
    
    subgraph "业务层"
        Logic[业务逻辑]
        Service[服务层]
        Process[处理引擎]
    end
    
    subgraph "数据层"
        Store[状态管理]
        DB[(数据库)]
    end
    
    subgraph "外部服务"
        API[外部 API]
        Cache[缓存服务]
    end
    
    UI --> Process
    Process --> Store
    Logic --> API
    Service --> API
    Store --> DB
```

### 数据流时序图

```mermaid
sequenceDiagram
    participant 用户
    participant 前端
    participant API服务
    participant 业务逻辑
    participant 数据库
    
    用户->>前端: 提交请求
    前端->>API服务: 调用 API
    API服务->>业务逻辑: 处理请求
    业务逻辑->>数据库: 查询数据
    数据库-->>业务逻辑: 返回结果
    业务逻辑-->>API服务: 处理完成
    API服务-->>前端: 返回响应
    前端-->>用户: 显示结果
```

### 状态机图

```mermaid
stateDiagram-v2
    [*] --> 空闲
    
    空闲 --> 运行中: start()
    运行中 --> 暂停: pause()
    暂停 --> 运行中: resume()
    运行中 --> 空闲: stop()
    
    空闲 --> 处理中: process()
    处理中 --> 空闲: complete()
    
    note right of 运行中
        执行任务队列
        处理业务逻辑
    end note
    
    note right of 处理中
        数据处理
        状态更新
    end note
```

## 验证图表

生成图表后，使用以下方法验证：

### 1. 语法检查

```bash
# 检查 mermaid 代码块是否闭合
grep -A 20 '```mermaid' docs/*.md | grep -c '```'
```

### 2. 在线预览

使用 [Mermaid Live Editor](https://mermaid.live/) 预览图表。

### 3. 常见问题检查清单

- [ ] 所有代码块都有闭合的 ```
- [ ] 节点名称使用中文
- [ ] 特殊字符已转义（使用引号）
- [ ] 箭头语法正确（-->）
- [ ] 节点数量 ≤ 20
- [ ] 图表方向合理（TB/LR）
