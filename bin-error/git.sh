#!/usr/bin/env bash

BIN="$(command -v git)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "not a git repository|不是 Git 仓库|请先进入仓库目录"
  "failed to push|推送失败|可能需要先拉取"
  "Authentication failed|认证失败|请检查账号或密钥"
  "nothing to commit|没有可提交内容|工作区未修改"
  "could not resolve host|无法连接服务器|请检查网络"
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