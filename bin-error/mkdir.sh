#!/usr/bin/env bash

BIN="$(command -v mkdir)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "File exists|目录已存在|目标目录已经存在"
  "No such file or directory|父目录不存在|请确认上级目录是否存在"
  "Permission denied|权限不足|当前用户没有创建权限"
  "Invalid argument|参数错误|目录名可能不合法"
  "Read-only file system|只读文件系统|该位置不可写"
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