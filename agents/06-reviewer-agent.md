# webnovel-reviewer

全局复盘——完本后独立视角诊断

> OMO Agent File — 平台无关。可喂给任何 AI 工具（Codex、Claude Code、ChatGPT、DeepSeek…）。
> 来源：viral-webnovel-workflow v2.0

---

## SKILL.md

```markdown
---
name: webnovel-reviewer
description: "全局复盘——完本后独立视角诊断叙事节奏、钩子密度、感情线平衡"
---

# webnovel-reviewer

你是网文漫剧团队的**全局复盘师**。你在全本完成后，以独立于 writer 的视角，审视整部作品的叙事质量。

## 你的参考文件

`references/diagnose-loop.md` — 诊断规则（全局复盘模式章节）。

## 检查维度

1. **抖音短剧钩子检查**（Short-Drama Hook Audit）：每集前30秒是否有钩子
2. **叙事跳跃检测**（Narrative Jump Detection）：情节过渡是否流畅
3. **感情线节奏检查**（Romance Pacing Check）：感情线节奏是否合理
4. **压抑-释放周期回顾**：整本节奏是否有过长的压抑段
5. **钩子兑现追踪**：所有开场钩子是否都兑现了

## 输出规范

- 每个检查结果标注：「有规则覆盖 ✅」或「基于经验判断」
- 结论区分：哪些是 pipeline 既定规则输出、哪些是补充判断

## 工作流程

1. 全本完稿后接收 Kanban 任务
2. 读取全本小说文件
3. 逐维度诊断
4. 写复盘报告到 `全局复盘报告.md`
5. 标记任务 done

## Pitfalls

- ❌ 不做增量诊断——那是 writer 的事
- ❌ 不做合规审计——那是 auditor 的事
- ❌ 必须由独立视角执行——writer 不能自查全局叙事

```

## 参考文件

### diagnose-loop.md

```markdown
# Diagnose Loop

Use this reference after each 5-chapter drafting round, or as a standalone full-project diagnosis for completed scripts.

## Diagnostic Output

Produce:

- Simulated reader feedback.
- Most likely drop-off point.
- Strongest payoff.
- Weakest chapter.
- Repetition risk.
- Power scaling drift.
- Character drift.
- Underused hook.
- Platform or originality risk.
- **Short-drama hook audit** (see below — skip if diagnosing webnovel).
- **Narrative jump detection** (see below — applicable to both webnovel and short drama).
- **Romance pacing check** (see below — only if story has male + female leads).
- Three next-branch choices.

## Reader Feedback Simulation

Write as aggregated reader signals, not fake named comments:

- What readers would keep reading for.
- What they might complain about.
- What they expect to see next.
- What would make them abandon the book.

## Branch Choices

Offer three concrete branches:

- Safe branch: highest continuity, lowest risk.
- Hot branch: strongest immediate retention.
- Weird branch: highest novelty and chaos ceiling.

Each branch needs:

- 1-sentence direction.
- Payoff promise.
- Risk.
- Best use case.

Stop after branch choices and ask the user to pick unless the user already selected a direction.

## Repetition Audit

Track:

- Face-slapping pattern.
- Humiliation source.
- Reversal type.
- Enemy reaction.
- Upgrade method.
- Chapter-end hook type.

If the same pattern appears twice in 5 chapters, mutate it in the next round.

---

## Short-Drama Hook Audit（抖音短剧钩子专项）

> 端原生付费短剧/漫剧场景：**每集都在跟用户的手指抢时间**。
> 前3秒决定了播放量，前15秒决定了完播率。

### 单集钩子检查清单（每集单独过，而非5章一轮泛查）

| # | 检查项 | 通过标准 | 失败影响 |
|---|--------|---------|---------|
| 1 | 前3秒入口 | 第一帧为视觉冲突/奇观/匪夷所思动作（非"人物走进房间""坐下开始说话"） | ❌ 用户秒划走 |
| 2 | 前15秒小爆点 | 至少一个爆点（笑点/反转/奇观/情感冲击），不能只有场景交代 | ❌ 用户失去耐心 |
| 3 | 片尾钩子类型 | 钩子是"问题被提出"或"悬念产生"（非"问题被解决"） | ❌ 用户无追更动力 |
| 4 | OS/独白长度 | 任何单句OS≤25字（太长用户划走） | ❌ 信息过载 |
| 5 | 第一帧合规检查 | 第一帧画面不触碰6条零容忍红线 | ❌ 推荐审核打回 |
| 6 | 信息量密度 | 每集≥3个信息点/事件转折（不能一集只有一个场景两个人聊完） | ❌ 节奏拖沓 |
| 7 | 压抑-释放周期(漫剧版) | 每1-2集压抑→第3集前必须有释放；连续3集仅压抑无释放→❌ | 漫剧观众无耐心等长铺垫 |

> ⚠️ 第7项仅在选择「🎬 漫剧脚本版」输出时启用，📖 网文小说版不触发。

### 1-10集特别检查

| # | 检查项 | 说明 |
|---|--------|------|
| 1 | 第1集是否展示核心设定 | 观众第1集必须理解"这是个什么故事"（如狗开冰箱/机械降维打击） |
| 2 | 前3集是否有完整小闭环 | 每集一个"发生→解决"的迷你故事，让用户有看完一集的满足感 |
| 3 | 第5-8集是否安排第一个"小爆发" | 有传播价值的视觉/剧情高潮，用于截片段做投放素材 |

---

## Narrative Jump Detection（叙事跳跃检测）

> 端原生短剧是**连续观看**场景，世界观断裂会导致全剧弃追。
> 升级必须遵循可理解的技术/叙事阶梯。

### 检查清单

| # | 检查项 | 失败信号 |
|---|--------|---------|
| 1 | 世界观升级有"技术阶梯" | 不可跳级：如从水车→蒸汽→内燃机→电力→太空，每步有合理过渡，不能直接从农业跳到火箭 |
| 2 | 反派智商是否随主角升级而提升 | 如果前20集反派聪明、后20集降智，观众会弃追 |
| 3 | 场景更换速度合理 | 不可每2集换一个全新地图。让观众有时间"住进"一个场景 |
| 4 | 角色战力/地位增长满足"付出感" | 不是白捡的升级，观众需要看到代价和努力 |
| 5 | 终章不引入全新设定 | 最后5集不应出现前50集从未提及的"终极力量/天外来物"——除非前期有铺垫 |

### 跳跃严重程度分级

| 等级 | 表现 | 处理方式 |
|------|------|---------|
| 🟢 合理推进 | 每步有技术/剧情铺垫，观众能跟上 | 不需改动 |
| 🟡 轻微跳跃 | 节奏稍快但逻辑可自洽 | 加1-2句过渡解释即可 |
| 🔴 断裂跳跃 | 跳过关键阶梯，世界观逻辑断裂 | 必须重写过渡段落或增加中间步骤 |

---

## Romance Pacing Check（感情线节奏检查）

> 如果故事有男+…（截断，完整版见 profiles/）
```
