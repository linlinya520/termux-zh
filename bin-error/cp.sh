#!/usr/bin/env bash

BIN="$(command -v cp)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0

echo "$ERR" >&2

ERROR_MAP=(
  "No such file or directory|源文件或目标路径不存在|请检查路径"
  "Permission denied|权限不足|当前用户没有读或写权限"
  "Is a directory|目标是目录|可能缺少 -r 参数"
  "omitting directory|跳过目录|cp 默认不会复制目录"
  "File exists|目标文件已存在|可确认是否覆盖"
  "Operation not permitted|操作不被允许|可能被系统限制"
  "Read-only file system|只读文件系统|目标位置不可写"
)

for rule in "${ERROR_MAP[@]}"; do
  IFS='|' read -r pat zh tip <<< "$rule"
  if echo "$ERR" | grep -q "$pat"; then
    echo "❌ $zh"
    [ -n "$tip" ] && echo "ℹ $tip"
    break
  fi
done

exit $CODE