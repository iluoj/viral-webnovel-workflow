#!/bin/bash
# viral-webnovel-workflow v2.0 — 新机器一键搭建脚本
# 用法：git clone <repo> && cd viral-webnovel-workflow && bash setup.sh

set -e

echo "========================================"
echo "  网文漫剧团队 — 一键搭建"
echo "========================================"

# 检查 Hermes
if ! command -v hermes &> /dev/null; then
    echo "❌ 未安装 Hermes。请先安装："
    echo "   curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
    exit 1
fi

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "✅ Hermes 已安装"

# 创建7个 profile
for p in webnovel-lead webnovel-planner webnovel-writer webnovel-adapter webnovel-auditor webnovel-prompter webnovel-reviewer; do
    if hermes profile list 2>/dev/null | grep -q "$p"; then
        echo "⚠ $p 已存在，跳过创建"
    else
        echo "→ 创建 $p..."
        hermes profile create "$p" --clone-from viral-webnovel 2>&1 | tail -1
    fi
done

echo ""
echo "✅ 7个 profile 创建完成"

# 复制 SKILL.md
for p in lead planner writer adapter auditor prompter reviewer; do
    dst="$HOME/AppData/Local/hermes/profiles/webnovel-$p/skills/webnovel-$p"
    if [ -d "$dst" ]; then
        cp "$REPO_DIR/profiles/$p/SKILL.md" "$dst/SKILL.md"
        echo "✅ $p: SKILL.md 已更新"
    fi
done

# 复制 reference 文件
declare -A REF_MAP
REF_MAP["planner"]="idea-scoring.md outline-structure.md platform-patterns.md story-bible-template.md"
REF_MAP["writer"]="chapter-template.md diagnose-loop.md memory-system.md rewrite-humanization.md"
REF_MAP["adapter"]="drama-adaptation.md"
REF_MAP["auditor"]="compliance-audit-template.md platform-compliance-2026.md"
REF_MAP["prompter"]="asset-description-format.md camera-shot-selection.md matsuri-director-prompt.md"
REF_MAP["reviewer"]="diagnose-loop.md"

for p in planner writer adapter auditor prompter reviewer; do
    refdir="$HOME/AppData/Local/hermes/profiles/webnovel-$p/skills/webnovel-$p/references"
    mkdir -p "$refdir"
    for f in ${REF_MAP[$p]}; do
        if [ -f "$REPO_DIR/profiles/$p/references/$f" ]; then
            cp "$REPO_DIR/profiles/$p/references/$f" "$refdir/"
            echo "✅ $p: $f"
        fi
    done
done

# 配置 toolset（禁用不必要工具）
echo ""
echo "→ 配置 toolset..."
# lead: 保留 clarify, kanban, file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, web, browser, vision, image_gen]' --profile webnovel-lead  2>/dev/null || true
# planner: 保留 web, clarify, file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, browser, vision, image_gen]' --profile webnovel-planner  2>/dev/null || true
# writer: 只保留 file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, web, browser, vision, image_gen, clarify]' --profile webnovel-writer  2>/dev/null || true
# adapter: 只保留 file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, web, browser, vision, image_gen, clarify]' --profile webnovel-adapter  2>/dev/null || true
# auditor: 只保留 file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, web, browser, vision, image_gen, clarify]' --profile webnovel-auditor  2>/dev/null || true
# prompter: 保留 clarify, file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, web, browser, vision, image_gen]' --profile webnovel-prompter  2>/dev/null || true
# reviewer: 只保留 file, terminal
hermes config set agent.disabled_toolsets '[delegation, cronjob, kanban, web, browser, vision, image_gen, clarify]' --profile webnovel-reviewer  2>/dev/null || true

# 初始化 Kanban（如未初始化）
hermes kanban init 2>/dev/null || true

# 启动 gateway
hermes gateway start 2>/dev/null || true

echo ""
echo "========================================"
echo "  搭建完成！"
echo "========================================"
echo "使用：hermes --profile webnovel-lead"
echo ""
echo "查看 profile 列表："
hermes profile list 2>/dev/null | grep webnovel
