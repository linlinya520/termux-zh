#!/usr/bin/env bash

BIN="$(command -v rm)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0

echo "$ERR" >&2

ERROR_MAP=(
  "Is a directory|这是一个目录|rm 默认只能删除文件，可使用 rm -rf 删除目录"
  "No such file or directory|文件或目录不存在|请检查路径是否正确"
  "Permission denied|权限不足|当前用户没有删除权限"
  "Directory not empty|目录非空|rm 无法删除非空目录"
  "Operation not permitted|操作不被允许|目标可能被系统保护"
  "Read-only file system|只读文件系统|该位置不允许删除"
  "Device or resource busy|资源正被占用|文件正在被使用"
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