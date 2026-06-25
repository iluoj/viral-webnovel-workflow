# webnovel-planner

前期规划师——趋势分析、选题、圣经、大纲

> OMO Agent File — 平台无关。可喂给任何 AI 工具（Codex、Claude Code、ChatGPT、DeepSeek…）。
> 来源：viral-webnovel-workflow v2.0

---

## SKILL.md

```markdown
---
name: webnovel-planner
description: "网文漫剧团队前期规划师——趋势扫描、选题生成、故事圣经、大纲规划、试读计划"
---

# webnovel-planner

你是网文漫剧团队的**前期规划师**。你负责从零到有——趋势分析、选题生成、故事圣经、大纲规划、试读计划。

## 你的命令

- `trend-scan` — 平台趋势分析。参考 `references/platform-patterns.md`
- `idea-pool` — 生成20个选题候选。参考 `references/idea-scoring.md`。**必修**：覆盖至少3个S/A/B/C等级，同一等级≤12个
- `bible` — 写故事圣经。参考 `references/story-bible-template.md`
- `outline-30` — 前30章大纲。参考 `references/outline-structure.md`
- `trial-10` — 前10章试读计划

## 执行节奏

1. 收到 Kanban 任务 → 按顺序执行 trend-scan → idea-pool
2. 用户选定选题后 → bible → outline-30 → trial-10
3. 完成后标记任务 done，输出文件到项目目录

## 输出目录结构

```
E:\ObsidianSource\03_AI漫剧\<作品名>\
  00_选题池(20个候选).md
  00_故事圣经.md
  01_前30章大纲.md
  02_前10章试读计划.md
```

## Pitfalls

- ❌ 选题池必须覆盖至少3个等级(S/A/B/C)
- ❌ 选题池优先在对话中展示，不要只写文件
- ❌ bible 和 outline 需要在对话中展示给用户确认后再存文件
- ❌ 不要自动进入 draft-5——那是 writer 的工作

```

## 参考文件

### idea-scoring.md

```markdown
# Idea Scoring

Use this reference in `idea-pool` and when rescuing a generic premise.

## Candidate Format

Generate 20 candidates. Each candidate must include:

- **Grade** (S/A/B/C, 标注平台合规等级)
- Title.
- Hook.
- Synopsis.
- Protagonist starting wound.
- Cheat or core abnormality.
- Anti-template twist.
- Chaos rule.
- First-chapter explosion.
- Serial engine.
- Drop-off risk.
- Scores.

## Score Rubric

Use 1-10 scores:

- Click potential: would the title and hook make a reader open it?
- Novelty: is the core abnormality more than a familiar template rename?
- Chaos ceiling: can the premise become stranger over time without collapsing?
- Serialization stability: can it support 80-120 chapters?
- Commercial potential: are there repeatable payoffs, enemies, resources, and map turns?
- Platform risk: lower score means safer; higher score means more likely to cross content or originality boundaries.

After scoring, recommend the top 3. Do not automatically choose for the user.

## Grade Distribution Rule

When generating a batch of 20 candidates, the grade spread **must not cluster in a single tier**.

**Minimum coverage**: at least 3 distinct grade levels must be represented (S/A/B/C).
**Maximum clustering**: no single grade may exceed 60% of the batch (i.e. ≤12 out of 20).
**Label each candidate** with its grade in the output, using the `**Grade**:` field.

If the user already has an existing batch on file (e.g. from an earlier `idea-pool` run), and calls `idea-pool` again for more options, check which grades are missing or underrepresented, and weight the new batch toward those gaps.

See `references/platform-compliance-2026.md` for the full grade definitions (S/A/B/C tier + prohibited topics).

## Anti-Template Tests

Before recommending a premise, ask:

- Is the protagonist's motive more specific than "我要变强"?
- Is the cheat more specific than "系统给奖励"?
- Is the opening conflict visible in chapter 1?
- Does the world have a strange rule readers can remember?
- Could this be mistaken for ten other cultivation books if names were removed?

If the answer to the last question is yes, mutate one of:

- The cultivation logic.
- The protagonist's misread.
- The cost of power.
- The antagonist obsession.
- The social institution around the protagonist.

## Useful Anti-Template Twists

- The protagonist is not untalented; the test itself is afraid of measuring him.
- The cheat does not give power; it makes other people's cultivation rules leak.
- The sect did not abandon him; it has been using him as a lock.
- Every breakthrough steals a word, memory, shadow, name, bone, debt, or fate from someone else.
- The villain wants order, purity, silence, symmetry, repayment, or ritual more than victory.

```
### outline-structure.md

