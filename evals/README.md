# 测试

- `evals.json`：3 个测试用例（按项目归纳 agent 产出 / 按流程归纳论文 / 按类型归纳散件），每个带可核对的期望。
- `files/make_fixture.sh <目录>`：生成一份"乱桌面"沙盒（桌面/ 下载/ 文稿/ 三个夹、30 来个假文件，含同名撞车、URL 编码名、Word 锁文件、应用托管的空会话夹）。
- `files/check_fixture.sh <目录>`：跑完后自动核对——文件一个没少、同名不同内容的两份都在、新建了 README。
- `trigger-eval.json`：20 条"该触发 / 不该触发"的提示词，给 skill-creator 的描述优化循环用。
- `workspace/`（gitignored）：每次跑测试的沙盒和结果。

跑法（用 skill-creator）：对每个用例，先 `make_fixture.sh workspace/iteration-1/eval-N/with_skill/sandbox`，把提示词里的 `<SANDBOX>` 换成这个路径，让带 skill 的 Claude 跑一遍；同样再跑一份不带 skill 的做基线；最后 `check_fixture.sh` 核对并按 expectations 打分。

## 已跑过的结果

- **沙盒用例**（2026-08-16，3 个用例 22 条断言）：全部通过——文件零丢失、撞名双份保留、URL 编码名改回中文、锁文件保留、无关文件不误收、README 齐全。
- **触发词评测**（2026-08-20，skill-creator 描述优化循环，20 条 × 3 次 × 3 轮，sonnet）：**现用描述就是三轮里的最优**（两版 AI 改写一版持平一版更差，故未改动）。检验集 6/8：误触发 0（15 条反例 × 3 次无一命中），漏触发集中在"headless `claude -p` 觉得自己直接能干就不查 skill"的场景（如"把下载归一下类：安装包、pdf、图片各放一个文件夹"）；实际在 Claude Code 应用里触发率高于此数。
- 注意：跑触发评测时**不要在家目录当项目根**——若 `~/.claude/settings.json` 里有改路由的 env，会把评测的 `claude -p` 全部劫持成 401，得出全 0 触发的假结果。换一个带空 `.claude/` 的干净目录做 cwd。
