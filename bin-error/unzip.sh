#!/usr/bin/env bash

BIN="$(command -v unzip)"

ERR="$("$BIN" "$@" 2>&1)"
CODE=$?

[ $CODE -eq 0 ] && exit 0
echo "$ERR" >&2

ERROR_MAP=(
  "cannot find or open|找不到压缩包|文件不存在或路径错误"
  "End-of-central-directory signature not found|不是有效的 zip 文件|文件可能损坏或格式不对"
  "Permission denied|权限不足|无法写入目标目录"
  "unsupported compression method|不支持的压缩方式|zip 版本过旧"
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