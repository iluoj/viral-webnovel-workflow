---
name: viral-webnovel
description: "短剧+网文生产流水线：趋势分析→选题→圣经→大纲→直出△短剧脚本→合规审计→分镜提示词→全局复盘。支持6-profile Kanban团队协作模式(v2.1)。"
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

格式决策发生在 `trial-10` 之后、第一次 `draft-5` 之前，必须向用户提问。具体选项（**必须包含字数和总量信息**）：

1. **📖 网文小说版**（默认）
   - 1500-2000字/章，50章总量约 **8-10万字**
   - 有心理描写和叙述铺陈
   - 后续通过 `drama-adapt` 命令转为△格式漫剧剧本
   - 适合先发番茄/七猫，再转短剧

2. **🎬 漫剧脚本版**
   - 600-800字/章，50集总量约 **3-4万字**
   - 场景化写作（对话+动作驱动，无心理描写）
   - 直接产出可进制作流程的脚本
   - 适合直接做漫剧，不发网文平台

3. **📖→🎬 网文先写，后续转剧本**
   - 先按网文版写（1500-2000字/章），完本后用 `drama-adapt` 转为漫剧脚本版（600-800字/集）
   - 双份产出，总量约 **12-14万字**（小说+剧本）
   - 适合双平台运营：小说发平台赚稿费，剧本做漫剧赚流量

**如果不问清楚就默认选1（网文小说版），写完整本，然后由 `drama-adapt` 负责转换。**

**字数透明铁律（用户明确要求）：**
- 每次向用户展示格式选项时，必须包含每章字数和总字数/总量
- 格式如：`1500-2000字/章，50章≈8-10万字`
- 不要只说"600-800字"而不提总量——用户需要知道完整项目的规模
- 如果用户说"字数是多少"或类似疑问，说明输出中字数和总量信息缺失，立即补全

## Content Generation Principle（2026-06-25 用户明确规则）

**所有小说正文、△剧本、分镜提示词的内容，必须由模型逐段/逐章/逐集生成，严禁使用脚本（execute_code 或任何自动化代码）批量写入内容。**

| 允许脚本做的 | 禁止脚本做的 |
|:------------|:------------|
| 创建目录结构 | 生成任何汉字/标点的正文 |
| 删除旧版本文件 | 填空模板式的批量内容 |
| 统计字数/文件数 | 拼接格式化文本 |
| 检查文件存在性 | 用 Python 循环写 N 个文件的内容 |
| 移动/重命名/复制文件 | 任何涉及"内容"的一行产出 |

**执行规则**：每次调用 `draft-5`、`drama-adapt`、`prompt-gen` 时，自动检查是否由模型直接生成内容。如果用 execute_code 做内容写入，属于违规。

**例外**：planning 类产出（idea-pool列表、bible提纲、大纲骨架）的第一版可以通过脚本枚举候选结构，但正文也仍然需要模型逐个展开。违规生成的产出标「🚫脚本内容」并废弃重做。

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

### Pitfalls（idea-pool 相关）

- ❌ **不要生成同一等级扎堆的选题池。** 现有规则要求至少覆盖3个等级(至少3 of S/A/B/C)，同一等级≤12个。如果第一批按古风优先自然聚集在A级，必须在第一批中就主动补入S/B/C级选项——不要等用户说"怎么都是a级的"再补第二批。意识越早越好：生成时就应该横向拉通各等级分布。
- ❌ **不要用文件代替对话展示。** 选题池生成后优先在对话中列出给用户看，文件保存是次要操作。用户需要先在屏幕上看到内容。

### Pitfalls（格式相关）

- ❌ **不要用户提到"漫剧"或"短剧"就直接切到漫剧版写600字章节。** 很多用户的意思是"先写小说，以后转漫剧"，不是"直接写漫剧脚本"。必须先确认。
- ❌ **不要在同一轮 draft-5 中混淆两种格式。** 要么全按网文版写，要么全按漫剧版写。不能前两章1500字、后三章600字。
- ❌ 当用户说字数会不会太多时，不要自行切换到漫剧版。先问清楚：你是想缩减字数改为漫剧脚本，还是保持网文格式但减少总章数？

### Pitfalls（bible / 创意融合 相关）

- ❌ **不要在用户说"能不能也结合一下X"时拒绝或防御原有方案。** 创意融合（将多个成功作品的核心元素杂交）是比1:1对标更高级的创作方式。用户提到另一个作品时，立刻用"是，可以融合"回应，然后把两个框架放在一起找碰撞点。
- ❌ **不要在第一轮就出最终方案。** 创意迭代至少需要3轮：第一轮出几个方向→用户选1-2个→第二轮融合用户提到的其他元素→第三轮精确定位。第一轮就锁定的方案往往不是最好的。
- ✅ **当用户说"我觉得后两个都不错"时，主动提出融合版。** 不要等用户自己说怎么融合。用"是，可以融合"开场，给出融合方案。
- ❌ **不要在用户要求1:1对标时主动添加未经验证的叙事模式。** 当用户明确说"一定要一致"、"对标原版"时，对标方案中绝不能加入原版没有的叙事元素（如男主死亡、深V反转、兽族设定等）。如果用户说"能不能结合X"，先问清楚是把X作为对标模板的补充，还是要替换对标模板。不要在未确认的情况下自作主张做"升级版"。

### Pitfalls（model recommendation 相关）

本 session 中出现的 3 次用户纠正表明，模型推荐是高频犯错点。**每次进行模型推荐前必须通读以下规则：**

- ❌ **不要在用户提到某个模型版本时凭记忆否定。** 模型版本迭代极快，用户可能比你的训练数据更了解当前情况。如果用户说"怎么可能没有，X模型是有的"，立即去官网验证（Google DeepMind / OpenAI / Anthropic / DeepSeek docs），而非坚持"X模型不存在"。验证后如果是自己信息滞后，直接承认并修正。
- ❌ **当用户说"感觉你对目前主流模型不是很熟悉"时，不要继续按旧知识推荐。** 主动去各厂商官网刷新模型列表，更新认知后再给建议。
- ❌ **不要用单一硬件指标（如 context 大小）作为排他性推荐理由。** 多个厂商的旗舰模型在硬件指标上往往对齐——context 大小、多模态支持等不是差异点。真正的差异在推理质量、创意写作、格式遵循等软能力上。推荐前先做能力维度对比表，而不是拿一个所有人都有的指标当卖点。
- ✅ **推荐模型时，明确标注「这个结论基于官方Pricing页的日期 X」或「这是我自己的经验判断」**，让用户判断信息时效性。

### Pitfalls（prompt-gen 相关）

