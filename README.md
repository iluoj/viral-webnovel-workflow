# viral-webnovel-workflow v2.0

## 架构：自媒体团队（7+1 Profile）

```
用户对话入口（你）
│
└── webnovel-lead（总负责人）
    │  编排流水线、创建 Kanban 任务、审核产出
    │
    ├── webnovel-planner  → 趋势分析 → 选题 → 圣经 → 大纲 → 试读
    ├── webnovel-writer   → 写作循环（5章×10批=50章）
    ├── webnovel-adapter  → 网文→△格式剧本（唯一依赖 drama-adaptation.md）
    ├── webnovel-auditor  → 2026抖音合规审计（唯一依赖 platform-compliance-2026.md）
    ├── webnovel-prompter → 麻薯动漫导演分镜提示词
    └── webnovel-reviewer → 全局复盘（完本后独立视角）
```

## 流水线

```
第1阶段：策划（planner）
  趋势扫描 → 选题池 → 故事圣经 → 前30章大纲 → 试读计划

第2阶段：写作循环（writer） 
  每批5章 × 10批 = 50章
  每批：draft-5 → compress → diagnose(增量) → humanize(可选)

第3阶段：剧本转译（adapter）
  网文 → △格式剧本，每章转1集，每集一个独立文件

第4阶段：合规审计（auditor）
  8板块全检：绝对禁止×8 + 高风险×5 + 红线×6 + 隐性红线×5
  通过后进入下一阶段，不通过退回修改

第5阶段：分镜提示词（prompter）
  △剧本 → 麻薯格式分镜提示词，每15秒一段

第6阶段：全局复盘（reviewer）
  钩子检查 + 叙事跳跃检测 + 感情线节奏检查
```

## 规则隔离设计

每个 profile 的 SKILL.md 只定义自己的职责，reference 文件不超过4个：

| profile | reference 数 | 拥有的工具 |
|:--------|:-----------:|:-----------|
| lead | 0 | clarify, kanban, file, terminal |
| planner | 4 | web, clarify, file, terminal |
| writer | 4 | file, terminal |
| adapter | **1**（drama-adaptation.md） | file, terminal |
| auditor | **2**（platform-compliance-2026.md + template） | file, terminal |
| prompter | 3 | clarify, file, terminal |
| reviewer | **1**（diagnose-loop.md） | file, terminal |

## 文件结构

```
viral-webnovel-workflow/
├── README.md                   ← 本文件
├── architecture.md             ← 完整架构说明
├── profiles/                   ← 各 profile 的 SKILL.md + reference
│   ├── lead/SKILL.md
│   ├── planner/{SKILL.md, references/*}
│   ├── writer/{SKILL.md, references/*}
│   ├── adapter/{SKILL.md, references/*}
│   ├── auditor/{SKILL.md, references/*}
│   ├── prompter/{SKILL.md, references/*}
│   └── reviewer/{SKILL.md, references/*}
└── agents/                     ← OMO 便携版（纯文本，平台无关）
    ├── 00-lead-agent.md
    ├── 01-planner-agent.md
    ├── 02-writer-agent.md
    ├── 03-adapter-agent.md
    ├── 04-auditor-agent.md
    ├── 05-prompter-agent.md
    └── 06-reviewer-agent.md
```

## 使用方式

### Hermes 原生（推荐）

```bash
hermes --profile webnovel-lead
```

总负责人通过 Kanban 分配任务给其他 profile，后台自动执行。

### 平台无关（OMO Agent）

每个 agent 文件是纯文本 .md，可喂给任何 AI 工具：

```bash
cat agents/02-writer-agent.md | codex -p "写第6-10章"
cat agents/04-auditor-agent.md | claude -p "审计 02_正文_第1-5章.md"
```

## 版本历史

| 版本 | 日期 | 内容 |
|:----|:----|:------|
| v1.0 | — | 单 profile viral-webnovel 全套工作流 |
| v1.1 | — | 同步 live profile 更新 |
| **v2.0** | 2026-06-25 | **多 profile 团队架构：7个独立 profile + Kanban 协作** |
