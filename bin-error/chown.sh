#!/usr/bin/env bash

BIN="$(command -v chown)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Operation not permitted|操作不被允许|通常需要 root 权限"
  "invalid user|用户不存在|指定的用户无效"
  "invalid group|用户组不存在|指定的组无效"
  "No such file or directory|文件不存在|路径错误"
  "Permission denied|权限不足|无法修改所有者"
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