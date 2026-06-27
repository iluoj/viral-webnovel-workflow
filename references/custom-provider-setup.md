# 自定义 Provider 配置流程

> 创建：2026-06-27
> 来源：本 session 中为 planner/scriptwriter/prompter 三个 profile 添加 Gemini 3.1 Pro provider

## 通过 URL 参数访问（如 yunwu.ai、wlai.vip）

### 步骤

1. **添加 custom_providers 条目**：在 profile config.yaml 的 `custom_providers:` 列表末尾插入：

```yaml
- api_key: sk-<your-key>
  api_mode: chat_completions
  base_url: https://<base-url>/v1
  model: <model-name>
  name: <provider-name>
```

2. **切换模型**：

```bash
hermes config set model.default <model-name> --profile <profile>
hermes config set model.provider custom:<provider-name> --profile <profile>
hermes config set model.base_url https://<base-url>/v1 --profile <profile>
```

3. **如果改 URL**，需要同时更新 model 区和 custom_providers 区两处 base_url。

### 本 session 配置记录

| 参数 | 值 |
|------|-----|
| 初始 URL | https://api3.wlai.vip |
| 最终 URL | https://yunwu.ai |
| API key | sk-m7a...ABbd |
| 模型名 | gemini-3.1-pro-preview |
| provider 名 | gemini-wlai |
| 应用 profile | webnovel-planner, webnovel-scriptwriter, webnovel-prompter |

### Pitfall

- `model.base_url` 和 `custom_providers[].base_url` 是两个独立字段，改 URL 时必须两处都改
- YAML 缩进敏感：custom_providers 条目的缩进必须与已有条目一致（本案例为 2 空格）
- api_key 中包含 `...` 省略号不要出现在实际配置中
