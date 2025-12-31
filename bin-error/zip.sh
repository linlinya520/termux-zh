#!/usr/bin/env bash

BIN="$(command -v zip)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Nothing to do|没有可压缩的文件|未匹配到任何文件"
  "Permission denied|权限不足|无法读取或写入文件"
  "Invalid command arguments|参数错误|请检查 zip 参数"
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