#!/data/data/com.termux/files/usr/bin/bash
set -e

# ==============================
# 自动生成 中文 → 英文 对照表
# 只扫描 bin/
# 自动隐藏 bin-error 实现路径
# ==============================

ROOT="$(pwd)"
BIN="$ROOT/bin"
OUT="$ROOT/mapping.txt"

# ===== 颜色 =====
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${YELLOW}生成中文 → 英文 对照表 ...${RESET}"

# ===== 写入头部 =====
cat > "$OUT" <<'EOF'
# 中文命令 → 英文命令
#
# 本文件由脚本自动生成，请勿手动修改
#
# 说明：
# - 仅描述“语义映射”，不暴露实现路径
# - 若内部使用 bin-error 包装器，将自动还原为原始英文命令

## 脚本型命令
EOF

# ===== 扫描 bin =====
for f in "$BIN"/*; do
    [ ! -f "$f" ] && continue

    name="$(basename "$f")"

    # 取最后一行真实执行命令
    cmd=$(
        tail -n 1 "$f" \
        | sed -E 's/^\s*exec\s+//' \
        | sed -E 's/\s*"\$@"\s*$//' \
        | sed 's/^\s*//;s/\s*$//'
    )

    # 兜底
    [ -z "$cmd" ] && cmd="(内部脚本)"

    # ==============================
    # bin-error 路径语义还原
    # ==============================
    # 例：
    # /data/data/.../bin-error/rm.sh  -> rm
    # ../bin-error/cp.sh              -> cp
    if [[ "$cmd" =~ bin-error/([a-zA-Z0-9._-]+)\.sh ]]; then
        cmd="${BASH_REMATCH[1]}"
    fi

    # 输出
    echo -e "${GREEN}${name}${RESET} ${YELLOW}->${RESET} ${GREEN}${cmd}${RESET}" >> "$OUT"
done

echo -e "${GREEN}✅ mapping.txt 已生成${RESET}"