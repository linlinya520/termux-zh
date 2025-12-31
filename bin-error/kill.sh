#!/usr/bin/env bash

BIN="$(command -v kill)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "No such process|进程不存在|PID 不正确或进程已退出"
  "Operation not permitted|权限不足|无法结束该进程"
  "invalid signal|信号无效|信号参数错误"
  "usage: kill|用法错误|参数数量或格式不对"
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