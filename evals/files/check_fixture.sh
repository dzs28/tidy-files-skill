#!/bin/zsh
# 测试后自动核对：没有文件丢失、没有文件被覆盖，并打印新结构。
# 用法：zsh check_fixture.sh <沙盒目录>
ROOT="${1:?用法: check_fixture.sh <沙盒目录>}"
cd "$ROOT" || exit 1
MAN="$ROOT/.fixture_manifest.txt"
[ -f "$MAN" ] || { echo "找不到 $MAN，先用 make_fixture.sh 生成沙盒"; exit 1; }
rc=0

# 原始文件的 mtime 都早于清单文件；整理只是 mv（不改 mtime），所以"不比清单新"的文件 = 原始文件
before=$(wc -l < "$MAN" | tr -d ' ')
after=$(find . -type f ! -name '.DS_Store' ! -name '.fixture_manifest.txt' ! -newer "$MAN" | wc -l | tr -d ' ')
echo "原始文件数：整理前 $before，整理后 $after"
if [ "$after" -lt "$before" ]; then
  echo "FAIL: 有 $((before-after)) 个原始文件消失（被删除或被覆盖）"; rc=1
else
  echo "PASS: 文件一个没少"
fi

# 同名撞车检查：桌面版和下载版的 报告终稿.docx 内容不同，整理后应各自存在
n=$(grep -rl "DOCX dummy final" . 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -ge 2 ]; then echo "PASS: 两份不同内容的 报告终稿.docx 都还在（$n 份）"; else echo "FAIL: 报告终稿.docx 只剩 $n 份，可能被覆盖"; rc=1; fi

# 新建的 README 索引（比清单新的 README.md）
if find . -name 'README.md' -newer "$MAN" | grep -q .; then echo "PASS: 新建了 README 索引"; else echo "FAIL: 没有新建 README 索引"; rc=1; fi

# 新建的文件里有没有非 README 的东西（cp 出来的副本会在这里暴露）
extra=$(find . -type f -newer "$MAN" ! -name 'README.md' ! -name '.DS_Store' | wc -l | tr -d ' ')
if [ "$extra" -eq 0 ]; then echo "PASS: 除 README 外没有新建/复制文件"; else echo "WARN: 有 $extra 个 README 以外的新文件（可能 cp 出了副本）"; find . -type f -newer "$MAN" ! -name 'README.md' ! -name '.DS_Store'; fi

echo "---- 整理后的结构（前 80 行）----"
find . -not -path '*/.*' | sort | head -80
exit $rc
