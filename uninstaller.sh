#!/usr/bin/env bash
set -e

PROJECT_NAME="termux-zh"
HOME_LIB="$HOME/.termux-zh"

BIN_DIR="$HOME_LIB/bin"
BIN_ERR_DIR="$HOME_LIB/bin-error"
FUNC_FILE="$HOME_LIB/functions.sh"

PATH_BEGIN="# termux-zh PATH begin"
PATH_END="# termux-zh PATH end"
FUNC_MARK="# termux-zh functions"

PROFILE="$HOME/.profile"
BASHRC="$HOME/.bashrc"

echo "🧹 卸载 $PROJECT_NAME"

# ===== 1️⃣ 删除本项目安装的 bin 命令（按仓库清单）=====
if [ -d "$BIN_DIR" ]; then
    for f in bin/*; do
        name="$(basename "$f")"
        if [ -f "$BIN_DIR/$name" ]; then
            rm -f "$BIN_DIR/$name"
            echo "删除命令：$name"
        fi
    done
fi

# ===== 2️⃣ 删除 bin-error（整个目录属于项目）=====
if [ -d "$BIN_ERR_DIR" ]; then
    rm -rf "$BIN_ERR_DIR"
    echo "删除：$BIN_ERR_DIR"
fi

# ===== 3️⃣ 删除 functions =====
if [ -f "$FUNC_FILE" ]; then
    rm -f "$FUNC_FILE"
    echo "删除：$FUNC_FILE"
fi

# ===== 4️⃣ 清理 PATH =====
if [ -f "$PROFILE" ] && grep -q "$PATH_BEGIN" "$PROFILE"; then
    sed -i "/$PATH_BEGIN/,/$PATH_END/d" "$PROFILE"
    echo "清理 PATH"
fi

# ===== 5️⃣ 清理 bashrc functions =====
if [ -f "$BASHRC" ] && grep -q "$FUNC_MARK" "$BASHRC"; then
    sed -i "/$FUNC_MARK/d" "$BASHRC"
    sed -i "/\\.termux-zh\\/functions\\.sh/d" "$BASHRC"
    echo "清理 functions"
fi

# ===== 6️⃣ 刷新 bash 命令缓存（对子 shell 有效）=====
hash -r 2>/dev/null || true

echo ""
echo "🎉 卸载完成"
echo "⚠️ 请执行以下任一操作以完全生效："
echo "   source ~/.profile"
echo "   或重新打开终端"
echo "   或手动执行：hash -r"