- ❌ **严禁用 execute_code 或任何脚本批量生成提示词。** 内容由模型逐段思考后用 write_file 逐个写入。脚本只能做创建目录、检查文件存在等纯辅助操作，不能生成提示词的任何一个字。脚本批量生成导致：(1) 格式走样，(2) 运镜选择模板化无叙事针对性，(3) 用户一眼看出是模板文本而非模型生成。
- ❌ **不要在提示词文件中写入「画风」单独行。** 画风信息融入场景设计的材质/光影描述中，不作为 `画风：` 行出现在文件头部。
- ❌ **配音指令格式严格按麻薯模板，不得自创格式。** 正确：`【角色名】（配音指令：[性别年龄]，[音色类型]｜[语气情绪]，"[台词]"）`。错误：`角色名（语气）："台词"`。
- ❌ **段数严格按时长换算，不可自由分配。** 每集段数 = ceil(总秒数 / 15)。例：2分15秒=135秒→9段。每段含3-5个切片段（通常4个），保持每段约15秒。
- ❌ **写每个文件前打开 reference 对照格式。** 麻薯格式的每一行（总述头部、|切片段、运镜补充、配音指令）用 matsuri-director-prompt.md 逐行对照。**第一个文件让用户确认格式后再继续。**
- ❌ 不要在询问画风之前就生成任何分镜提示词。
- ❌ 每段的运镜不能全部是模板化的「中景/平拍，稳定镜头，速度平缓」。必须从 camera-shot-selection.md 的叙事目的→运镜决策表中选择。每段内4-5个切片段至少要有2次以上景别变化。
- ❌ 不要在一个文件中塞入多个段。一个文件只对应一个段。
- ❌ 全量交付（方案A）时不要一个人写几百个文件。用 delegate_task 分包，每5-10集一个子代理，分配独占的 P## 编号区间。
- ⚠️ **prompt-gen 前置三步**：(1) 用 clarify 问画风，(2) 画风融入场景设计，(3) 告知文件总量。

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
| `drama-adapt` | **viral-webnovel** | △格式短剧剧本转换。参考文件 `references/drama-adaptation.md`。**每集时长要求：2分00秒-2分30秒，硬上限3分钟。** 超出3分钟的集必须压缩。全部集输出后必须检查 `*时长*` 头部标注与实际内容量匹配。如果内容压缩导致集数减少，必须物理删除旧的episode文件。
| `prompt-gen` | **viral-webnovel** | 视频分镜提示词生成。默认输出格式：麻薯动漫导演格式（\\|切片段 + 运镜六要素 + 配音指令），见 `references/matsuri-director-prompt.md`。运镜规则见 `references/camera-shot-selection.md`（叙事目的→运镜决策表必需引用）。**⚠️ 方法铁律：prompt-gen 必须由模型逐段思考并直接用 write_file 写入，不得用 execute_code/脚本批量生成。**\n  **前置步骤（必须在生成第一个文件前执行）：**\n  (1) 用 clarify 询问画风（提供具体选项）。\n  (2) 用户选择画风后，画风信息融入场景设计和画面描述中，不作为单独「画风」行出现。\n  (3) 确认文件格式偏好（一段一文件含4-5切片段，每15秒一段）。\n  (4) 告知约略文件总量。\n  **段数规则：** 每集段数 = ceil(总秒数 ÷ 15)。例：2分15秒=135秒→9段。每段含3-5个切片段（通常4个），每个切片段约3-4秒。\n  **配音指令格式（严格遵循，不得自创）：**\n  ```\n  【角色名】\n  （配音指令：[性别年龄]，[音色类型]｜[语气情绪]，"[台词]"）\n  ```\n  **输出文件结构：** 每段一个文件，命名 `{ep编号}-段{NNN}-提示词.md`，每文件含总述头部 + 4-5个\\|切片段。
| `compliance-audit` | **viral-webnovel** | 2026平台合规逐条过检 + 爆款潜力评估。输出包含八部分：1-6合规检查 + 7流量适配建议 + 8爆款潜力评估。见 `references/platform-compliance-2026.md` 和 `references/compliance-audit-template.md`。**审计前预检：确认集数一致性。** 读取 `04-全集大纲.md` 确认剧本总集数，检查 `episodes/` 目录下的文件是否覆盖全部集数且无旧版残余。审计报告声明集数必须与实际文件一致。

### 新建 profile 的步骤

当用户要求创建独立 profile 时：

1. 创建 profile：`hermes profile create <名称>`（支持 `--clone` 从现有 profile 复制）
2. 在新 profile 的 `skills/` 下创建 skill 目录（名称建议 `<profile同名>`）
3. 编写 SKILL.md：只包含该 profile 对应的命令定义
4. 复制参考文件：将 drama-adaptation.md、mantoufan-prompt-source.md、platform-compliance-2026.md 从 viral-webnovel 复制到新 profile 的 `skills/<name>/references/`
5. 配置：新 profile 可复用原 config 或单独配置模型/工具集

**⚠️ 跨 profile 写保护：** 当前 session 运行在 viral-webnovel profile 下，新建 profile 后写入新 profile 的 skills/plugins/cron/memories 必须添加 `cross_profile=True` 参数。

### Profile 间数据流向

**跨 profile 技能比较流程（当用户问"看看另一个profile有什么技能"时）：**
1. 用 `hermes skills list --profile <目标profile>` 列出目标 profile 的所有已启用技能
2. 用 `hermes skills list --profile <当前profile>` 列出当前 profile 的所有已启用技能
3. 对比两个列表找出差异：只在目标 profile 中存在的技能
4. 如果差异只是 provider/管理类技能（如 `add-multi-key-provider`、`cline-provider`、`hermes-provider-management` 等），说明用户记忆中的"浏览器/搜索能力"差异是 provider 本身的能力差异，不是 skill 差异
5. 报告差异时按"只存在于目标profile"和"只存在于当前profile"分类列出，并说明每个技能的作用

```
viral-webnovel profile（对话入口 = 实际的总控）+ 看板调度
  ┌──────────────┐
  │ viral-       │ ← 你在此对话，创建Kanban任务
  │ webnovel     │
  └──────┬───────┘
         ↓ 看板任务分发
  ┌──────────────┐
  │ planner      │ → 选题/圣经/大纲
  └──────┬───────┘
         ↓

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

### 外部项目蒸馏

| 项目 | 参考文件 |
|:-----|:---------|
| 火宝短剧 / Seedance2-Storyboard | `references/distilled-projects.md` |

详见 `references/distilled-projects.md`。

## Portable Distribution (OMO Style)

This skill's writing capabilities can be exported as platform-agnostic agent prompt files, usable with any LLM tool (Codex, Claude Code, ChatGPT, DeepSeek, Cursor, etc.) — following the OMO pattern (cf. oh-my-zsh, oh-my-claude).

### Why

- **Portability:** each agent is a standalone `.md` file, feedable via stdin or copy-paste to any tool
- **Stability:** git-versioned with semantic tags (`v1.0`, `v2.0`); no silent changes during conversations
- **Backup + Share:** one `git push` backs up the entire pipeline; clone to give to others

### Export Mapping

| agent file | source profile | what it contains |
|---|---|---|
| `01-idea-pool.md` | planner | 20-premise generation + scoring criteria |
| `02-bible.md` | planner | world-building + story bible prompt |
| `03-outliner.md` | planner | 30-chapter outline + structure rules |
| `04-writer.md` | writer（已退役） | chapter writing + chapter template |
| `05-diagnoser.md` | writer/reviewer | retention diagnosis + 3-branch recommendation |
| `06-compliance.md` | auditor | 6 red lines + S/A/B/C tier audit |
| `07-drama-adapter.md` | adapter（已退役） | △-format short drama conversion |
| `08-prompt-engineer.md` | prompter | 麻薯动漫导演分镜提示词 |
| `09-scriptwriter.md` | scriptwriter（推荐） | 直出△短剧脚本（替代writer+adapter） |

Each agent file is a pure system prompt: role definition, input spec, output format template (verbatim from this skill's reference files), and known pitfalls. No Hermes-specific syntax.

### Stability Convention

1. After first export: `git init && git add . && git commit -m "v1.0" && git tag v1.0`
2. Updates only on explicit user request ("封版" / "更新到v2.0")
3. Changes visible via `git diff v1.0..v2.0` — user reviews before accepting
4. After tagging, no automatic skill modifications during conversations. The user decides when to unfreeze.
5. **Workflow repo location**: `E:\viral-webnovel-workflow\` — viral-webnovel skill pipeline (SKILL.md + references/) lives here as a git repo. Push to GitHub needs a PAT token (password auth is deprecated).

### Usage Examples

```bash
# Write 5 chapters with Codex (旧流程，仅限有小说需求时)
cat 04-writer.md | codex -p "写第6-10章，主角苏棠在厨房试菜"

