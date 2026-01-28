#!/usr/bin/env bash

BIN="$(command -v awk)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "No such file or directory|文件不存在|输入文件路径错误"
  "syntax error|语法错误|awk 表达式写错"
  "Permission denied|权限不足|无法读取文件"
)

for r in "${ERROR_MAP[@]}"; do
  IFS='|' read -r p z t <<<"$r"
  if echo "$ERR" | grep -q "$p"; then
    echo "❌ $z"
    [ -n "$t" ] && echo "ℹ $t"
    break
  fi
done

exit $CODE