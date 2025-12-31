#!/usr/bin/env sh

err=$(/bin/cat "$@" 2>&1 >/dev/null)
ret=$?

if [ $ret -ne 0 ]; then
  case "$err" in
    *"No such file or directory"*)
      echo "错误：文件不存在"
      ;;
    *"Is a directory"*)
      echo "错误：这是一个目录，不能直接查看"
      ;;
    *"Permission denied"*)
      echo "错误：没有读取权限"
      ;;
    *)
      echo "错误：$err"
      ;;
  esac
  exit $ret
fi

exec /bin/cat "$@"