# 直接出短剧剧本（推荐 — 新流程，不经过小说）
cat 09-scriptwriter.md | codex -p "从圣经写我家狗子会开冰箱 ep004-ep006 的△剧本"

# Compliance audit with Claude Code
cat 06-compliance.md | claude -p "审计 短剧版/episodes/"

# Full pipeline with any tool
cat 03-outliner.md 09-scriptwriter.md | llm -p "为新故事写大纲+前3集△剧本"
```

### Template File

See `references/omo-agent-template.md` for a complete agent `.md` example.

## Operating Rule

Push the work through controllable stages:

1. **Kanban first** — 进入创作流程时，立即 `hermes kanban init` 创建看板，将任务分解为 Kanban 卡片分配给各 profile 认领。不要从头到尾在一个对话中完成所有产出。6-profile 架构见 `references/hermes-kanban-architecture.md`。
2. Find or invent stronger premises.
3. Ask the user to choose one premise before expanding it.
4. Build the story bible and opening structure.
5. Ask the user to confirm the skeleton before drafting.
6. Draft only 5 chapters per round.
7. Compress memory, diagnose retention, and offer branches after each round.
8. Ask the user to choose the next branch before continuing.
9. Run humanization as a separate pass when prose quality matters.

Do not attempt to write a full 80-120 chapter novel in one response. If the user asks for a full book, create the bible, front-30 outline, front-10 trial plan, and first 5-chapter round, then prepare the next-round context package.

## Advanced Mode: 13-Agent Parallel Orchestration

For teams or power users, the single-agent pipeline can be upgraded to a parallel 13-agent factory using Hermes `delegate_task`. See `references/13agent-workflow/` for the full design doc.

## Multi-Profile Team Mode（6-Profile 架构，v2.1）

> ✅ 已落地（2026-06-25），当前为 v2.1（2026-06-26 更新）

当用户需要规则隔离、记忆不污染的多 agent 协作时，使用 6-profile Kanban 架构。详见 `references/hermes-kanban-architecture.md`。

### 核心变化（v1→v2.1）

- **删除了 writer（写小说）和 adapter（转短剧）** — 不再经过小说中间层
- **新增 scriptwriter（直出△短剧脚本）** — 从大纲直接产出35集△格式剧本
- **流水线从6阶段缩短为5阶段**：planner → scriptwriter → auditor → prompter → reviewer
- **流程更加直接**：前15秒钩子 → 对话驱动 → 合规在前 → 分镜在后

| profile | 角色 | reference 数 |
| `viral-webnovel` | 主控（对话入口=实际lead） | 有 |
| `webnovel-planner` | 规划师 | 4 |
| `webnovel-scriptwriter` | 短剧编剧（直出△剧本） | 2 |
| `webnovel-auditor` | 合规审计 | 2 |
| `webnovel-prompter` | 分镜提示词 | 3 |
| `webnovel-reviewer` | 全局复盘 | 1 |

### 多 Profile 模型分配策略

不同任务对模型的要求不同。完整能力矩阵见 `references/model-capability-matrix.md`。简表：创意层（剧本/大纲/分镜）用 Gemini 3.1 Pro，品质层（小说正文）用 deepseek-v4-pro 或 GPT-5.5，分析层（趋势/选题）用 deepseek-v4-pro，执行层（合规/诊断）用 deepseek-v4-flash。自定义 provider 配置流程见 `references/custom-provider-setup.md`。

### 直出短剧原则（2026-06-26 用户确认的流程变更）

当前所有新项目都走「直接出短剧」路线，不再写小说再转。理由：
1. 小说和短剧的审核规则不同（小说能写的爽点/反转，短剧可能踩红线）
2. 小说的铺垫在转短剧时全部要砍掉，等于做两遍工
3. 短剧要求前15秒钩子、对话驱动——这些要在创作阶段就内嵌，不是转换阶段补的

### 蒸馏的外部项目（2026-06-26 吸纳）

| 项目 | 作者 | 吸收的内容 |
|:-----|:-----|:-----------|
| [火宝短剧](https://github.com/chatfire-AI/huobao-drama) | chatfire-AI | 剧本格式（场景头）、改写原则（对话驱动/每场30-60秒）、5 Agent 分工 |
| [Seedance2-Storyboard](https://github.com/liangdabiao/Seedance2-Storyboard-Generator) | liangdabiao | 不经过小说直接出剧本、四幕结构（起承转合）、素材编号系统 C/S/P |

详见 `E:\viral-webnovel-workflow\蒸馏记录.md` 和 GitHub v2.1 tag。

**使用方式**：在 viral-webnovel 中「启动流水线」触发 Kanban 任务创建。

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

  **⚠️ `platform-patterns.md` contains pre-2026 patterns that may now be illegal.** Always cross-reference with `platform-compliance-2026.md` before recommending any payoff pattern, title hook, or protagonist behavior. The compliance guide's hidden red lines take precedence over old platform instincts.

  **⚠️ 趋势数据来源混淆陷阱：** `platform-compliance-2026.md` 中的流量预测（如"S级保底100万"、"A级可达1000万"）是**审核等级对应的理论流量上限**，不是当前市场的实时数据。不要在未标注来源的情况下把等级流量预测当作"趋势"呈现。如果搜不到实时排行数据，用内置参考时必须在结论中明确标注"基于2026平台审核分级，非实时排名数据"。

  **趋势扫描输出规范（来源透明化铁律）：**

  趋势扫描输出必须包含一个明确的「数据来源面板」，让用户一眼看清每条结论的来源：

  ```
  📊 数据来源
  ├── 🏗️ 内置模式库     → 平台分级、审核规则、通用创作模式
  └── 🔍 实时搜索结果   → 具体作品名、排行数据、当前热点  ← 附来源链接
  ```

  - ✅ 内建数据：标注"基于2026审核标准""参考平台模式库"等来源标签
  - ✅ 实时数据：标注具体来源（Bing搜索结果/番茄排行榜/知乎等），如果来自 AI 摘要（如 Bing Copilot），必须注明"由搜索引擎 AI 摘要聚合，来源见参考文献"
  - ❌ **绝不能把内建数据混入实时数据的结论中而不加标注**。如果用户问出"你这个趋势是从哪里来的"，说明输出中来源标注不够清晰，是需要改进的信号

  **网络不可用时的 fallback 流程：**
  1. 诚实告知用户"当前网络受限，无法获取实时排名数据"
  2. 改用内置的 platform-patterns.md + platform-compliance-2026.md 作为趋势分析基准
  3. 输出包含：各等级（S/A/B/C）流量预期 + 平台2026审核变化趋势 + 推荐方向
  4. 附免责说明：基于内置模式库，非实时数据

  **趋势扫描主方法：直接访问平台官网（2026-06 实测最有效）**
  > 抓取模板和实测数据快照见 `references/hongguoduanju-scrape-template.md`

  ⚠️ 搜索引擎（Google/Baidu/Bing）在趋势扫描中效果差：Google 和 Baidu 触发 CAPTCHA，Bing 搜索结果多为下载页而非排行数据。**直接访问平台官网是获取实时排行数据的最可靠方法。**

  **红果短剧官网抓取流程（实测有效）：**

  1. **首页热门榜**：导航到 `https://www.hongguoduanju.com` → 页面直接展示「热门短剧」区域（约30-40部作品），每部含集数、标题、类型标签
  2. **分类页**：点击顶部「分类」链接 → 有完整的筛选体系：
     - 背景：现代/都市/古代/乡村/年代/架空/职场/民国/校园/宫廷/荒岛
     - 主题：现言/女性成长/脑洞/奇幻/玄幻/古言/战神/宫斗/仙侠/权谋/种田/年代爱情/悬疑/喜剧 等
     - 设定：打脸虐渣/大男主/大女主/马甲/重生/穿越/系统/先婚后爱/家长里短 等
     - 受众：男频/女频
     - 时间：7天内上新/14天内/30天内/90天内
     - 推荐排序：最新/最热
  3. **最热排序**：分类页点击「最热」→ 按热度排序的作品列表
  4. **漫画板块**：点击「漫画」标签 → 查看漫改/漫画热门作品（题材分布与短剧有差异：漫画偏玄幻/系统/脑洞）
  5. **轮播区**：首页顶部轮播展示推荐作品，含剧情简介

  **数据采集要点：**
  - 每部作品的信息：标题、集数、类型标签（如「都市爱情」「打脸虐渣」「穿越」）
  - 分类页的筛选体系本身就是平台的题材分类标准，直接反映平台的内容结构
  - 「最热」排序反映当前实际热度，比「最新」更有参考价值
  - 漫画板块与短剧板块的题材差异本身就是数据点（漫画偏男频/玄幻，短剧偏女频/都市）

  **⚠️ 浏览器编码问题：** 含中文的 URL 直接导航会报错 `utf-8 codec can't decode`。
  - ✅ 方案A：先导航到平台首页，在页面内点击链接导航
  - ✅ 方案B：用 Python 对中文进行 URL 编码后拼接
  - ❌ 不要直接在导航 URL 中写中文字符

  **趋势扫描输出格式（实测有效的结构化报告）：**

  ```
  📊 红果短剧平台趋势扫描报告
  ├── 一、题材分布热力图（按背景/主题/设定分类统计占比）
  ├── 二、爆款公式提炼（从热门榜归纳 2-3 个可复制的公式）
  ├── 三、对你选题的直接建议（对标具体爆款作品）
  └── 📌 一句话总结
  ```

  **⚠️ 搜索引擎 CAPTCHA 陷阱（2026-06 实测）：**
  - Google 搜索直接触发 CAPTCHA 验证（"请解决以下难题以继续"），无法绕过
  - Baidu 搜索同样触发验证码（"百度安全验证"）
  - Bing 国内版偶尔触发 Cloudflare 安全质询
  - ✅ **头条搜索（so.toutiao.com）实测可用**，不会触发验证码，且搜索结果含文章摘要（含片段预览、赞数/粉丝数等社交指标）。头条搜索的结果页包含微头条/资讯/视频三类内容，适合快速获取某个短剧名称的讨论热度、评分、粉丝量
  - ✅ **直接访问平台官网**是最可靠方法（如 hongguoduanju.com）
  - ❌ 不要在趋势扫描中依赖 Google/Baidu 作为主要搜索源

  **搜索方向的选择（用户偏好）：**
  - 此用户询问趋势时，优先关注抖音红果短剧/漫剧排行榜而非网文小说排行榜（2026年6月确认）
  - 默认访问：`https://www.hongguoduanju.com`（红果短剧官网）
  - 搜索红果漫剧时应关注：题材分布（都市爱情占比等）、AI漫剧占比、制作成本对比、明星作品热度
  - 如果用户明确区分「小说排行榜」和「漫剧排行榜」→ 遵从用户的区分，只提供用户要的那个方向的数据

  **预检步骤：确认搜索后端可用（仅用于补充数据，非主力方法）**

  在尝试搜索之前，先检查当前 profile 的 web.search_backend 配置：
  - 在 hermes config show 输出中查看搜索后端是否已配置
  - 如果为空，先配置可用的后端：hermes config set web.search_backend ddgs --profile <profile名>
  - 常用免费后端：DuckDuckGo (ddgs)，无需 API Key
  - 注意：web.search_backend 是 per-profile 配置，切换 profile 后可能为空，需重新设置

  **浏览器搜索 fallback（当需要补充搜索数据时）：**
  1. 用浏览器工具导航到 https://cn.bing.com（必应国内版，比 Google/DuckDuckGo 更稳定）
  2. 在搜索框输入中文搜索词 → 点击搜索按钮 → 滚动页面。搜索结果是懒加载的，必须滚动才会出现在 accessibility tree 中
  3. 注意浏览器工具编码问题：含中文的 URL 直接导航会报错 utf-8 decode error
     - 方案A：先导航到 Bing 首页，在搜索框输入中文，点击搜索，然后滚动
     - 方案B：用 Python 对中文进行 URL 编码后拼接完整 URL，再导航访问
     - 不要直接导航含中文的 URL（浏览器工具无法处理）
  4. 搜索技巧：Bing 结果页的 Copilot AI 摘要会直接显示聚合趋势，是最快获取方向的地方
  5. 如果搜索后页面只显示搜索框而没有结果 → 尝试向下滚动，结果可能是懒加载的
  6. 搜索范围过大时，关键词聚焦到具体平台+年份，如红果短剧 热门榜单 2026 爆款

  **⚠️ 浏览器交互基础原则：**
  **⚠️ 浏览器交互基础原则：**\n  - **内置 browser 工具即用户所说的「指纹浏览器」**。Hermes 内置的 browser_navigate/browser_click/browser_vision 等工具运行在 Browserbase 的云端 stealth 浏览器上，具备防检测能力。用户询问"指纹浏览器"时指的就是这套内置浏览器工具——不是本地安装的第三方指纹浏览器软件。\n  - **主动分享截图**：每次使用浏览器工具打开/导航页面后，立即用 `browser_vision()` 截图分享给用户（通过 MEDIA: 语法），不等待用户说\\\"我看不见\\\"。如果 vision 分析失败（如401令牌错误），直接分享 MEDIA: 路径的图片文件——截图本身可能已成功，只是分析接口报错
  - **明确告知浏览器独立性**：浏览器工具是一个独立后台运行的 Playwright Chromium 实例，**和用户当前打开的浏览器完全隔离**。不能控制或连入用户正在使用的浏览器。如用户问\"你不是在用我打开的浏览器吗\"，第一时间澄清这个区别
  - **告知截图限制**：如果导航后截图黑屏或空白，主动判断是否 Canvas/WebGL 渲染，并告知用户替代方案（依赖 accessibility tree）
  - **客户端依赖型站点的识别**：部分 SPA（如麻薯动画 mochiani.com）的 API 全部走本地桌面客户端（`http://127.0.0.1:59844/` 等），网络服务器只返回静态 HTML shell。此类站点即使有有效 token 也无法在无头浏览器中完整工作，因为缺少本地后端服务。特征：导航到任何路径都返回 HTML shell（meta 标签 + `<div id="app">`），`curl` 请求 `/api/` 也返回 HTML 而非 JSON

  **⚠️ 画布/WebGL 渲染站点的截图限制：**
  部分站点（如AI动画工具站、3D展示站、游戏类站点）使用 Canvas / WebGL / Three.js 渲染页面。其特点是：
  - `document.body.innerHTML` 极短甚至为空（3-10个元素），但 accessibility tree 有大量内容
  - `browser_vision()` 截图全黑（无头模式无法捕获 WebGL 帧缓冲区）
  - 无头模式是原因，不是工具故障
  - **识别方法**：用 `browser_console` 执行 `document.body.innerHTML.length`，如果 body 极短但 snapshot 有内容，就是 canvas 渲染
  - **替代方案**：依赖 `browser_snapshot()`（可访问性树）获取页面结构，放弃截图依赖。可访问性树在 canvas 渲染页面上仍然能读出文字和交互元素
  - 这类站点的二维码（如微信扫码登录）无法提取为图片，因为绘制在 canvas 内
  - **SPA 站点认证黑盒分析**：详见 `references/web-research-spa-handling.md`
 - **浏览器失灵→桌面端升级路径**：当 Canvas SPA 无法通过浏览器工具完成操作时（截图全黑、token 注入失败、API 走本地客户端），询问用户是否有桌面版客户端。有则用 cua-driver 控制桌面应用代替浏览器操作。详见 `references/browser-desktop-escalation.md`

 **竞品逆向拆解（当用户提供热门短剧文案要求分析时）：**
 - 见 `references/drama-deconstruction-methodology.md`。从用户提供的音频转文字/完整文案出发，通过五步拆解（内容结构化→单段功能标注→节奏公式提取→爽点机制归类→对标方案生成）系统化提取成功公式，产出对标方案。
 - 拆解产物：情绪曲线图、每集节奏模板、15大爆款因子、对标映射表、"不憋屈"原则检测
 - **⚠️ 对标不创新铁律**：拆解的目的是**1:1精确映射**，不是创意发挥。当用户提供已验证的爆款作品作为对标参考时，只修改故事设定（时代/背景/金手指类型），**绝不修改情绪曲线、节奏公式、爽点排列、角色关系结构**。用户多次纠正"人家爆款是有道理的"、"一定要一致"——如果原版是上行波动情绪线，对标版也必须是上行波动，不能改成深V反转。如果用户说"能不能也结合一下X"，在融合时必须保持原版的核心公式不变，只在外围添加X的元素。详见 `references/drama-deconstruction-methodology.md` 第15节「对标不创新铁律」。

 **Bing浏览器搜索实测有效流程（当search backend和curl都不可用时）：**
  1. 导航到 `https://cn.bing.com`（必应国内版，不需要API Key，比Google/DuckDuckGo稳定）
  2. ⚠️ 不要在URL中直接含中文——浏览器工具对中文URL抛出 `'utf-8' codec can't decode` 错误
     - ✅ 方案A：导航到Bing首页 → 在搜索框输入中文 → 点击搜索按钮 → 向下滚动页面
     - ✅ 方案B：用 `python -c \"import urllib.parse; print(urllib.parse.quote('中文查询', safe=''))\"` 对中文进行URL编码 → 拼接 `https://cn.bing.com/search?q=` + 编码后的字符串 → 导航到完整URL
     - ❌ 方案C不可用：直接在导航URL中写中文字符
  3. 搜索结果在accessibility tree中是**懒加载**的——点击搜索或导航后，页面可能只显示搜索框没有结果。**必须向下滚动**才会出现结果。
  4. Bing的Copilot AI摘要会直接聚合趋势数据（如「2026年红果短剧热门榜单以都市爱情为主」），是最快获取方向的地方，优先阅读
  5. 需要更多数据时，可以点击搜索结果中的链接进入具体页面
  6. 注意：Bing国内版有时会重定向到跳转页——如果看到cn.bing.com跳转，重新导航到cn.bing.com即可

  **方向选择的处理：**
  - 用户从 trend-scan 推荐的方向中选了一个 → 按该方向生成 idea-pool
  - **用户没选方向（如只说"看下选题"、"有哪些"、"继续"）** → 不要追问方向，直接生成跨多个方向的 idea-pool，利用 grade diversity 要求（覆盖至少3个等级）自然分布在 S/A/B/C 级上。每个选题仍标注 Grade 等级。
