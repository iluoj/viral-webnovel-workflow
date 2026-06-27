# 多 Profile 模型分配策略

> 基于 2026年6月主流模型实测 + 6-profile 创作流水线任务特征
> ⚠️ **2026-06-27 更新：全部 profile 已切换为 deepseek-v4-flash（成本原因）**
> 原方案中 planner/scriptwriter/prompter 使用 Gemini 3.1 Pro，经实测 deepseek-v4-flash 质量差距极小，成本降低显著。以下保留原方案作参考，实际以当前配置为准。

| Profile | 当前模型 | 历史模型 | 原因 |
|---------|---------|---------|------|
| **全部6个profile** | **deepseek-v4-flash** | ~~Gemini 3.1 Pro~~ | 实测质量差距极小，成本从¥X降至免费 |

## 模型切换命令

```bash
# 检查当前配置
hermes config show model --profile <profile名>

# 切换模型
hermes config set model.default <模型名> --profile <profile名>
hermes config set model.provider <provider名> --profile <profile名>
```

## 注意事项

- **deepseek-v4-flash 通过 opencode-go provider 使用，零成本**
- 跨 profile 切换模型时，确保对应 provider 已在目标 profile 的 config 中配置
- 如未来需要升级模型，优先考虑 deepseek-v4-pro（中文创意更强）
