#!/usr/bin/env bash

BIN="$(command -v grep)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "No such file or directory|文件不存在|请检查路径"
  "Is a directory|目标是目录|grep 不能直接搜索目录"
  "invalid option|参数错误|请检查选项是否正确"
  "Binary file|二进制文件|该文件不是纯文本"
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