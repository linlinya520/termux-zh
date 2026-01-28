#!/usr/bin/env bash

BIN="$(command -v tar)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "Cannot open|无法打开文件|压缩包不存在或路径错误"
  "Error is not recoverable|压缩包损坏|文件可能不完整"
  "Unknown compression format|未知压缩格式|格式不受支持"
  "Permission denied|权限不足|无法读写文件"
  "Unexpected EOF|文件提前结束|压缩包可能损坏"
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