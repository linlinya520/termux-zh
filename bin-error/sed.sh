#!/usr/bin/env bash

BIN="$(command -v sed)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "No such file or directory|文件不存在|请检查要处理的文件路径"
  "invalid option|参数错误|请检查 sed 选项是否正确"
  "unterminated|表达式未结束|可能少了引号或分隔符"
  "Permission denied|权限不足|无法修改文件"
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