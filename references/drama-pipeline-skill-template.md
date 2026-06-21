# drama-pipeline

本 skill 只包含小说→短剧→分镜提示词的全链路，不包含写小说能力。
由 `viral-webnovel` profile 完成写小说后，切换到此 profile 执行转换。

## 管道命令

|- `drama-adapt`: Load `references/drama-adaptation.md` plus `references/platform-compliance-2026.md`. Convert webnovel chapters into △-format short-drama episodes with paywall placement and compliance filtering.

- `prompt-gen`: Load `references/mantoufan-prompt-source.md` (权威来源，严格遵循源skill模板，不做摘要式简化).
  输入：△格式剧本 epXXX.md + 全局资产表 (02-角色资产表.md, 03-场景资产表.md).
  **两层独立输出（每层格式都直接复制自源skill，不得自行重构）：**

  **层1：素材清单** → `98-视频分镜提示词/epXXX-素材清单.md`
    格式：C##/S##/P## 资产编号 + 图像生成提示词。遵循源skill Step 4 资产生成提示词格式：
    ```
    ### [编号] — [名称]
    [风格前缀]，[详细视觉描述（中文）]，[技术规格]
    ```

  **层2：单段分镜提示词** → `98-视频分镜提示词/epXXX-段NNN-提示词.md`
    ⚠️ 核心规则：每15秒一段，每段一个独立文件。绝不合并多段到一个文件。
    每个独立文件遵循源skill Step 5b 时间轴格式（一字不差）：
    ```
    画面无任何字幕。

    [风格描述]，15秒，9:16竖屏，[整体氛围]

    0-3秒：[场景建立] - [镜头运动]，[详细画面描述]，[环境音效]，[氛围营造]
    3-6秒：[主体引入/情节发展] - [镜头运动]，[具体动作]，[动作音效]，角色A（情绪）："[此刻的对白]"
    6-9秒：[发展/冲突] - [镜头运动]，[关键动作]，[细节特写]，角色B（情绪）："[此刻的对白]"
    9-12秒：[高潮/转折] - [镜头运动]，[情绪爆发]，[视觉冲击 + 同步音效]
    12-15秒：[结尾/落版] - [镜头运动]，[最终画面]，[余韵]

    【声音】[配乐风格] + [关键音效清单] + [各角色声线描述，对白已在时间轴内不再重复]
    【参考】@图片1 [用途说明]，@图片2 [用途说明]，@图片3 [用途说明]...
    ```
    对白强制嵌入时间轴对应秒数内，【声音】只放声线/配乐/音效，不放对白文本。
    遵循铁律3（开头第一句"画面无任何字幕。"）、铁律4（对白嵌入时间轴不集中堆放）。

  **批量处理技巧（多集并行）：**
  当需要为多集（如 ep002-ep005）同时生成提示词时，使用 `delegate_task` 的 tasks 数组模式并行处理：
  ```
  delegate_task(tasks=[
    {goal: "为 ep002 生成提示词", context: "模板规则+剧本路径"},
    {goal: "为 ep003 生成提示词", context: "..."},
    {goal: "为 ep004 生成提示词", context: "..."},
  ])
  ```
  每集子任务产出11个文件（1素材清单 + 10段提示词）。然后处理剩余集。
  最高并行度：用户配置的 delegation.max_concurrent_children（默认3）。

|- `compliance-audit`: Load `references/platform-compliance-2026.md`. Run the full audit: check for banned genres, hidden red-line violations, S/A/B/C tier alignment, and compliance-packed rewrite suggestions. Can reject and route back to `draft-5` or `outline-30`.

### 并行批处理（多集同时出提示词）

当需要为多集（如 ep002-ep005）批量生成提示词时，使用 `delegate_task` 的 tasks 数组模式并行加速：

```
delegate_task(tasks=[
  {goal: "为 ep002 生成提示词", context: "模板规则+剧本路径+资产表路径…"},
  {goal: "为 ep003 生成提示词", context: "同上，换ep003"}…,
  {goal: "为 ep004 生成提示词", context: "同上，换ep004"}…,
])
```

每个子任务独立运行，产出 11 个文件（1 素材清单 + 10 段提示词），写入共享工作目录。剩余集（如 ep005）随后单独处理。最高并行度 = `delegation.max_concurrent_children`（默认 3）。

**注意事项：**
- 每个子任务是独立 agent，需要完整的上下文（模板规则、文件路径）
- 子任务产出文件到共享工作目录，父 agent 不需要合并
- 对白嵌入时间轴、【声音】不放对白文本等铁律必须在 context 中显式声明
- 每个子任务通过 read_file 读取剧本+资产表，通过 write_file 写入输出

⚠️ 源skill完整模板见 `references/mantoufan-prompt-source.md`。任何格式争议以该文件为准（它直接嵌入源skill原文，非摘要）。

## 工作区约定

- 源小说文件位于用户指定的 Obsidian 工作区（如 `E:\ObsidianSource\03_AI漫剧\<小说名>\02_正文_第X章.md`）
- 输出目录固定为 `<小说名>\短剧版\`
- 输出结构：
  ```
  短剧版/
  ├── 01-题材定位.md          # S/A/B/C分级 + 受众 + 付费策略
  ├── 02-角色资产表.md        # 角色编号C01-C99 + 外貌/性格标签
  ├── 03-场景资产表.md        # 场景编号S01-S99 + 风格关键词
  ├── 04-全集大纲.md          # 60-100集 × 三幕结构表（含付费卡点标记）
  ├── 05-付费卡点布局.md      # 卡点位置 + 套路类型 + 话术
  ├── 99-合规自检报告.md      # 红线 + 灰区扫描（可选）
  ├── episodes/               # △格式文字剧本（drama-adapt产出）
  │   ├── ep001.md
  │   └── ...
  └── 98-视频分镜提示词/       # 分镜提示词（prompt-gen产出）
      ├── ep001-素材清单.md
      ├── ep001-段001-提示词.md
      └── ...
  ```

## 输入来源

从 `viral-webnovel profile` 读小说文件（只读），写剧本/提示词到共享工作区。

```
viral-webnovel profile:                         drama-pipeline profile:
写小说 → *.md (共享工作区)                    读 *.md → △剧本 → 提示词
```