|- `idea-pool`: Before generating, check memory for an existing "Selected premise" record. If found, flag it to the user ("你之前选的是 XXX，已包含在候选中") so they don't start over by accident. **但如果用户明确说"写新的小说"、"开新书"、"新项目"等，表示想开全新项目**——此时不要继续沿用旧项目，直接进入新 pipeline 从 trend-scan 或 idea-pool 开始。 Then load `references/platform-patterns.md`, `references/idea-scoring.md`, and `references/platform-compliance-2026.md`. Generate 20 premise candidates. **Grade diversity requirement**: cover at least 3 of S/A/B/C levels; ≤12 candidates in any single grade. Apply S/A/B/C tier filtering from compliance guide — candidates prohibited or high-risk must be flagged explicitly. Label each candidate with its compliance grade. If the user calls `idea-pool` again for more options, check existing batch for underrepresented grades and weight toward those gaps. Stop for Manual Checkpoint A.

  **⚠️ 选题池批量被拒后的恢复模式（2026.06经验）：**
  当用户看了20个选题后说"感觉都不要"、"都不喜欢"、"不行"等全盘否定时：
  1. ❌ **不要立刻再生成20个盲猜。** 在没有新方向信号的情况下，再次生成的结果大概率还是会被拒
  2. ✅ **先问方向性问题。** 提供有限的2-4个选项（如古装/现代/悬疑/现实主义），让用户做类型选择
  3. ✅ 用户选定方向后，**只按该方向生成**，不再跨多个方向分散选题
  4. ✅ 新一批选题的质量判断：如果用户对其中1个表现出兴趣（"8"、"第三个"、"那个XX"），就是信号——按这个方向深入
  5. ❌ 不要在被拒后追问"要不您说一下想要什么"——用户如果知道想要什么就不会说"都不要"了。提供具体的选择题（A/B/C选项）比开放性问题更有效
