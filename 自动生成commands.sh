#!/usr/bin/env bash

# 自动生成 COMMANDS.md
# 基于 bin/ 和 shell/functions.sh

ROOT_DIR="$(pwd)"
BIN_DIR="$ROOT_DIR/bin"
FUNC_FILE="$ROOT_DIR/shell/functions.sh"
OUT_FILE="$ROOT_DIR/COMMANDS.md"

echo "生成 COMMANDS.md ..."

cat > "$OUT_FILE" <<'EOF'
# 中文命令列表（COMMANDS）

本文件由脚本自动生成，请勿手动修改。

---

## 一、脚本型命令（全局可用）

这些命令位于 `bin/` 目录，可在任意路径直接执行。

EOF

# ===== 脚本型命令 =====
if [ -d "$BIN_DIR" ]; then
  ls "$BIN_DIR" | sort | while read -r cmd; do
    [ -z "$cmd" ] && continue
    echo "- \`$cmd\`" >> "$OUT_FILE"
  done
else
  echo "_未找到 bin 目录_" >> "$OUT_FILE"
fi

cat >> "$OUT_FILE" <<'EOF'

## 说明

- 脚本型命令：可直接执行，不影响 shell 状态
- 所有命令均不覆盖英文原生命令
- 实际行为以脚本实现为准

EOF

echo "✅ COMMANDS.md 已生成"
