#!/usr/bin/env bash

BIN="$(command -v chmod)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Operation not permitted|操作不被允许|你不是该文件的所有者"
  "Permission denied|权限不足|无法修改权限"
  "Invalid mode|权限格式错误|请检查权限参数"
  "No such file or directory|文件不存在|路径错误"
  "Read-only file system|只读文件系统|无法修改权限"
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