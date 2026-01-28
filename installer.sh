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

echo "📦 安装 $PROJECT_NAME"

# ===== 0️⃣ 创建目录 =====
mkdir -p "$BIN_DIR" "$BIN_ERR_DIR"

# ===== 1️⃣ 安装 bin =====
for f in bin/*; do
    name="$(basename "$f")"
    cp "$f" "$BIN_DIR/$name"
    chmod +x "$BIN_DIR/$name"
    echo "安装命令：$name"
done

# ===== 2️⃣ 安装 bin-error =====
if [ -d bin-error ]; then
    cp bin-error/*.sh "$BIN_ERR_DIR/" 2>/dev/null || true
    chmod +x "$BIN_ERR_DIR/"*.sh 2>/dev/null || true
    echo "安装 bin-error"
fi

# ===== 3️⃣ 安装 functions =====
cp shell/functions.sh "$FUNC_FILE"
chmod +x "$FUNC_FILE"
echo "安装状态型命令"

# ===== 4️⃣ 注入 PATH =====
if ! grep -q "$PATH_BEGIN" "$PROFILE" 2>/dev/null; then
    {
        echo ""
        echo "$PATH_BEGIN"
        echo 'export PATH="$HOME/.termux-zh/bin:$PATH"'
        echo "$PATH_END"
    } >> "$PROFILE"
    echo "✅ PATH 已注入"
else
    echo "ℹ️ PATH 已存在"
fi

# ===== 5️⃣ 注入 functions =====
if ! grep -q "$FUNC_MARK" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "$FUNC_MARK"
        echo 'source "$HOME/.termux-zh/functions.sh"'
    } >> "$BASHRC"
    echo "✅ functions 已注入"
else
    echo "ℹ️ functions 已存在"
fi

# ===== 5.5️⃣ 注入 PATH 到 bashrc（解决非登录 shell 路径问题） =====
BASHRC_PATH_MARK="# termux-zh PATH"
if ! grep -q "$BASHRC_PATH_MARK" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "$BASHRC_PATH_MARK"
        echo 'export PATH="$HOME/.termux-zh/bin:$PATH"'
    } >> "$BASHRC"
    echo "✅ PATH 已注入 bashrc"
else
    echo "ℹ️ PATH 已存在于 bashrc"
fi

# ===== 6️⃣ 尝试刷新 bash 命令缓存 =====
hash -r 2>/dev/null || true

echo ""
echo "🎉 安装完成"
echo ""
echo "⚠️ 注意：当前 shell 可能仍存在命令缓存（bash hash 机制）"
echo "👉 请执行以下任一操作以确保中文命令立即可用："
echo "   1) source ~/.profile"
echo "   2) 手动执行：hash -r"
echo "   3) 重新打开终端（最可靠）"
echo ""
echo "🔍 示例：列出 /"