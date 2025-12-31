#!/usr/bin/env bash

BIN="$(command -v df)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "No such file or directory|路径不存在|指定的挂载点不存在"
  "Permission denied|权限不足|无法访问该路径"
  "invalid option|参数错误|df 参数不正确"
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