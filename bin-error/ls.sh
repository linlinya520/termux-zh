#!/usr/bin/env sh

err=$(/bin/ls "$@" 2>&1 >/dev/null)
ret=$?

if [ $ret -ne 0 ]; then
  case "$err" in
    *"No such file or directory"*)
      echo "错误：路径不存在"
      ;;
    *"Permission denied"*)
      echo "错误：没有权限访问该目录"
      ;;
    *)
      echo "错误：$err"
      ;;
  esac
  exit $ret
fi

exec /bin/ls "$@"