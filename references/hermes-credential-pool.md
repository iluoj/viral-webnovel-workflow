# Hermes Credential Pool 说明（针对 viral-webnovel profile）

## 一句话

> **每个 profile 只有一个 `model.default + provider` 在同时生效。** "多个供应商"是指不同场景（全局/不同 profile）各用各的配置，不是三个同时在线。

---

## 当前 profile 的凭证情况

| 来源 | 优先级 | 状态 | 说明 |
|------|--------|------|------|
| `.env` 中 `OPENCODE_ZEN_API_KEY` | 0（最高） | ✅ 在用 | 真正生效的 key，由 Hermes 父进程从 .env 加载 |
| key-2（手动添加） | 1 | ok | 无实际密钥值（空壳） |
| key-3（手动添加） | 2 | None | 无实际密钥值（空壳） |
| key-4（手动添加） | 3 | None | 无实际密钥值（空壳） |

**实际有效的只有 1 个：OPENCODE_ZEN_API_KEY**，其他 3 条是空记录。

---

## 核心机制：为什么查不到 key

| 你可能会查到 | 实际原因 |
|-------------|----------|
| `auth.json` 中 `has_secret=False` | auth.json **不存具体密钥值**，存的是元数据和来源标记（`source: env:OPENCODE_ZEN_API_KEY`） |
| 子进程（`execute_code`/`terminal`）env 无 `OPENCODE_ZEN_API_KEY` | 子进程不继承 Hermes 父进程从 .env 加载的变量 |
| `status=exhausted` | 该 key 之前在别的模型（如 MiniMax M3 Free）上被限流过，但 deepseek-v4-flash-free 不受影响 |

**结论：查不到 ≠ 没有 key。** Hermes 父进程持有 key，API 调用正常。

---

## 如何查看和切换模型

```bash
# 查看当前配置
hermes config list --profile viral-webnovel | grep -A5 "^model:"

# 换模型（只改这一个字段）
hermes config set model.default deepseek-v4-flash
hermes config set model.default glm-4.7-free
hermes config set model.default nemotron-3-super-free
```

## 如何查看所有凭证

```bash
# 看看全局凭证池
cat ~/AppData/Local/hermes/auth.json | python -m json.tool

# 看看当前 profile 的凭证池
cat ~/AppData/Local/hermes/profiles/viral-webnovel/auth.json | python -m json.tool
```

---

## 自动切换（Credential Pool 机制）

Hermes 的 credential pool 按 Priority 自动降级：

```
Priority 0 → 先用（当前有效）
  ↓ 429/401 错误
Priority 1 → 自动切
  ↓ 也挂了
Priority 2 → 再切
```

但前提是：低优先级的 key 必须 **有实际密钥值**（has_secret=True）。当前 profile 的 key-2/3/4 都是空壳，切过去也会失败。

要添加真正的备用 key：
```bash
hermes auth add opencode-zen --label "备用key" --secret "sk-xxx..."
```

---

## 关系图

```
┌─────────────────────────────────────────────────┐
│                 Hermes 父进程                     │
│  (持有 OPENCODE_ZEN_API_KEY 从 .env 加载)        │
│                                                   │
│  ┌────────────────┐  ┌─────────────────────────┐  │
│  │ model.default  │  │ auth.json credential_pool │  │
│  │ deepseek-v4-   │  │ Priority 0: env var      │  │
│  │ flash-free     │  │ Priority 1: key-2 (空)   │  │
│  │                │  │ Priority 2: key-3 (空)   │  │
│  │ provider:      │  │ Priority 3: key-4 (空)   │  │
│  │ opencode-zen   │  └─────────────────────────┘  │
│  └────────────────┘                                │
│                                                   │
│  子进程(terminal/execute_code) → 看不到 env var   │
└─────────────────────────────────────────────────┘
```

---

## 常见误区

- ❌ `has_secret=False` 以为没 key → 实际 key 从 .env 运行时加载
- ❌ 子进程 env 没查到以为没 key → 父进程才有
- ❌ "有三个供应商"以为同时在线 → 不同场景/profile 各自独立，各用各的
- ❌ 以为 credential pool 会自动 failover → 会，但空壳 key 切过去也没用
