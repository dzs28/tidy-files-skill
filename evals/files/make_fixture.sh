#!/bin/zsh
# 生成一个"乱桌面"沙盒，用来测试 tidy-files。
# 用法：zsh make_fixture.sh <目标目录>     会在目标目录下建 桌面/ 下载/ 文稿/ 三个夹和一堆假文件
set -e
ROOT="${1:?用法: make_fixture.sh <目标目录>}"
mkdir -p "$ROOT"
cd "$ROOT"

mk() { # mk <路径> <内容>
  mkdir -p "${1:h}"
  print -r -- "$2" > "$1"
}

# ---- 桌面：agent 做的项目、散件、截图、别人的资料混在一起 ----
mk "桌面/截屏2026-07-14 18.26.36.png"      "PNG dummy"
mk "桌面/截屏2026-07-20 12.00.27.png"      "PNG dummy"
mk "桌面/微信图片_20260319165719.jpg"      "JPG dummy (豆瓣短评截图)"
mk "桌面/speedtest.py"                     "#!/usr/bin/env python3\nprint('speed')"
mk "桌面/网速测试.html"                     "<html>speed</html>"
mk "桌面/ym.html"                          "<html>hi</html>"
mk "桌面/报告初稿.docx"                     "DOCX dummy v1"
mk "桌面/报告终稿.docx"                     "DOCX dummy final (桌面版)"
mk "桌面/播出时间.xlsx"                     "XLSX dummy"
mk "桌面/stock-tool/server.js"             "// stock tool server (launchd 常驻, 路径写死)"
mk "桌面/stock-tool/README.md"             "# stock-tool"
mk "桌面/diet-miniapp/app.js"              "// miniapp"
mk "桌面/开题报告/邓某某开题报告.docx"        "DOCX dummy"
mk "桌面/开题报告/~\$邓某某开题报告.docx"     "word lock file"
mk "桌面/毕业设计/毕业论文1.docx"            "DOCX v1"
mk "桌面/毕业设计/毕业论文2.docx"            "DOCX v2"
mk "桌面/毕业设计/files/图3.1_流程图.png"    "PNG dummy"

# ---- 下载夹：重复文件、URL 编码名、安装包、别处的项目副本 ----
mk "下载/报告终稿.docx"                     "DOCX dummy final (下载版, 大小不同)"
mk "下载/%E5%85%B3%E4%BA%8E%E9%80%9A%E7%9F%A5.pdf"  "PDF dummy (URL 编码文件名 = 关于通知.pdf)"
mk "下载/setup.dmg"                        "DMG dummy"
mk "下载/参考文献1.pdf"                     "PDF dummy"
mk "下载/参考文献2.pdf"                     "PDF dummy"
mk "下载/IMG_0215.PNG"                     "PNG dummy (手机截图)"
mk "下载/Video-1786017392956.mp4"          "MP4 dummy"
mk "下载/2026060808185641292977/查重_简洁报告.pdf"  "PDF dummy"
mk "下载/2026060808185641292977/报告说明.txt"      "报告说明"
mk "下载/stock-tool-旧版/server.js"         "// old copy"

# ---- 文稿夹：应用托管的工作区 ----
mk "文稿/Codex/2026-07-14/bang/outputs/survey.html"   "<html>survey</html>"
mk "文稿/Codex/2026-07-14/bang/work/notes.md"         "notes"
mk "文稿/Codex/2026-07-28/xani/outputs/.keep"         ""
mk "文稿/Codex/2026-07-28/xani/work/.keep"            ""

# 记录初始清单，供测试后比对（任何文件都不该消失）
find . -type f ! -name '.DS_Store' ! -name '.fixture_manifest.txt' | sort > "$ROOT/.fixture_manifest.txt"
echo "fixture 已生成于 $ROOT，共 $(wc -l < "$ROOT/.fixture_manifest.txt" | tr -d ' ') 个文件（清单在 .fixture_manifest.txt）"
