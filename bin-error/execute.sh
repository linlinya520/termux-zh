#!/usr/bin/env bash

BIN_BASH="$(command -v bash)"
BIN_PY="$(command -v python 2>/dev/null || true)"

SCRIPT="$1"
shift || true

# ---------- 参数检查 ----------
if [ -z "$SCRIPT" ]; then
  echo "❌ 未指定要执行的脚本" >&2
  echo "ℹ 用法示例：执行 test.sh" >&2
  exit 1
fi

if [ ! -e "$SCRIPT" ]; then
  echo "❌ 文件不存在：$SCRIPT" >&2
  exit 1
fi

if [ -d "$SCRIPT" ]; then
  echo "❌ 目标是目录，无法执行" >&2
  echo "ℹ 执行命令只能用于脚本文件" >&2
  exit 1
fi

# ---------- 自动选择解释器 ----------
case "$SCRIPT" in
  *.py)
    [ -z "$BIN_PY" ] && {
      echo "❌ 未找到 python 解释器" >&2
      exit 127
    }
    BIN="$BIN_PY"
    ;;
  *)
    BIN="$BIN_BASH"
    ;;
esac

# ---------- 尝试执行 ----------
ERR="$("$BIN" "$SCRIPT" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0

# 先输出原始英文错误
echo "$ERR" >&2

# ---------- 中文错误解释 ----------
ERROR_MAP=(
  "Permission denied|权限不足|文件没有执行或读取权限，可尝试 chmod +x 文件名"
  "No such file or directory|文件不存在|脚本或其内部引用的文件不存在"
  "command not found|命令不存在|脚本中使用了系统中不存在的命令"
  "SyntaxError|语法错误|Python 脚本存在语法问题"
  "IndentationError|缩进错误|Python 缩进不正确"
  "unexpected token|语法错误|Shell 脚本语法可能写错"
  "bad interpreter|解释器错误|shebang 指向了不存在的解释器"
  "Exec format error|文件格式错误|该文件不是可执行脚本"
)

for r in "${ERROR_MAP[@]}"; do
  IFS='|' read -r p z t <<<"$r"
  if echo "$ERR" | grep -q "$p"; then
    echo "❌ $z" >&2
    [ -n "$t" ] && echo "ℹ $t" >&2
    break
  fi
done

exit $CODE