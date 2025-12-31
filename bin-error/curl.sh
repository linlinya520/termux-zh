#!/usr/bin/env bash

BIN="$(command -v curl)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Could not resolve host|无法解析主机名|DNS 解析失败"
  "Connection refused|连接被拒绝|目标服务未运行"
  "Connection timed out|连接超时|网络不通或服务器无响应"
  "SSL certificate problem|SSL 证书问题|证书校验失败"
  "Permission denied|权限不足|无法写入目标文件"
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