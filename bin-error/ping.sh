#!/usr/bin/env bash

BIN="$(command -v ping)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "unknown host|无法解析主机名|域名可能错误"
  "Network is unreachable|网络不可达|当前网络不可用"
  "Permission denied|权限不足|可能需要特殊权限"
  "Name or service not known|DNS 解析失败|网络或域名问题"
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