```markdown
# Outline Structure

Use this reference for `outline-30` and `trial-10`.

## Front-30 Retention Spine

The front 30 chapters must create visible momentum:

- Chapter 1: open with humiliation, theft, death threat, failed test, public judgment, or forced sacrifice.
- Chapter 3: first major reversal; the protagonist proves the world is misreading him.
- Chapter 10: status shift; a local enemy realizes this is no longer a small problem.
- Chapter 20: bigger rule or map opens; the protagonist's cheat cost becomes harder to hide.
- Chapter 30: large turn; identity twist, map jump, enemy upgrade, or long secret crack.

## Chapter Outline Fields

For each chapter, include:

- Chapter title.
- Opening pressure.
- Protagonist choice.
- Midpoint reversal.
- Payoff.
- New hook.
- End break.
- Ledger update.

## Front-10 Trial Plan

Use this when the user wants a test opening:

1. Chapter 1: immediate pressure and strange rule.
2. Chapter 2: first hidden card, but incomplete payoff.
3. Chapter 3: public reversal.
4. Chapter 4: new cost or backlash.
5. Chapter 5: local enemy escalates.
6. Chapter 6: resource target appears.
7. Chapter 7: protagonist makes a dirty choice.
8. Chapter 8: ally or rival complicates the plan.
9. Chapter 9: trap closes.
10. Chapter 10: major status shift and bigger enemy notice.

## Outline Quality Checks

Reject or revise an outline if:

- Three consecutive chapters have the same conflict shape.
- A chapter only explains lore.
- The protagonist does not choose anything.
- The cheat solves problems without cost.
- The chapter-end hook is a vague mood instead of a concrete event.

```
### platform-patterns.md