|- `bible`: Load `references/story-bible-template.md`, plus `references/idea-scoring.md` if the selected premise still feels generic. Load `references/manga-hit-guide-2026.md` if the premise needs golden-finger legal-packaging advice. **Scope-proportional conciseness**: keep bible content proportional to total novel length. For a short novel (5万字), the bible should be 5-10 narrative points (core promise, protagonist, cheat, ~4 arcs), not a full deep-dive. If the user says "太长了" about bible output, immediately compress to cover only essential skeleton—abbreviate long-secret tables, antagonist pools, and volume maps to 2-3 lines each. **When the user sets a total word count cap like 5万字, that's a scope signal: everything (bible, outline, chapters) should fit within that constraint, not fight it.**
|- `outline-30`: Load `references/outline-structure.md` and `references/manga-hit-guide-2026.md`. Create the front-30-chapter structure with legally packaged payoff sequencing. Stop for Manual Checkpoint B before drafting.
|- `full-novel-lifecycle`: See `references/full-novel-lifecycle.md` — observed 80-chapter pipeline pattern (five-volume structure, emotional curve design, auto-pilot performance).
|- `trial-10`: Load `references/outline-structure.md` and create a detailed first-10-chapter trial-read plan.
|- `draft-5`: Load `references/chapter-template.md`, `references/memory-system.md`, `references/platform-compliance-2026.md`, and the latest context package. Write 5 chapters, not more, unless the user explicitly asks for fewer. Chapter word count depends on active mode: Full mode ≥1000 characters, 漫剧适配版 600-800 characters, Lightweight ~2000 cumulative. Before outputting, check each chapter against the 6 zero-tolerance red lines in the compliance guide.
|- `compress`: Load `references/memory-system.md` and create the next-round context package.
|- `diagnose`（双模式）: Load `references/diagnose-loop.md` and produce diagnostic analysis.
   - **增量模式**（默认）：每5章一轮写作后调用，产出读者反馈模拟、弃读风险、三条分支选择。Stop at Manual Checkpoint C。
   - **全局复盘模式**（已完本剧本/小说）：产出同诊断项，+ 抖音短剧钩子检查（Short-Drama Hook Audit）、叙事跳跃检测（Narrative Jump Detection）、感情线节奏检查（Romance Pacing Check）。不触发 Manual Checkpoint C（无需分支选择）。
   
   ⚠️ **输出规范**：全局复盘分析时，必须在结论中明确标注"有规则覆盖"✅ vs "基于经验判断/无覆盖"的区分，让用户一眼看出哪些是 pipeline 既有规则输出、哪些是补充判断。
