---
name: viral-webnovel
description: "Full-pipeline Chinese webnovel factory: novel creation + short-drama adaptation + platform compliance. Covers Fanqie/Qimao fiction (premise-to-chapter drafting, both 男频 and 女频), △-format short-drama conversion, and 2026 Douyin compliance filtering (S/A/B/C tier + hidden red lines). Supports three output modes: standard webnovel, lightweight test, and 漫剧 short-drama adaptation (60-80集 × 600-800字/集)."
---

# viral-webnovel

Use this skill as a serialized fiction director, not as a one-shot novel generator. The V1 default is Chinese xuanhuan cultivation fiction for an 80-120 chapter short-to-mid serial: waste-to-power opening, abnormal cheat, sect pressure, face-slapping, upgrade, treasure conflict, map escalation, and hard chapter hooks. Also supports 女频: female-lead stories with CP romance lines, food cultivation, court intrigue, or female-centric power growth.

Default to Chinese output unless the user asks otherwise.

## Execution Cadence & Format Decision

**Respect the user's time.** Three output modes:

- 🟢 **Lightweight** (default for testing/validation): ~2000字 to prove a flow works. Single agent, key output only, no deep-dive. Use when the user says "测试一下" or doesn't specify depth.
- 🔵 **Full** (when user asks for complete output): Full depth, multi-stage, all 9 standard round items.
- 🎬 **漫剧适配版** (for stories destined for 3D short-drama adaptation): 60-80 chapters total, 600-800字/chapter, scene-oriented writing (dialogue+action heavy, minimal internal monologue), designed for 1 chapter = 1 drama episode.

Default to lightweight unless the user explicitly asks for comprehensive output.

### ⚠️ 关键流程步骤：输出格式决策

**在进入 `draft-5` 之前，必须明确向用户确认输出格式。** 不能替用户假设。

格式决策发生在 `trial-10` 之后、第一次 `draft-5` 之前，必须向用户提问。具体选项：

1. **📖 网文小说版**（默认）
   - 1500-2000字/章，有心理描写和叙述铺陈
   - 后续通过 `drama-adapt` 命令转为△格式漫剧剧本
   - 适合先发番茄/七猫，再转短剧

2. **🎬 漫剧脚本版**
   - 600-800字/章，场景化写作（对话+动作驱动，无心理描写）
   - 直接产出可进制作流程的脚本
   - 适合直接做漫剧，不发网文平台

3. **📖→🎬 网文先写，后续转剧本**
   - 先按网文小说版写完整本
   - 完成后用 `drama-adapt` 逐卷转为漫剧剧本
   - 适合双平台运营：小说发平台赚稿费，剧本做漫剧赚流量

**如果不问清楚就默认选1（网文小说版），写完整本，然后由 `drama-adapt` 负责转换。**

## Branch Recommendation Pattern

When running `diagnose` and presenting three branches at Manual Checkpoint C, if the user says "帮我选" or expresses uncertainty:

**Always recommend one branch with clear reasoning.** Don't just list options again. Use this priority:

1. **🅰 安全分支** — if there's a clear payoff coming in the next 2-3 chapters (e.g., a planned public demonstration or major reversal), recommend staying the course. The most common diagnostic error is jumping to the payoff too early, which leaves a "hollow" mid-arc.
2. **🅱 热分支** — only recommend if the diagnose shows 3+ consecutive oppressive chapters WITHOUT a visible payoff in the next 2 chapters, OR if the repetition audit flags 2+ consecutive same-type conflicts.
3. **🅲 怪分支** — recommend only when the user explicitly asked for "颠" flavor, or when the current arc feels generic and needs a novelty injection.

**Reasoning format for recommendation:**
> "选A。理由是：现在的节奏[说明当前压抑/释放位置]，接下来第X章是[具体爽点事件]，如果跳过去会导致[具体问题]。"

**压抑-释放周期管理（核心诊断概念）：**
- 2-3章压抑 → 1章释放 = 健康节奏
- 4+章连续压抑 ← 危险，必须在下一章释放
- 连续2章同类冲突（如"被审问+又被审问"）← 需在下一轮变异冲突类型

### Pitfalls（格式相关）

