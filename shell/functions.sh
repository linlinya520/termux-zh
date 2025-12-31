#!/data/data/com.termux/files/usr/bin/bash

# ===== 颜色定义 =====
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

# ===== 基础状态 =====

# 进入指定目录
进入() {
    if [ -z "$1" ]; then
        echo -e "${YELLOW}用法: 进入 <目录>${RESET}"
        return 1
    fi
    cd "$1" || {
        echo -e "${RED}目录不存在: $1${RESET}"
        return 1
    }
}

# 返回上级目录
返回() {
    cd ..
}

# 显示当前路径
当前位置() {
    pwd
}

# 显示当前 shell 类型
当前壳() {
    echo "$SHELL"
}

# ===== 作业控制 =====

# 后台执行命令
后台() {
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}用法: 后台 <命令>${RESET}"
        return 1
    fi
    "$@" &
}

# 前台恢复最近的后台作业
前台() {
    fg
}

# 查看后台作业
状态() {
    jobs
}

# ===== 会话控制 =====

# 退出当前 shell
退出() {
    exit 0
}

# 清屏（保留语义，不直接 alias clear）
清屏() {
    clear
}

# 重载 bash 配置
重载配置() {
    source ~/.bashrc
    echo -e "${GREEN}已重载 ~/.bashrc${RESET}"
}

# ===== 路径与环境 =====

# 显示 PATH（按行）
环境() {
    echo "$PATH" | tr ':' '\n'
}

# 显示命令真实路径
在哪() {
    if [ -z "$1" ]; then
        echo -e "${YELLOW}用法: 在哪 <命令>${RESET}"
        return 1
    fi
    command -v "$1"
}

# ===== 快捷操作 =====

# 回到 HOME
回家() {
    cd ~
}

# 进入上一次目录
返回上次() {
    cd - || return 1
}

# ===== 帮助（供自动生成脚本识别） =====

状态型命令列表() {
    echo "进入"
    echo "返回"
    echo "返回上次"
    echo "回家"
    echo "当前位置"
    echo "当前壳"
    echo "后台"
    echo "前台"
    echo "状态"
    echo "清屏"
    echo "环境"
    echo "在哪"
    echo "退出"
    echo "重载配置"
}