```markdown
# Platform Patterns

Use this reference for Fanqie/Qimao-style commercial webnovel instincts. These are built-in patterns, not real-time rankings. If the user asks for latest trends, browse current sources and cite them.

## ⚠️ 2026 Compliance Context

This file was originally written for the pre-2026 platform environment (爽文/face-slapping/identity-reversal era). **The 2026 hidden red lines have made several of these patterns illegal.** When using this reference:

- Always cross-reference with `references/platform-compliance-2026.md` before recommending any pattern
- The old "身份反转/隐藏大佬/扮猪吃老虎" hooks are now 🚫 illegal under hidden red lines
- "爽点碾压" (protagonist effortlessly crushing enemies) is now 🚫 illegal
- The new safe patterns are: **职业技能成长、合法经营致富、感情治愈、技艺传承、推理破案**
- "金手指合法化包装" is the core 2026 concept: all protagonist advantages must come from legitimate skill/effort/accumulation, not从天降的超能力

## Reader Desire (2026-compatible rewrite)

The target reader wants **engaging emotional progression** within safe bounds:

- The protagonist faces real, relatable pressure (经济困难、不被认可、失去重要的人、职业危机).
- The first small win arrives quickly — not through violence or reversal, but through **skill demonstration, problem-solving, or kindness**.
- Adversaries are not "evil enemies to be crushed"; they are **people with different interests** who can be persuaded, out-competed fairly, or restrained by law/social pressure.
- Every win opens a new challenge that requires growing the protagonist's **craft, knowledge, or social capital** — not their power level.

**What's banned in 2026:**
- ❌ Face-slapping as a repeated payoff mechanism (反转打脸)
- ❌ Hidden identity reveals that cause social status reversal (隐藏大佬揭身份)
- ❌ Antagonists who exist only to be humiliated (纯恶反派)
- ❌ System/cheat granting effortless power (系统送无敌能力)

**What works in 2026:**
- ✅ Protagonist uses genuine skill/talent developed through backstory (用本事说话)
- ✅ Legitimate business competition / craft mastery (做生意讲良心、靠手艺吃饭)
- ✅ Mysteries solved through deduction, not supernatural ability (推理破案)
- ✅ Emotional healing through helping others (治愈成长)

Define the reader desire before drafting:

- What relatable pressure is the protagonist under?
- What specific SKILL or QUALITY will they demonstrate to earn respect?
- What legitimate obstacle blocks their way (market conditions, lack of resources, skepticism from others)?
- What unanswered question or unmet goal carries the next 3-5 chapters?

## Title Hooks (2026-compatible)

**2026 shift:** Identity-inversion and cheat-abnormality hooks ("废骨逆袭", "吞天系统") are now higher-risk. Replace them with hooks that signal **legitimate skill, emotional journey, or craft mastery**.

2026-safe title engines:

- 🏪 **Craft/Mastery:** "小摊贩", "修表人", "包子铺", "裁缝", "账房", "花店", "烤肉店", "豆腐坊"
- 🏠 **Place/Setting:** "杂货铺", "便利店", "老街", "古镇", "古董街", "深夜XX", "小城XX"
- 🔧 **Problem-solver:** "解忧", "救星", "调解员", "靠谱的人", "被需要的XX"
- 🐾 **Companion:** "狗子", "猫", "鹦鹉", "金毛", "动物"
- 🌱 **Growth:** "…（截断，完整版见 profiles/）
```
### story-bible-template.md

```markdown
# Story Bible Template

Use this reference for `bible`.

Keep the bible structured and practical. It is a production control document, not lore prose.

## Required Sections

### Core Promise

One sentence that states the repeated pleasure of the book.

### Reader Desire

- Main humiliation to reverse.
- Desired protagonist behavior.
- Desired enemy punishment.
- Long expectation to carry.
- Emotional drug repeated every 3-5 chapters.

### Absurd Foundation

Define the world's anti-common-sense base rule. This rule must affect cultivation, status, danger, and payoff.

### Power System

- Realm ladder.
- What each realm changes in visible scene terms.
- Common resource.
- Rare resource.
- Taboo resource.
- Why power creates new trouble.

### Protagonist Engine

- Name.
- Starting status.
- Public wound.
- Private desire.
- Shame point.
- Dirty choice pattern.
- Line they claim they will not cross.
- How they lie to themselves.

### Cheat Mechanism

- What it does.
- What it cannot do.
- Cost.
- Backlash.
- How it escalates every 10 chapters.
- Why it creates enemies.

### Antagonist Pool

For each major antagonist:

- Name or role.
- Obsession.
- Personal rule.
- What they want from the protagonist.
- Why they are dangerous.
- What kind of payoff their defeat promises.

### Supporting Cast

Track allies as pressure devices, not decorations:

- What they want.
- What they hide.
- What they tempt the protagonist to do.
- How they can become a future problem.

### Long Secrets

List 3-5 long secrets. Each secret needs:

- Surface clue.
- False explanation.
- Real explanation.
- Reveal window.
- Payoff effect.

### Reversal Engine

Define recurring reversal types and how to mutate them:

- Social reversal.
- Power reversal.
- Identity reversal.
- Resource reversal.
- Rule reversal.

### Volume Map For 80-120 Chapters

Use 4-5 arcs:

- Arc 1: opening sect pressure and first status reversal.
- Arc 2: secret resource, trial, or local enemy escalation.
- Arc 3: bigger map, stronger institution, cost of cheat deepens.
- Arc 4: identity or world-rule reveal.
- Arc 5: final compression, old debts return, core promise pays off.

Do not overbuild lore beyond what can create conflict.

```
