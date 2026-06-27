# 13-Agent 网文工厂 - 融合架构

> 融合 13-agent 并行流水线 + viral-webnovel reference 注入 + 滚动压缩记忆系统

## 架构概览

```
Stage 1 ─ ag_001 赛道分析
  │
  ├─ Stage 2a ─ ag_002 世界观搭建  (parallel)
  ├─ Stage 2b ─ ag_003 物品能力设计 (parallel)
  │
  ├─ Stage 3 ─ ag_004 人设塑造
  │
  ├─ Stage 4a ─ ag_005 大纲规划 (parallel)
  ├─ Stage 4b ─ ag_006 冲突设计 (parallel)
  │
  ├─ Stage 5 ─ ag_007 正文主笔
  │   ├─ (optional) ag_011 玩梗
  │   ├─ (optional) ag_012 搞笑 ← parallel, feedback to ag_007
  │   └─ (optional) ag_013 热点
  │
  ├─ Stage 7 ─ ag_008 审核校准 (can reject → Stage 5)
  │
  ├─ Stage 8a ─ ag_009 文笔优化 (parallel)
  ├─ Stage 8b ─ ag_010 标题钩子 (parallel)
  │
  ├─ [新增] Stage 9 ─ ag_013b 合规审计 (platform-compliance-2026.md)
  │   └── can reject → Stage 5 or flag for rewrite
  │
  └─ [新增] Stage 10 ─ ag_014 短剧转换 (drama-adaptation.md + short-drama/ 方法论)
      └── 网文 → △格式短剧剧本
```

## Agent Reference Injection Map

| Agent | Injected Reference Files |
|-------|-------------------------|
| ag_001 | `platform-patterns.md`, `idea-scoring.md`, `platform-compliance-2026.md` |
| ag_002 | `story-bible-template.md`, `platform-patterns.md`, `manga-hit-guide-2026.md` |
| ag_003 | `story-bible-template.md`, `chapter-template.md`, `manga-hit-guide-2026.md` |
| ag_004 | `story-bible-template.md`, `platform-patterns.md` |
| ag_005 | `outline-structure.md`, `chapter-template.md`, `manga-hit-guide-2026.md` |
| ag_006 | `outline-structure.md`, `diagnose-loop.md` |
| ag_007 | `chapter-template.md`, `memory-system.md`, `platform-compliance-2026.md` |
| ag_008 | `diagnose-loop.md`, `platform-patterns.md` |
| ag_009 | `rewrite-humanization.md` |
| ag_010 | `platform-patterns.md` |
| ag_011/012/013 | `platform-patterns.md` |
| **ag_013b 合规审计** | `platform-compliance-2026.md` |
| **ag_014 短剧转换** | `drama-adaptation.md`, `platform-compliance-2026.md` |

## Memory Flow

Each stage parent merges child JSON outputs into a rolling context package:

```json
{
  "active": {"unresolved_hooks": [], "character_states": {}, "current_conflict": ""},
  "cold_storage": {"settled_arcs": [], "paid_hooks": []}
}
```

## Quickstart Commands

- `trend-scan` → ag_001 (赛道分析 + 选题池，S/A/B/C分级)
- `bible` with `mode: 13agent` → Stages 2-3 parallel
- `outline-30` with `mode: 13agent` → Stages 4 parallel
- `draft-5` with `mode: 13agent` → Stages 5-8 with optional趣味增强
- `audit` → ag_013b 合规审计（platform-compliance-2026 审核）
|- `drama` → ag_014 短剧转换（网文→△格式剧本）
- `diagnose` → ag_008 审核
- `humanize` → ag_009 润色

## Usage Note

Lightweight execution by default. The full 13-agent orchestration is for power users or explicit "full pipeline" requests. Start with single-agent mode, escalate to parallel when the user asks for depth.
