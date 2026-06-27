# 多 Profile 模型分配策略

> 基于 2026年6月主流模型实测 + 7-profile 创作流水线任务特征，为每个 profile 匹配合适的模型。

## 当前可用模型（2026年6月）

| 厂商 | 创意写作旗舰 | 推理/分析 | 快速版 | 中文质量 |
|------|:----------:|:-------:|:----:|:------:|
| **Google** | **Gemini 3.1 Pro** | Gemini 3.1 Deep Think | Gemini 3.5 Flash / 3.1 Flash-Lite | ⭐⭐⭐⭐ |
| **OpenAI** | **GPT-5.5** | o3 | GPT-5.5 Mini | ⭐⭐⭐⭐ |
| **Anthropic** | Mythos / Fable | — | Haiku | ⭐⭐⭐⭐ |
| **DeepSeek** | deepseek-v4-pro | deepseek-v4-pro (thinking) | deepseek-v4-flash | ⭐⭐⭐⭐⭐ |

## 任务分层

```
创意层 ─→ 剧本 · 大纲 · 圣经（需要发散+情感+格式精准）
品质层 ─→ 小说正文（需要中文散文质感）
分析层 ─→ 选题 · 趋势（需要推理+数据分析）
执行层 ─→ 合规 · 诊断（规则匹配+结构化输出）
```

## 6 Profile × 推荐模型

| Profile | 任务 | 首选模型 | 理由 |
|---------|------|---------|------|
| **webnovel-scriptwriter** | △剧本转换 | **Gemini 3.1 Pro** | "bringing creative concepts to life"——天然剧本引擎。对白自然不僵、情感层次多、△格式遵循严格 |
| **webnovel-planner** | 圣经+大纲 | **Gemini 3.1 Pro** | 世界观+人设需要创意发散，flash 写出来像套模板 |
| **webnovel-prompter** | 分镜提示词 | **Gemini 3.1 Pro** | 导演模式需要长上下文推理质量+视觉想象力+格式精准的综合能力 |
| **viral-webnovel** | 主控/小说正文 | **deepseek-v4-flash** | 中文散文质量+全流程调度，稳定性优先。小说写作能力保留但不使用——当前流程直出短剧 |
| **webnovel-auditor** | 合规审计 | deepseek-v4-flash | 规则匹配型任务，flash 完全胜任 |
| **webnovel-reviewer** | 诊断/审查 | deepseek-v4-flash | 分析型任务，不需要极致创意 |

## 决策树

```
任务涉及创意发散/情感张力/格式精准？
  ├── 是 → 任务需要长上下文推理（全集剧本+情绪弧线）？
  │         ├── 是 → Gemini 3.1 Pro（分镜提示词 — 导演模式）
  │         └── 否 → Gemini 3.1 Pro（剧本/大纲/圣经）
  └── 否 → 任务涉及中文散文品质？
            ├── 是 → GPT-5.5 或 deepseek-v4-pro（小说正文）
            └── 否 → 任务涉及推理/分析？
                      ├── 是 → deepseek-v4-pro（趋势/选题）
                      └── 否 → deepseek-v4-flash（合规/诊断）
```

## 模型切换命令

```bash
# 检查当前配置
hermes config show model --profile <profile名>

# 切换模型
hermes config set model.default <模型名> --profile <profile名>
hermes config set model.provider <provider名> --profile <profile名>
```

## 注意事项

- **Gemini 系列需要 Google AI Studio API key**（免费额度足够日常使用）
- **GPT-5.5 需要 OpenAI API key 或通过 OpenRouter 中转**
- **deepseek 系列已有 opencode-go provider**，切换零成本
- 跨 profile 切换模型时，确保对应 provider 已在目标 profile 的 config 中配置
