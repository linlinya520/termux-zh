#!/usr/bin/env bash

BIN="$(command -v du)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Permission denied|权限不足|无法读取部分目录"
  "No such file or directory|路径不存在|指定目录不存在"
  "invalid option|参数错误|du 参数不正确"
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