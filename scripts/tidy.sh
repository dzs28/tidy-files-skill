#!/bin/zsh
# tidy-files 辅助函数：只移动、不覆盖、不删除。
# 用法：source scripts/tidy.sh   然后在同一个 shell 里调用 mvs / mvr / inv
#
#   mvs <源文件或目录> <目标目录>      把源移进目标目录；目标目录不存在就建；目标里已有同名则 SKIP
#   mvr <源路径> <新路径>              安全改名/移动到指定新路径；新路径已存在则 SKIP
#   inv <目录...>                       按扩展名统计每个目录里的散文件（不递归），帮你盘点
#
# 每一步都会打印 MOVED / SKIP，方便回看和写 README。

mvs() {
  local src="$1" dstdir="$2"
  if [ -z "$src" ] || [ -z "$dstdir" ]; then
    echo "用法: mvs <源> <目标目录>" >&2; return 2
  fi
  if [ ! -e "$src" ]; then
    echo "SKIP(源不存在): $src"; return 0
  fi
  mkdir -p "$dstdir" || return 1
  local base="${src:t}"
  if [ -e "$dstdir/$base" ]; then
    echo "SKIP(目标已存在，请改放 重复副本/): $src  ->  $dstdir/$base"; return 0
  fi
  mv "$src" "$dstdir/" && echo "MOVED: $src  ->  $dstdir/"
}

mvr() {
  local src="$1" dst="$2"
  if [ -z "$src" ] || [ -z "$dst" ]; then
    echo "用法: mvr <源路径> <新路径>" >&2; return 2
  fi
  if [ ! -e "$src" ]; then
    echo "SKIP(源不存在): $src"; return 0
  fi
  if [ -e "$dst" ]; then
    echo "SKIP(新路径已存在): $src  ->  $dst"; return 0
  fi
  mkdir -p "${dst:h}" || return 1
  mv "$src" "$dst" && echo "MOVED: $src  ->  $dst"
}

inv() {
  local d
  for d in "$@"; do
    [ -d "$d" ] || { echo "== $d (不存在)"; continue; }
    echo "== $d"
    # 只看当前层的普通文件，按扩展名计数；目录单独列出
    # macOS 的 sed 里 t/b 标签会吃掉同一行后面的内容，所以用多个 -e 分开写
    find "$d" -mindepth 1 -maxdepth 1 -type f ! -name '.DS_Store' ! -name '.localized' 2>/dev/null \
      | sed -E -e 's/.*\.([A-Za-z0-9]+)$/\1/' -e 't' -e 's/.*/(无扩展名)/' \
      | tr 'A-Z' 'a-z' | sort | uniq -c | sort -rn
    local n
    n=$(find "$d" -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null | wc -l | tr -d ' ')
    echo "   子目录: $n 个"
  done
}