- ❌ **不要用户提到"漫剧"或"短剧"就直接切到漫剧版写600字章节。** 很多用户的意思是"先写小说，以后转漫剧"，不是"直接写漫剧脚本"。必须先确认。
- ❌ **不要在同一轮 draft-5 中混淆两种格式。** 要么全按网文版写，要么全按漫剧版写。不能前两章1500字、后三章600字。
- ❌ **当用户说"字数会不会太多"时，不要自行切换到漫剧版。** 先问清楚："你是想缩减字数改为漫剧脚本，还是保持网文格式但减少总章数？"

## 命令归属

| 命令 | 所属 profile | 说明 |
|------|-------------|------|
| `trend-scan` | **viral-webnovel** | 平台趋势分析 |
| `idea-pool` | **viral-webnovel** | 选题生成 |
| `bible` | **viral-webnovel** | 故事圣经 |
| `outline-30` | **viral-webnovel** | 大纲规划 |
| `trial-10` | **viral-webnovel** | 试读计划 |
| `draft-5` | **viral-webnovel** | 正文写作 |
| `compress` | **viral-webnovel** | 记忆压缩 |
| `diagnose` | **viral-webnovel** | 弃读诊断 |
| `humanize` | **viral-webnovel** | 去AI味 |
| `drama-adapt` | **viral-webnovel** | △格式短剧剧本转换 |
| `prompt-gen` | **viral-webnovel** | 视频分镜提示词生成 |
| `compliance-audit` | **viral-webnovel** | 2026平台合规逐条过检 |

### 新建 profile 的步骤

当用户要求创建独立 profile 时：

1. 创建 profile：`hermes profile create <名称>`（支持 `--clone` 从现有 profile 复制）
2. 在新 profile 的 `skills/` 下创建 skill 目录（名称建议 `<profile同名>`）
3. 编写 SKILL.md：只包含该 profile 对应的命令定义
4. 复制参考文件：将 drama-adaptation.md、mantoufan-prompt-source.md、platform-compliance-2026.md 从 viral-webnovel 复制到新 profile 的 `skills/<name>/references/`
5. 配置：新 profile 可复用原 config 或单独配置模型/工具集

**⚠️ 跨 profile 写保护：** 当前 session 运行在 viral-webnovel profile 下，新建 profile 后写入新 profile 的 skills/plugins/cron/memories 必须添加 `cross_profile=True` 参数。

### Profile 间数据流向

```
viral-webnovel profile（写小说 + 转剧本独立副本）
  ┌──────────────┐
  │ draft-5      │ → 小说正文文件
  │ 第1-5章.md   │
  └──────┬───────┘
         ↓
  ┌──────────────┐
  │ compliance-  │ ← 本profile内直接执行
  │ audit        │
  └──────┬───────┘
         ↓
  ┌──────────────┐
  │ drama-adapt  │ ← 本profile内直接输出△剧本
  │ → ep001.md   │
  └──────┬───────┘
         ↓
  ┌──────────────┐
  │ prompt-gen   │ ← 本profile内直接输出分镜提示词
  │ → 素材清单   │
  │ → 段提示词   │
  └──────────────┘

  ## Hermes Profile 配置速查（本profile）

用户反映 Hermes 配置"好烦人"，以下是针对本 profile 的极简说明：

### 关键配置（只需关心这 3 行）

```yaml
model:
  default: deepseek-v4-flash-free   # 换模型就改这里
  provider: opencode-zen            # 供应商（不动）
  base_url: ''                      # 不动