| `compliance-audit`: ✅ **本profile完整保留**。全套合规审计+灰区扫描+重写建议+爆款潜力评估直接使用。查看 `references/platform-compliance-2026.md`。输出格式见 `references/compliance-audit-template.md`（含新增的 section 八·爆款潜力评估）。

  **审计方法论（来自2026.05.18规则更新后的实践）：**

  0. **审计前预检：确认集数一致性。** 读取 `04-全集大纲.md` 确认剧本总集数，然后检查 `episodes/` 目录下的文件是否覆盖了全部集数。如果审计对象是压缩后的版本（如35集），但文件中还有旧版的内容，先清理旧文件再审计。审计报告中的集数声明必须与实际文件一致。

  1. **先检查现有审计报告的日期。** 如果现有 `99-合规自检报告.md` 的版本日期早于 `platform-compliance-2026.md` 的最新版本日期，必须标记"规则更新后重新审计"。
  2. **正文 vs 大纲分开检查。** 实践中发现：**大纲（`01_前80章大纲（完整）.md`）文件中的措辞往往比正文更 sensational**——大纲用简写/噱头式表述（如"天赋升级""终极形态"），而正文实际描写更温和（如"药膳蒸汽""天赋无效"）。审计时必须查阅正文原文验证，不能只依赖大纲判断。
  3. **△剧本的合规度天然更高。** 由于△剧本是视觉/动作驱动的场景化写作，很少出现超能力式抽象表述，通常比对应的正文章节更安全。
  4. **隐性红线修复策略：** 遇"爽点碾压"类问题时，优先改措辞不改剧情——将"突然获得超能力"改写为"通过长期练习/传承学习获得的技艺突破"，剧情框架不动。
  5. **审计完成后更新 `99-合规自检报告.md`** 中的状态和整改记录，确保下一次审计能直接看到本次改动。
| `drama-adapt`: ✅ **本profile完整保留**。参考文件 `references/drama-adaptation.md`，在本profile内直接执行即可输出△格式剧本。

  **⚠️ 压抑-释放压缩后的文件清理铁律：**
  当使用 drama-adaptation.md 中的「压抑-释放周期压缩规则」将剧本从N集压缩到M集时（如50集→35集）：
  - ✅ 创建新的压缩文件（如 ep001-013_卷1.md）
  - ✅ **必须删除所有旧的、已被替代的 episode 文件**（如 ep001.md, ep002-005.md 等）。新旧文件共存会让用户看到的总集数仍然是旧版的数字，产生"内容压缩了但文件还是50集"的困惑
  - ✅ 新文件的命名要清晰标注集数区间（ep001-013_卷1.md）
  - ✅ 同时更新配套文件：04-全集大纲.md（改为压缩版）、99-合规自检报告.md（修改集数/时长数据）
  - ❌ 不要只创建新文件不删旧文件——用户看到的是文件系统，不是你的内部状态
  - ❌ 压缩后不要在 episodes/ 目录中留下任何旧文件

  **⚠️ 集输出规则（用户明确要求）：一集一个独立文件。**\n  - ✅ 每集输出一个独立文件，命名 `ep{NNN}.md`（如 ep001.md、ep002.md）\n  - ✅ 不合并、不打包——每集一个文件\n  - ✅ 文件直接写入 `短剧版/episodes/` 目录，不在对话中展示全文
  
  **续写已存在项目的工作流（非首次适配）：**
  1. 先读取项目下所有已有文件：`01-题材定位.md`、`02-角色资产表.md`、`03-场景资产表.md`、`04-全集大纲.md`、`05-付费卡点布局.md`、`99-合规自检报告.md`
  2. 读取最近一集的 △ 剧本文件，确认格式细节（语气标记、OS/独白风格、△描述颗粒度）
  3. 读取对应的小说章节原文作为素材
  4. 严格保持格式一致：新写剧本的 △ 标记、对话格式、OS 风格必须与已有剧本逐字对齐\n\n  **⚠️ 短剧开头3秒质量要求（drama-adapt 产出的核心质量门）：**\n  △剧本的第一帧画面必须是能让观众停下来的视觉冲击，绝不能让观众前3秒就划走。具体规则：\n  - ❌ **不能以"人物走进房间""坐下开始说话""日常动作"开头**——节奏太慢，短视频环境不适用\n  - ✅ 第一帧必须是：匪夷所思的动作 / 冲突爆发的瞬间 / 让人产生"这怎么可能？"好奇心的画面\n  - ✅ 系列剧第一集（ep001）的第一帧必须直接展示核心设定（如"狗用爪子打开了冰箱"），不做任何铺垫\n  - ✅ 每集前15秒必须包含至少一个"小爆点"（可以是笑点/反转/奇观/情感冲击），不能只有场景交代\n  - 示例（好）：\n    ```markdown\n    △（特写·黑暗中一声冰箱门轴摩擦声）\n    △（月光下，一只狗的爪子搭在冰箱把手上）\n    △（切到周悦在地铁上，瞳孔放大，盯着手机）\n    ```\n  - 示例（差）：\n    ```markdown\n    △（中景·玄关。傍晚。周悦开门进屋。屋里很安静，冰箱门大敞着。）\n    ```
