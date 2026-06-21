# Profile 独立副本维护指南

> 用途：当用户要求将一个 profile（如 drama-pipeline）的特定能力集合以"独立副本"形式同步到另一个 profile（如 viral-webnovel）时，按本流程执行。
>
> ⚠️ 本文件记录的是「向已有 profile 添加独立副本」的维护流程，不是「创建新 profile」的流程（后者见 SKILL.md 中「新建 profile 的步骤」）。

## 触发场景

用户在对话中要求：

> "给当前 profile 也添加完整 X 能力，和 drama-pipeline profile 分开，互不影响，因为我需要在 drama-pipeline profile 做尝试修改，但不希望影响这里。"

## 核心原则

- 两个 profile 之间的 SKILL.md 是**完全独立**的。drama-pipeline 的 SKILL.md 怎么改，都不影响 viral-webnovel 的 SKILL.md。
- 参考文件（references/ 目录下的 .md）在磁盘上是同一份文件。如果两个 profile 需要各自的版本，需要物理复制（参考「新建 profile 的步骤」）。
- auth.json/credential_pool 是 profile 独立的。每个 profile 有自己的 auth.json。
- config.yaml 也是 profile 独立的。

## 操作流程：向当前 profile 添加独立副本

假设要在 viral-webnovel profile 中添加 drama-adapt/prompt-gen/compliance-audit 的独立副本。

### 第一步：确认参考文件是否已存在

```bash
ls -la /c/Users/Administrator/AppData/Local/hermes/profiles/viral-webnovel/skills/viral-webnovel/references/
```

如果已有 drama-adaptation.md、mantoufan-prompt-source.md、platform-compliance-2026.md，则无需复制。没有的话需要从 drama-pipeline profile 复制。

### 第二步：修改 SKILL.md 中的 5 个区块

需要精确 patch 以下 5 个地方（缺一不可）：

#### 区块 1：Profile Separation 节首

将 "本 skill 只保留写小说能力，不再包含短剧转换命令" 改为：
```
> ⚠️ **当前状态：本profile同时拥有 drama-adapt/prompt-gen/compliance-audit 的完整独立副本。**
```

#### 区块 2：命令归属表

将相关命令的「所属 profile」列从 `**drama-pipeline**` 改为 `**viral-webnovel**（独立副本）`，说明列追加 `（与drama-pipeline互不影响）`。

#### 区块 3：数据流向图

将原来的接力模式图（viral-webnovel → drama-pipeline）改为同 profile 内全链路图：
```
viral-webnovel profile（写小说 + 转剧本独立副本）
  draft-5 → compliance-audit → drama-adapt → prompt-gen
```

底部添加说明：`drama-pipeline profile 是独立副本，修改不影响本profile。`

#### 区块 4：三个命令条目

将 `⚠️ **已迁移** 到 drama-pipeline profile` 改为：
```
✅ **本profile完整保留（独立副本）**。...与 drama-pipeline profile 同名命令互不影响。
```

#### 区块 5：Pipeline sequencing

将原来的 "切换到 drama-pipeline profile" 作为主流程改为：
```
**Pipeline sequencing（本profile独立运行，不依赖drama-pipeline）:**
- ✅ 本profile内 **写小说 → 转剧本 → 分镜提示词** 全链路直接可用
- ✅ 与 drama-pipeline profile 互不影响——那边随便改，这边稳如泰山
```

原先的跨 profile 接力保留为备选方案。

### 第三步：验证

```bash
# 1. 确认 SKILL.md 中不再有 "已迁移" 相关字样指向这些命令
grep -n "已迁移" SKILL.md

# 2. 确认命令归属于 viral-webnovel
grep -n "drama-adapt" SKILL.md  # 应显示独立副本字样

# 3. 确认 pipeline sequencing 以本profile独立运行为主
grep -n "Pipeline sequencing" SKILL.md
```

## Pitfalls

- ❌ **不要只改命令归属表就以为完成了。** 五个区块必须全部修改，遗漏任何一个都会导致 agent 在加载 skill 时读到矛盾的指令（一边说"完整保留"，一边说"已迁移"）。
- ❌ **不要在同一个 SKILL.md 中混用两套叙事。** 要么全用"已迁移"叙事，要么全用"独立副本"叙事。中间过渡状态会产生歧义。
- ✅ **用 `patch` 工具逐个修改**，比直接 edit 整个 SKILL.md 更安全。每个 patch 可以单独验证 diff。

## 当前 profile 的快照数据（2026-06-21）

```
profile: viral-webnovel
provider: opencode-zen
model: deepseek-v4-flash-free（免 key）
自定义 providers: 无
auth.json credentials: opencode-zen × 3（has_secret=False，均为 exhausted 状态）
.env 中的 key: OPENCODE_ZEN_API_KEY（存在但运行时未加载）
```

> 此快照用于快速诊断 key/提供商问题。更新 SKILL.md 后记得刷新这里的描述。