```

**其他字段（`providers: {}`、`fallback_providers`、`credential_pool_strategies`）不用碰。**

### 实际有效的 key

本 profile 只有 1 个有效 key：`.env` 中的 `OPENCODE_ZEN_API_KEY`（由 Hermes 父进程从 .env 加载）。auth.json 中 `has_secret=False` 是正常现象——auth.json 只存元数据，不存具体密钥值。子进程（terminal/execute_code）查不到 key 也正常，父进程持有它。

凭证池中 Priority 1-3 的 key-2/3/4 是空壳，没有实际密钥。详细机制见 `references/hermes-credential-pool.md`。

### 换模型命令

```bash
hermes config set model.default <新模型名> --profile viral-webnovel
```

---

## Skill Distillation Principles（蒸馏外部skill的核心规范）

> 本段记录了上一轮与用户的重要纠正，作为所有 reference 创建/维护的强制规范。

**当从外部来源（GitHub 仓库、SkillsMP、API 文档等）蒸馏某个 skill 的能力添加到本 skill 时，必须遵守以下原则：**

### 原则一：输出模板必须直接复制原文

❌ **不要**写摘要版。例如：
```
用「镜头N」按事件顺序组织，每镜头含场景/角色/光照/运镜/情绪
```
✅ **要**直接嵌入源skill的完整模板：
```
画面无任何字幕。
0-3秒：[场景建立] - [镜头运动]，[详细画面描述]
3-6秒：[主体引入/情节发展] - [镜头运动]，[具体动作]
...
```

源skill定义了明确的输出格式时，**格式本身是核心能力的一部分**，不是可自由发挥的装饰。

### 原则二：用官网/源仓库验证

- 当对格式有疑问时，**主动访问源skill的发布页或仓库**验证原始格式定义
- 不要凭记忆或摘要"猜"格式
- 在参考文件顶部标注来源链接，方便回查

### 原则三：标注"直接嵌入版"而非"蒸馏版"

在参考文件顶部明确标注：
```
⚠️ 本文件是源skill的「直接嵌入版」，不是摘要或重构。
所有模板、铁律、输出格式均一字不差复制自源skill。
```

### 原则四：任何格式争议以源文件为准

当 SKILL.md 中的命令描述和 reference 文件有冲突时，reference 文件（嵌入原文的）优先。SKILL.md 中的命令描述可以简写（用「见 references/xxx.md」指向），但 reference 必须是完整原文。

## Portable Distribution (OMO Style)

This skill's writing capabilities can be exported as platform-agnostic agent prompt files, usable with any LLM tool (Codex, Claude Code, ChatGPT, DeepSeek, Cursor, etc.) — following the OMO pattern (cf. oh-my-zsh, oh-my-claude).

### Why

- **Portability:** each agent is a standalone `.md` file, feedable via stdin or copy-paste to any tool
- **Stability:** git-versioned with semantic tags (`v1.0`, `v2.0`); no silent changes during conversations
- **Backup + Share:** one `git push` backs up the entire pipeline; clone to give to others

### Export Mapping

| agent file | source command | what it contains |
|---|---|---|
| `01-idea-pool.md` | idea-pool | 20-premise generation + scoring criteria |
| `02-bible.md` | bible | world-building + story bible prompt |
| `03-outliner.md` | outline-30 | 30-chapter outline + structure rules |
| `04-writer.md` | draft-5 | chapter writing + chapter template (开头300字冲突/爽点/钩子) |
| `05-diagnoser.md` | diagnose | retention diagnosis + 3-branch recommendation |
| `06-compliance.md` | compliance-audit | 6 red lines + S/A/B/C tier audit |
| `07-drama-adapter.md` | drama-adapt | △-format short drama conversion |
| `08-prompt-engineer.md` | prompt-gen | time-axis storyboard prompts (0-3/3-6/6-9/9-12/12-15s) |

Each agent file is a pure system prompt: role definition, input spec, output format template (verbatim from this skill's reference files), and known pitfalls. No Hermes-specific syntax.

### Stability Convention

1. After first export: `git init && git add . && git commit -m "v1.0" && git tag v1.0`
2. Updates only on explicit user request ("封版" / "更新到v2.0")
3. Changes visible via `git diff v1.0..v2.0` — user reviews before accepting
4. After tagging, no automatic skill modifications during conversations. The user decides when to unfreeze.
5. **Workflow repo location**: `E:\viral-webnovel-workflow\` — viral-webnovel skill pipeline (SKILL.md + references/) lives here as a git repo. Push to GitHub needs a PAT token (password auth is deprecated).

### Usage Examples

```bash
# Write 5 chapters with Codex
cat 04-writer.md | codex -p "写第6-10章，主角苏棠在厨房试菜"

# Compliance audit with Claude Code
cat 06-compliance.md | claude -p "审计 02_正文_第1-5章.md"