| `prompt-gen`: ✅ **本profile完整保留**。默认输出格式：麻薯动漫导演格式（\|切片段N + 运镜六要素 + 配音指令），见 `references/matsuri-director-prompt.md`。`references/mantoufan-prompt-source.md` 作为源skill历史参考保留。

  **prompt-gen 执行流程：**\n  1. 读取目标 △ 剧本文件（epXXX.md），提取时长（X分X秒）→ 换算段数：总秒数÷15=段数，上取整\n\n  **⚠️ 规模节点：50集×每集10段≈500个文件。** 当 prompt-gen 的目标集数≥10集时，必须先告知用户产出的文件总量，并提供三种交付方案供选：\n     - 方案A「全量交付」：逐集生成全部素材清单和分段提示词（50集≈500个文件，需多轮完成）\n     - 方案B「模板先行」：仅生成前5集作为完整模板，后续45集由用户自行扩写或要求继续\n     - 方案C「仅素材清单」：为所有50集生成素材清单资产表，省略分段提示词正文\n     默认选方案B（模板先行），除非用户明确要求全量或仅清单。\n\n  **当用户选方案A（全量交付）时，用 `delegate_task` 并行加速：** 将50集按5-10集每批分包给子代理。**关键铁律：必须为每个子代理分配独占的编号区间**（P##、C##、S##），防止编号冲突。方法：在每个子代理的 `context` 中写明"你负责的ep011-ep020使用道具编号区间P13-P30，角色/场景编号复用已有"。避免出现多个代理都从P13起编导致的全局重复。
  2. 读取项目 `02-角色资产表.md` 和 `03-场景资产表.md`，提取本集用到的角色 C## 和场景 S##
  3. 按每15秒一个独立分段，将剧本切分为 N 段，每段一个独立 `.md` 文件
  4. 输出两层交付物：
     - **层1：素材清单** — `{ep编号}-素材清单.md`。格式遵循 `references/asset-description-format.md` 的结构化描述（禁止情绪词、字段化外形/服装/鞋履、群演完整条目、场景基础空间+视觉细节、道具基础信息+视觉细节）。包含本集用到的角色（C##）、场景（S##）、道具（P## 新增）+ 群演补充角色（前缀"群演-"）
     - **层2：分段提示词** — 每段一个独立文件，命名 `{ep编号}-段{NNN}-提示词.md`
  5. 每段严格遵循麻薯格式：总述头部（有音效/无音乐/无字幕/运镜丝滑 + 场景/景别/画面描述/场景设计/目的标签/片段数/片段说明）+ 4-5个\|切片段（每切片段含运镜六要素 + 可选的配音指令）
  6. 运镜六要素不可缺省：景别/角度、起幅、落幅、速度、跟焦、落点
  7. 配音指令四要素：性别年龄、音色类型｜语气情绪、"台词"

  **⚠️ 导演模式 — 上下文注入方法论（2026.06新增）：** 详见 `references/prompt-gen-director-mode.md`。
  prompt-gen 不是孤立切片翻译，是**导演模式**——模型必须同时看到全集全貌和当前段位置，才能做出前后连贯的运镜决策。  
    
  **每次生成一个段的分镜提示词时，必须将以下上下文全部注入模型：**  
  1. **全集剧本**（epXXX.md 全部内容）—— 让模型理解完整情绪弧线
  2. **当前段定位**—— "这是第N段/共M段，情绪从X转向Y"
  3. **角色资产表**（C01-CXX）—— 锁定角色外貌
  4. **场景资产表**（S01-SXX）—— 锁定场景光影
  5. **格式模板**（matsuri-director-prompt.md）—— 输出规范
    
  模型在此基础上推理：
  - 前一段结束时的情绪是什么？本段应该承接什么？
  - 全集的高潮在第几段？本段是铺垫还是释放？
  - 角色的情绪状态在全集中是如何变化的？本段处于哪个节点？
    
  段与段之间的运镜必须有叙事连续性——不能每段都从"全景建立"开始。  
  **为什么 prompter 需要顶级模型——不只是 context 大小：**  
  三款主流模型（Gemini 3.1 Pro、deepseek-v4-pro、deepseek-v4-flash）都支持 1M context，都能装下全集剧本。**真正的差异在推理质量：**  
    
  | 能力维度 | prompt-gen 需求 | Gemini 3.1 Pro | deepseek-v4-pro | deepseek-v4-flash |
  |---------|:-------------:|:--:|:--:|:--:|
  | 长上下文推理（段间连贯） | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
  | 视觉想象力（文字→画面） | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
  | 格式严格遵循 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
  | 中文创意表达 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

  prompt-gen 需要的不只是"看到全集"，而是**理解全集情绪弧线并转化为连续的镜头语言**。这三个模型的 context 一样大，但推理质量有差距——段与段之间的运镜连贯性、情绪承接的精准度、视觉想象力的丰富度，Gemini 3.1 Pro 综合最强。deepseek-v4-pro 中文更好但视觉想象力略逊，flash 推理能力不足以支撑导演模式。

  **⚠️ 画风确认步骤（2026.06新增——必须在生成第一个分镜提示词前执行）：**
  1. 用 clarify 询问用户想要的画风风格
  2. 提供选项：古风写实3D、古风动漫（赛璐璐/日式）、古风水墨风、3D CG国漫等
  3. 在用户选择画风后，每个分镜文件的「画面描述」和「场景设计」中按该画风描述材质/光影/渲染风格
  4. 3D CG国漫风格特点：写实光影但角色造型带国漫脸型特征、材质有细节纹理、色彩饱和度适中偏暖

  **⚠️ 每15秒一段 = 一个段文件（每段含4-5个|切片段）：**\n  用户确认的格式：每15秒内容写入一个独立文件。每集段数 = ceil(总秒数 / 15)。\n  - 命名：`{ep编号}-段{NNN}-提示词.md`\n  - 每个文件：总述头部 + 4-5个\\|切片段\n  - 格式约束、画风规则、配音指令格式见上方「Pitfalls（prompt-gen 相关）」\n  - ❌ 不要用 execute_code/脚本批量生成——模型逐段思考后用 write_file 逐文件写入

  **素材清单生成规则：**
  - 整体格式遵循 `references/asset-description-format.md` 的结构化描述模板：角色按禁止情绪词+字段化（年龄/性别/年代/身份/外貌/发型/上下装/鞋子/配饰），场景按基础空间+视觉细节，道具按基础信息+视觉细节
  - 角色（C##）：从已有资产表按编号读取，标注本集造型（如造型-流放期）
  - 场景（S##）：从已有资产表按编号读取，标注时间/天气
  - 道具（P##）：增量创建，只添加本集首次出现的道具，后续集复用已有编号
  - 群演角色：命名为"群演-官差""群演-流放女"等格式。群演也需完整字段（禁止情绪词、结构化描述），不占用 C## 编号
  - 同一角色不同时期造型 = 独立条目（如 C01 和 C01b）
  - 资产名称分隔符统一用连字符 `-`，不用 `·`

  **资产命名分隔符规则**：素材清单中所有角色造型/场景地点/年代/道具/装备名称的层级分隔符用连字符 `-`，不用中间点 `·`。AI 对 `·` 的分隔语义理解不稳定。模板及对照表见 `references/matsuri-director-prompt.md` → `## 素材清单 — 资产命名规范`。
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
  └── 98-视频分镜提示词/       # 分镜提示词（prompt-gen产出，每15秒一个独立段文件）
      ├── ep001-素材清单.md
      ├── ep001-段001-提示词.md
      ├── ep001-段002-提示词.md
      ├── ...
      └── ep002-素材清单.md
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

当用户说"自动执行"、"你帮我选"、"你帮我检查和选择"、"写完全本小说"或表达类似意图时，进入 auto-pilot 模式。

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
- ❌ **一旦用户说'不要在询问我了'、'直接开干'、'你帮我选并完成流程'、'写完全本小说'或类似表达的「你帮我选+写完全本」组合——意味着用户想一次性跑完整个流水线，不再回应任何问题。立即将所有未决决策默认化：格式默认网文版→后续转剧本、分支默认选A安全、总字数和章节数按已有约定执行。不再询问任何格式/字数/分支/下一步的确认。以最快速度出产内容，直到全本完稿或用户主动喊停。**
- ❌ Auto-pilot 模式默认不等于一次性写全本。仍然每5章一轮、每轮写完做一个诊断检查。
  **例外：如果用户明确说"写完全本小说"或类似「你帮我选+写完全本」组合，则 override 此规则。** 此时仍按5章一批写文件，但跳过每轮的诊断分支选择，直接连续写下一批。每批完成后用文件树进度表（🧩 进度可视化格式）展示当前进度即可，不必停下等待。直到全本写完或用户主动喊停。
- ❌ 用户说"帮我选"后，必须给出选择理由，不能只说"选A"不解释。
- ❌ 当 auto-pilot 模式下遇到大纲用完时，自动扩展大纲后继续写，不要在扩展大纲后停下等待确认——除非用户手动退出 auto-pilot。
- ❌ 不要跳过初期的 Manual Checkpoint A 和 B。只有 Checkpoint C 可以在 auto-pilot 模式下自动执行。
- ❌ **在 auto-pilot 模式下，即使 skill 流程要求输出格式确认/分支选择/下一步确认——如果用户此前说过"不要问了"或"帮我选"，用默认值代替提问。输出格式决策：如果用户已选了📖→🎬且未反悔，直接沿用。分支选择：默认选A安全分支。下一步行动：默认 auto-pilot 连续推进。完本后默认跑 compliance-audit + drama-adapt。不询问，只执行+告知。**
- ❌ **不要混淆△剧本转换和视频/分镜提示词生成。** `drama-adapt` 仅输出△格式的文字剧本（含对白/OS/镜头描述），不生成任何 AI 视频提示词。视频分镜提示词用 `prompt-gen` 命令（默认输出麻薯动漫导演格式）。不要在 `drama-adapt` 命令中混入视频提示词输出。
- ❌ 不要在输出文件和项目文件中使用「Seedance」/「Seedance 2.0」/「即梦」相关名称。用户明确禁止。提示词文件目录用 `98-视频分镜提示词/`，文件名用 `ep{NNN}-提示词.md`。SKILL.md 内部命令名用 `prompt-gen`，不用 `seedance-*`。
- ❌ 资产名称中的分隔符不要用中间点 `·`。AI 对 `·` 的分隔语义理解不稳定。统一用连字符 `-`。例如：`造型-流放期`(非`造型·流放期`)、`朔风荒原-流放场`(非`朔风荒原·流放场`)、`架空-大雍朝`(非`架空·大雍朝`)、`天工-镇渊号`(非`天工·镇渊号`)。适用于素材清单/场景名/角色标签/集标题/装备名中所有层级分隔。

