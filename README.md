# tidy-files — 给 Claude Code 用的「整理文件」skill

把散落在桌面、下载夹、文稿夹、iCloud 云盘、家目录各处的文件，按
**一个大文件夹 → 一项目一夹 / 按流程阶段 / 按文件类型 → 小任务或零散件兜底** 的嵌套结构归到一起。
只移动、改名、新建，绝不删除或覆盖；最后写 README 索引并逐夹核对。

这个 skill 是从一次真实的全机整理里提炼出来的：agent 产出（Claude / DeepSeek / Codex）按项目归到 `agent/`，
毕业论文材料按流程归到 `毕业论文/01-选题与开题 … 10-工具安装包`，截图 / 视频 / 安装包这类散件按类型归到 `零散文件/`，云盘里的就地整理。

## 安装

```bash
# 装成个人级 skill（对所有项目生效）
git clone https://github.com/dzs28/tidy-files-skill ~/.claude/skills/tidy-files
```

或者放进某个项目的 `.claude/skills/tidy-files/`。之后在 Claude Code 里说"帮我整理一下桌面 / 把这些文件归纳到一个文件夹"就会触发；也可以直接 `/tidy-files`。

## 里面有什么

```
tidy-files/
├── SKILL.md                 主流程：范围 → 盘点 → 设计并确认 → 只 mkdir/mv 执行 → README → 核对
├── scripts/tidy.sh          source 后可用 mvs（安全移入）、mvr（安全改名）、inv（按扩展名盘点）
└── references/
    ├── pitfalls.md          踩过的坑：写死路径的 launchd / venv / Codex 工作区、iCloud、特殊字符文件名、系统残留……
    └── structures.md        三种结构模式的完整示例 + README 模板
```

## 原则（一句话版）

1. 先盘点、再设计、给用户看一眼、然后才动手。
2. 只 `mkdir` / `mv`；同名撞车进 `重复副本/`，不覆盖；不 `rm`。
3. 路径写死的东西（launchd、`.env`、venv、应用托管工作区）不动，或留替身链接。
4. 每个大文件夹一个 README：子夹 | 里面是什么 | 原来在哪，外加"没收进来的"和"需要你手动做的"。
5. 边界问题一次问完（选项 + 推荐），别按文件名猜内容——看一眼再归。