# Full pipeline with any tool
cat 03-outliner.md 04-writer.md | llm -p "为我的废柴逆袭故事写大纲+前5章"
```

### Template File

See `references/omo-agent-template.md` for a complete agent `.md` example.

## Operating Rule

Push the work through controllable stages:

1. Find or invent stronger premises.
2. Ask the user to choose one premise before expanding it.
3. Build the story bible and opening structure.
4. Ask the user to confirm the skeleton before drafting.
5. Draft only 5 chapters per round.
6. Compress memory, diagnose retention, and offer branches after each round.
7. Ask the user to choose the next branch before continuing.
8. Run humanization as a separate pass when prose quality matters.

Do not attempt to write a full 80-120 chapter novel in one response. If the user asks for a full book, create the bible, front-30 outline, front-10 trial plan, and first 5-chapter round, then prepare the next-round context package.

## Advanced Mode: 13-Agent Parallel Orchestration

For teams or power users, the single-agent pipeline can be upgraded to a parallel 13-agent factory using Hermes `delegate_task`. See `references/13agent-workflow/` for the full design doc.

### Architecture summary

```
|Stage 1:  ag_001 赛道分析师  (single)
|Stage 2:  ag_002 世界观 + ag_003 宝物/物品  (parallel)
|Stage 3:  ag_004 人设塑造  (single)
|Stage 4:  ag_005 大纲规划 + ag_006 冲突设计  (parallel)
|Stage 5:  ag_007 正文主笔  (single)
|Stage 6:  ag_011 玩梗 + ag_012 搞笑 + ag_013 热点  (parallel, optional)
|Stage 7:  ag_008 审核校准  (single; can reject → back to Stage 5)
|Stage 8:  ag_009 文笔优化 + ag_010 标题钩子  (parallel)
|Stage 9:  ag_013b 合规审计  (single; platform-compliance-2026 逐条过检)
| Stage 10: ag_014 短剧转换  (single; 网文→△格式剧本)
```

### How to trigger

**New book flow**: `"启动 13-Agent 网文工厂，赛道：<genre>"`
**Iteration round**: `"draft-5 with 13-agent enhancement"`

Each agent gets injected with the relevant `references/*.md` file(s) as context via `delegate_task(context=...)`. Context flows: parent merges child JSON outputs → passes to next stage as structured context package.

|- `trend-scan`: Load `references/platform-patterns.md` and `references/platform-compliance-2026.md`. Use when the user asks what is hot, what sells, what readers want, or what to avoid. The compliance guide is essential for assessing platform risk of each genre (S/A/B/C tier filtering). If the user asks for latest or current trends, browse and cite sources; otherwise state that built-in platform patterns are being used.
|- `idea-pool`: Before generating, check memory for an existing "Selected premise" record. If found, flag it to the user ("你之前选的是 XXX，已包含在候选中") so they don't start over by accident. Then load `references/platform-patterns.md`, `references/idea-scoring.md`, and `references/platform-compliance-2026.md`. Generate 20 premise candidates. Apply S/A/B/C tier filtering from compliance guide — candidates prohibited or high-risk must be flagged explicitly. Stop for Manual Checkpoint A.
|- `bible`: Load `references/story-bible-template.md`, plus `references/idea-scoring.md` if the selected premise still feels generic. Load `references/manga-hit-guide-2026.md` if the premise needs golden-finger legal-packaging advice.
|- `outline-30`: Load `references/outline-structure.md` and `references/manga-hit-guide-2026.md`. Create the front-30-chapter structure with legally packaged payoff sequencing. Stop for Manual Checkpoint B before drafting.
|- `full-novel-lifecycle`: See `references/full-novel-lifecycle.md` — observed 80-chapter pipeline pattern (five-volume structure, emotional curve design, auto-pilot performance).
|- `trial-10`: Load `references/outline-structure.md` and create a detailed first-10-chapter trial-read plan.
|- `draft-5`: Load `references/chapter-template.md`, `references/memory-system.md`, `references/platform-compliance-2026.md`, and the latest context package. Write 5 chapters, not more, unless the user explicitly asks for fewer. Chapter word count depends on active mode: Full mode ≥1000 characters, 漫剧适配版 600-800 characters, Lightweight ~2000 cumulative. Before outputting, check each chapter against the 6 zero-tolerance red lines in the compliance guide.
|- `compress`: Load `references/memory-system.md` and create the next-round context package.
|- `diagnose`: Load `references/diagnose-loop.md` and produce reader feedback simulation, failure checks, and three branch choices. Stop for Manual Checkpoint C.
| `compliance-audit`: ✅ **本profile完整保留**。全套合规审计+灰区扫描+重写建议直接使用。查看 `references/platform-compliance-2026.md`。

  **审计方法论（来自2026.05.18规则更新后的实践）：**

  1. **先检查现有审计报告的日期。** 如果现有 `99-合规自检报告.md` 的版本日期早于 `platform-compliance-2026.md` 的最新版本日期，必须标记"规则更新后重新审计"。
  2. **正文 vs 大纲分开检查。** 实践中发现：**大纲（`01_前80章大纲（完整）.md`）文件中的措辞往往比正文更 sensational**——大纲用简写/噱头式表述（如"天赋升级""终极形态"），而正文实际描写更温和（如"药膳蒸汽""天赋无效"）。审计时必须查阅正文原文验证，不能只依赖大纲判断。
  3. **△剧本的合规度天然更高。** 由于△剧本是视觉/动作驱动的场景化写作，很少出现超能力式抽象表述，通常比对应的正文章节更安全。
  4. **隐性红线修复策略：** 遇"爽点碾压"类问题时，优先改措辞不改剧情——将"突然获得超能力"改写为"通过长期练习/传承学习获得的技艺突破"，剧情框架不动。
  5. **审计完成后更新 `99-合规自检报告.md`** 中的状态和整改记录，确保下一次审计能直接看到本次改动。
| `drama-adapt`: ✅ **本profile完整保留**。参考文件 `references/drama-adaptation.md`，在本profile内直接执行即可输出△格式剧本。

  **续写已存在项目的工作流（非首次适配）：**
  1. 先读取项目下所有已有文件：`01-题材定位.md`、`02-角色资产表.md`、`03-场景资产表.md`、`04-全集大纲.md`、`05-付费卡点布局.md`、`99-合规自检报告.md`
  2. 读取最近一集的 △ 剧本文件，确认格式细节（语气标记、OS/独白风格、△描述颗粒度）
  3. 读取对应的小说章节原文作为素材
  4. 严格保持格式一致：新写剧本的 △ 标记、对话格式、OS 风格必须与已有剧本逐字对齐
| `prompt-gen`: ✅ **本profile完整保留**。源skill模板见 `references/matsuri-director-prompt.md`，在本profile内直接执行即可输出分镜提示词。
|- `humanize`: Load `references/rewrite-humanization.md`.
  **Pipeline sequencing（本profile独立运行）:**
  - ✅ 本profile内 **写小说 → 转剧本 → 分镜提示词** 全链路直接可用
  - ✅ 三步流水线：`compliance-audit` → `drama-adapt` → `prompt-gen`

  **Output folder structure for drama-adapt (+ prompt-gen):**
  ```
  <project-folder>/短剧版/
  ├── 01-题材定位.md          # S/A/B/C分级 + 受众 + 付费策略
  ├── 02-角色资产表.md        # 角色编号C01-C99 + 外貌/性格标签 (prompt-gen读取)
  ├── 03-场景资产表.md        # 场景编号S01-S99 + 风格关键词 (prompt-gen读取)
  ├── 04-全集大纲.md          # 60-100集 × 三幕结构表
  ├── 99-合规自检报告.md      # 红线 + 灰区扫描（可选）
  ├── episodes/               # △格式文字剧本（drama-adapt产出）
  │   ├── ep001.md
  │   ├── ep002.md
  │   └── ...
  └── 98-视频分镜提示词/       # 分镜提示词（prompt-gen产出，按段/镜头拆分）
      ├── ep001-提示词.md
      └── ...
  ```

  **单集△格式模板：**
  ```markdown
  # ep{编号} - {标题}
  
  **时长**：{X分X秒}
  ---
  △（场景/镜头描述）
  
  **角色名**（语气）："对白"
  
  △（转场）
  
  OS：角色内心独白
  
  △（近景·表情细节）
  
  【本集完】
  ```
|- `humanize`: Load `references/rewrite-humanization.md`. Rewrite prose to remove AI texture while preserving plot facts.

## Auto-Pilot Mode（用户明确要求自动执行时激活）

当用户说"自动执行"、"你帮我选"、"你帮我检查和选择"或表达类似意图时，进入 auto-pilot 模式。

**⚠️ 关键确认：** 一次会话中的"帮我选"授权只对当轮有效。每次进入新一轮 draft-5 前，如果用户没有再次确认 auto-pilot，应该询问"继续自动推进还是停下来看看？"而不是假设用户仍然希望自动执行。

**行为变更：**
1. **跳过 Manual Checkpoint C 的等待** — 不再列出三条分支等待用户选择，而是直接选出最优分支并执行
2. **分支选择优先级**（同下方 Branch Recommendation Pattern）：
   - 优先选 🅰 安全分支（保持原大纲节奏）
   - 仅在连续4+章压抑或连续2+章同类型冲突时选 🅱 热分支
   - 仅在用户明确要求"颠"或当前弧线过于普通时选 🅲 怪分支
3. **每轮输出精简**：省略"三条分支选择"的完整呈现，直接在诊断后说"诊断完成。自动推进→第X章：[内容概要]"，然后直接写正文
4. **每5章一轮的节奏不变** — 仍然每5章写一个文件、每5章做一次诊断，只是不再在诊断后停下等待
5. **📁 自动保存文件** — 在 auto-pilot 模式下，每轮 draft-5 完成后直接写入磁盘，不再询问用户"要保存吗"。文件路径遵循项目已有的文件夹结构。
6. **🔗 流水线自动衔接** — 当前阶段完成后自动判断下一步：
   - draft-5 写完 → 自动跑 diagnose
   - diagnose 完成 → 自动选分支 → 继续写下一轮
   - 前30章大纲用完 → 自动扩展大纲 → 继续写
   - 全本写完 → 询问用户是否需要 compliance-audit + drama-adapt
7. **🧩 进度可视化** — 每轮写完时附一个文件树进度表，让用户一目了然：

   ```
   ├── 02_正文_第1-5章.md     ✅
   ├── 02_正文_第6-10章.md    ✅  ← 当前进度
   └── ...
   ```

**退出条件：** 用户说"停一下"、"等等"、"让我看看"、"先别写了"时立即退出 auto-pilot，恢复手动模式。此后必须等待用户明确指示才能重新进入 auto-pilot。

**适用场景：** 用户明确表达信任代理判断、希望减少决策负担时。不要自行猜测用户意图——必须用户亲口说"你帮我选"、"自动执行"或"你帮我检查和选择"才启用。

### Pitfalls

- ❌ 不要在没有用户明确授权的情况下自行进入 auto-pilot 模式。即使之前的回复说过"帮我选"，也只对当轮有效——每轮开始前需要确认是否继续自动。
- ❌ Auto-pilot 模式不等于一次性写全本。仍然每5章一轮、每轮写完做一个诊断检查。
- ❌ 用户说"帮我选"后，必须给出选择理由，不能只说"选A"不解释。
- ❌ 当 auto-pilot 模式下遇到大纲用完时，自动扩展大纲后继续写，不要在扩展大纲后停下等待确认——除非用户手动退出 auto-pilot。
- ❌ 不要跳过初期的 Manual Checkpoint A 和 B。只有 Checkpoint C 可以在 auto-pilot 模式下自动执行。
- ❌ **不要混淆△剧本转换和视频/分镜提示词生成。** `drama-adapt` 仅输出△格式的文字剧本（含对白/OS/镜头描述），不生成任何 AI 视频提示词。视频分镜提示词用 `prompt-gen` 命令（来源：mantoufan/seedance-prompts-skill 蒸馏）。不要在 `drama-adapt` 命令中混入视频提示词输出。
- ❌ **不要在输出文件和项目文件中使用 \"Seedance\" / \"Seedance 2.0\" / \"即梦\" 相关名称。** 用户明确禁止。提示词文件目录用 `98-视频分镜提示词/`，文件名用 `ep{NNN}-提示词.md`。SKILL.md 内部命令名用 `prompt-gen`，不用 `seedance-*`。

## Manual Checkpoints

| 检查点 | 触发时机 | 正常模式 | Auto-Pilot 模式 |
|--------|---------|---------|----------------|
| ✅ A | `idea-pool` 后 | 用户从20个选1个 | 用户从20个选1个（不可跳过） |
| ✅ B | `bible`/`outline-30`/`trial-10` 后 | 用户确认骨架 | 用户确认骨架（不可跳过） |
| ⚠️ C | 每轮 `draft-5` + `diagnose` 后 | 用户从三条分支选一个 | **代理自动选最优分支并执行** |

## Core Constraints

### 女频 Adaptation

When the user asks to convert a premise to 女频 (female-lead):

- **Female protagonist's starting wound** should be relational/social (abandoned, humiliated, disrespected) not just power-based.
- **Paired CP design**: give the male lead a complementary ability/secret that only she can unlock. Create a "two halves of one whole" dynamic.
- **Emotional hook**: "全世界都不信你/懂你，只有我信" is the strongest 女频 emotional engine.
- **Female lead's growth**: should be through her OWN talent/effort, not just proximity to the male lead. Give her an independent skill (e.g.味觉天赋, 商业头脑, 洞察力).
- **Romance pacing**: slow-burn, natural progression (suspicion → trust → dependence → mutual growth), not instant attraction.
- **Power system gendering**: avoid male-gaze framing. Female lead's victories should be through intelligence, resilience, or unique talent — not just "fighting like a man."
- **Compliance**: 女频 stories are subject to the same 2026 hidden red lines (no 身份反转爽点, no 情感操控), but 纯爱甜宠 + 事业成长 is A-level safe.

### 漫剧适配版 Writing Rules

When operating in 漫剧适配版 mode, apply these additional constraints:

- **Each chapter = one scene.** No scene breaks within a chapter. One location, one continuous timeframe.
- **Open with a visual action**, not exposition. First sentence must be something a camera can see.
- **Dialogue drives the scene.** 60%+ of chapter content should be dialogue or action, <40% narration.
- **No internal monologue paragraphs.** If the character has a thought, express it as dialogue, facial reaction, or action choice.
- **Every chapter must have a "midpoint reversal"** — something happens ~halfway through that changes the scene's direction.
- **End every chapter on a concrete hook:** a question asked, a door opened, a secret revealed, a threat appearing. Not a vague feeling.
- **600-800字 per chapter** — tight. No fat sentences. Every line either advances the scene or reveals character.
- **Payoff every 2-3 chapters**: a visible win, a secret revealed, a power up, or a relationship milestone. The漫剧 audience needs faster reward cycles than novel readers.

### "颠" Rules

- Define the world's absurd foundation.
- Give the protagonist a misread of reality that others do not share.
- Give major antagonists a personal obsession, not only stupidity.
- Make upgrades stranger, not only stronger.
- Make shocks surprising but explainable in hindsight.

Retention requirements:

- Start each chapter with pressure or conflict within the first 300 Chinese characters.
- Give the protagonist at least one active choice per chapter.
- Deliver at least one payoff per chapter.
- End each chapter with a concrete unresolved threat, secret, reward, or decision.
- Track repeated face-slapping, reversal, and humiliation patterns so the next round mutates them.

Prose requirements:

- Prefer scene action over explanation.
- Prefer short, sharp dialogue over summary.
- Let the protagonist be selfish, stubborn, paranoid, or willing to make dirty choices when the premise supports it.
- Avoid preaching, forced moral elevation, forced full closure, and generic inspirational endings.

Safety and originality:

- Do not imitate a named living author or specific copyrighted book.
- Do not directly rewrite or continue a copyrighted story unless the user owns it or provides original material.
- Avoid explicit sexual content, sexual content involving minors, real-world targeted abuse, real political incitement, or graphic gore beyond platform-style action.
- If a request asks for "latest trends" or current platform rankings, verify with browsing rather than inventing current data.

## Standard Round Output

For a 5-chapter production round, output:

1. Round target.
2. Five chapter texts. Word count per chapter depends on mode:
   - 🔵 Full mode: ≥1000 Chinese characters each
   - 🎬 漫剧适配版: 600-800 Chinese characters each
   - 🟢 Lightweight: ~2000 cumulative characters across all 5 chapters
3. One-line payoff note for each chapter.
4. New hooks.
5. Hooks paid off.
6. Active ledger update.
7. Cold storage update.
8. Reader-retention diagnosis.
9. Three next-branch choices.

If the user asks for final polish, add a separate humanized final version after the diagnostic pass.

## Reference Update Rules（用户补充审核/创作规范时的操作铁律）

当用户提供新的审核规范/创作指南/参考文件要求整合时，必须遵守以下流程：

### 原则一：整体创作流程不变

> **这是本技能的最高执行原则。** 用户多次强调"整体创作流程不变"。

更新 reference 文件时：
- ✅ 可修改 reference 正文内容（扩展表格、补充细则、新增章节）
- ❌ **绝不修改 SKILL.md 中的 pipeline 命令结构和执行流程**
- ❌ 绝不新增/删除/重命名现有命令
- ❌ 绝不改变 Manual Checkpoint 的触发位置和类型
- ❌ 绝不改变输出格式决策的流程
- ❌ 绝不改变 draft-5 → diagnose → branch 的迭代节奏

更新步骤：
1. **对比** — 读取现有 reference + 用户提供的新文件，逐项对比差异
2. **预览** — 展示新增内容和保留内容，让用户看到改了哪里
3. **确认** — 用 clarify 询问用户"确认写入？"
4. **写入** — 仅更新 reference 文件，不碰 SKILL.md

### 原则二：参考文件更新流程

```mermaid
flowchart LR
    A[读取现有reference] --> B[读取用户提供的源文件]
    B --> C[逐项对比: 已有/缺失/冲突]
    C --> D[输出差异预览]
    D --> E{用户确认?}
    E -->|否| X[停止,不写]
    E -->|是| F[写入reference文件]
    F --> G[确认SKILL.md不动]
```

### 原则三："算了不改了" 立即终止

当用户说 "算了不改了"、"算了"、"不动"、"先别弄了" 或类似意思时：
- 立即终止当前备选行动，不做任何额外解释
- 不追问 "真的不弄了吗？"
- 不主动再次提起该任务

## File Output & Persistence

When saving generated content to disk:

**Never use `execute_code` for file operations.** Always use `write_file` directly — one file per call. The user may block automated scripts that batch-create files, and individual write_file calls are clearer, auditable, and let the user see every file being created.

**Save only after explicit user instruction or confirmation.** Never autosave without asking first, except for final deliverables the user explicitly requested. Follow the "需要存的才存" principle: if the user didn't say "保存" or "存", don't save.

**Exception: Auto-Pilot mode.** When operating in auto-pilot mode (用户说"自动执行"、"你帮我选"等), files ARE auto-saved after each draft-5 round without asking. The agent still uses `write_file` directly (one file per call), but doesn't pause to ask "should I save this?".

**Create only what's needed now:**
- At `idea-pool` stage: save only the master document (e.g. `00_选题池(20个候选).md`). Do NOT pre-create folders for all 20 candidates.
- At `bible` stage: once the user selects a premise, create that single folder with its bible document.
- At `draft-5` stage: store chapters inside the novel's existing folder.
- Don't batch-generate folders, skeletons, or placeholder files for candidates the user hasn't selected yet.

**Output structure convention** (arranged after stage confirmation, not before):
```
<base-dir>/
  00_选题池(20个候选).md          ← idea-pool stage only
  <selected-novel-name>/
    00_故事圣经.md                  ← bible stage
    01_前30章大纲.md                 ← outline-30 stage (use 01_前80章大纲(完整).md if expanded)
    02_正文_第1-5章.md              ← draft-5 rounds (one file per 5-chapter batch)
    02_正文_第6-10章.md
    02_正文_第11-15章.md
    ...                             ← numbering pattern: 02_正文_第N-M章.md
```

Respect the user's own directory choice if they specify one (e.g. Obsidian vault paths like `E:\ObsidianSource\03_AI漫剧\`). Base directory is user-provided, not hardcoded.