## Rules-Enforcement Protocol（每次执行前强制自检）

> 本技能的问题不是缺少规则，而是执行时忽略已有规则。
> 加入以下自检步骤，强制在执行前确认格式。

### 写文件前打开 reference 对照（铁律）

写任何格式敏感的文件（△剧本/分镜提示词/审计报告）之前，**必须用 skill_view 打开对应的 reference 文件**，逐行对照格式模板，不得凭记忆写格式。

| 操作 | 必须对照的文件 |
|:-----|:--------------|
| 写 △ 格式剧本 | `references/drama-adaptation.md` |
| 写麻薯分镜提示词 | `references/matsuri-director-prompt.md` |
| 写合规审计报告 | `references/compliance-audit-template.md` |
| 写素材清单 | `references/asset-description-format.md` |
| 写运镜补充 | `references/camera-shot-selection.md` |

### 三类错误清单（每次执行前通读）

#### 第一类：prompt-gen 格式漂移（本session发现的高频错误）
- ❌ 不要用 execute_code/脚本批量生成提示词内容。内容由模型逐段思考后用 write_file 逐个写入。
- ❌ 不要写「画风」单独行。画风融入场景设计的材质/光影描述中。
- ❌ 配音指令格式严格按模板：`【角色名】（配音指令：[性别年龄]，[音色类型]｜[语气情绪]，"[台词]"）`
- ❌ 段数按时长计算：段数 = ceil(总秒数 / 15)。不是自由分配。
- ❌ 每个文件写之前必须打开 reference 对照格式，第一个文件让用户确认后再继续。

#### 第二类：输出方式错误
- drama-adapt 和 prompt-gen 的产出：**直接写文件，不在对话中展示正文**。对话中只报告文件路径和统计摘要。
- △剧本：**一集一个文件** ep{NNN}.md，不合并。

#### 第三类：流程执行错误
- 每个新步骤开始前，口头过一遍该步骤的 pre-flight checklist。
- 当多个规则文件说法冲突时，停下，问用户选哪个，不要自己猜。

### Three-Step Pre-Flight（prompt-gen 专用）

1. 用 `clarify` 问画风风格（提供选项）
2. 用户选择后，画风信息融入场景设计描述，不作为「画风」行
3. 确认文件格式偏好（默认为一段一文件，每段4-5切片段），告知文件总量

### Ad-Hoc Verification（系统要求时使用）

修改 profile 配置或 SKILL.md 后，如系统要求提供验证证据：按 `references/verification-pattern.md` 流程编写临时验证脚本，13-15项检查覆盖文件存在性、配置字符串、关键内容。完成后清理 temp 文件。

## Manual Checkpoints

| 检查点 | 触发时机 | 正常模式 | Auto-Pilot 模式 |
|--------|---------|---------|----------------|
| ✅ A | `idea-pool` 后 | 用户从20个选1个 | 用户从20个选1个（不可跳过） |
| ✅ B | `bible`/`outline-30`/`trial-10` 后 | 用户确认骨架 | 用户确认骨架（不可跳过） |
| ⚠️ C | 每轮 `draft-5` + `diagnose`（增量模式）后 | 用户从三条分支选一个 | **代理自动选最优分支并执行** |

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

### 原则三：规则更新后的「重新理解→重新执行」流程

当用户说「重新理解规则，然后重新跑一遍」或类似表达时（如 reference 文件被更新后）：

1. **重新加载**：重新读取所有相关的 reference 文件，确认最新的规则内容
2. **差异分析**：对比旧版本和新版本，找出具体变化（如新增的压缩规则、修改的审核标准等）
3. **影响评估**：检查已有产出中有哪些部分受新规则影响（如已有△剧本需按新压缩规则审核）
4. **重新执行**：对受影响的部分重新执行相应的 pipeline 步骤（如重新跑 drama-adapt）
5. **清理旧文件**：重新执行后，删除旧版文件，只保留新版本的产出
6. **更新配套文件**：如果集数/字数/结构发生变化，同步更新全集大纲、合规报告等配套文件

示例模式：
```
用户：重新理解规则，然后再次跑一边剧本
代理：重新读取 drama-adaptation.md → 发现新增了压缩规则 → 检查现有50集剧本中发现卷4有10集过于拖沓 → 执行压缩为35集 → 删除旧50集文件 → 更新全集大纲和合规报告
```

**如果用户要求「重新跑」的对象是网文→△剧本转换（drama-adapt），被要求重新跑的是转换后的剧本文档而非原始小说。** 此时不需要重新跑 idea-pool / bible / outline / draft-5 等小说创作步骤。
当用户要求「重新跑」某个下游步骤时，默认理解为只重新跑那个步骤本身，不向上游回溯。除非用户明确说「从头开始」「重新选题」等。**同样，当 user 询问「看一下这个对话」，查看的是对话记录中的工作成果和用户指令，用于在当前 session 中复用或参考——不是恢复那个 session 的状态，也不意味着需要重做那个 session 的工作。**

### 原则四：「算了不改了」立即终止

当用户说 "算了不改了"、"算了"、"不动"、"先别弄了" 或类似意思时：
- 立即终止当前备选行动，不做任何额外解释
- 不追问 "真的不弄了吗？"
- 不主动再次提起该任务

## File Output & Persistence

When saving generated content to disk:

**Never use `execute_code` for file operations.** Always use `write_file` directly — one file per call. Individual write_file calls are clearer, auditable, and let the user see every file being created.

**Display vs write — two modes depending on deliverable type:**

| 产出类型 | 展示策略 |
|:---------|:---------|
| **Idea-pool / bible / outline**（中间规划） | 对话中展示，仅用户说"存"才写文件 |
| **Draft-5 / novel chapters**（正文） | 对话中展示 + 写入项目目录 |
| **Drama-adapt / prompt-gen / compliance audit**（下游产出） | **直接写文件，不在对话中展示正文全文。** 对话中只报告文件路径和统计摘要（文件数/段数/总时长），不展示文件内容。用户明确要求"不要输出出来，写文件"。 |

**Save only after explicit user instruction** for planning deliverables. For production deliverables (chapters, drama scripts, prompt-gen), auto-save to the established project directory.

**Exception: Auto-Pilot mode.** When operating in auto-pilot mode (用户说"自动执行"、"你帮我选"等), files ARE auto-saved after each draft-5 round without asking. The agent still uses `write_file` directly (one file per call), but doesn't pause to ask "should I save this?". However: in auto-pilot mode, output content is still displayed in the conversation as it's written—file saving is automatic, but in-conversation display is not skipped.

### Pitfalls（file output）

- ❌ **下游产出（剧本/提示词/审计报告）不要在对话中展示全文。** 用户已多次确认。对话中只报告文件路径和统计摘要（文件数、段数、总时长）。不要在对话中贴全文。
- ❌ **不要用 execute_code 写文件内容。** 内容必须由模型逐段/逐章/逐集用 write_file 直接写入。execute_code 仅适用于文件管理操作（清理旧文件、查数量）。
- ❌ **下游产出（剧本/提示词/审计报告）不要在对话中展示全文。** 用户已多次纠正。对话中只报告文件路径和统计摘要。
- ❌ **规划类产出（选题/圣经/大纲）不要在用户确认前写文件。** 先在对话中展示，等用户说"存"再写。

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
