# 测试

- `evals.json`：3 个测试用例（按项目归纳 agent 产出 / 按流程归纳论文 / 按类型归纳散件），每个带可核对的期望。
- `files/make_fixture.sh <目录>`：生成一份"乱桌面"沙盒（桌面/ 下载/ 文稿/ 三个夹、30 来个假文件，含同名撞车、URL 编码名、Word 锁文件、应用托管的空会话夹）。
- `files/check_fixture.sh <目录>`：跑完后自动核对——文件一个没少、同名不同内容的两份都在、新建了 README。
- `trigger-eval.json`：20 条"该触发 / 不该触发"的提示词，给 skill-creator 的描述优化循环用。
- `workspace/`（gitignored）：每次跑测试的沙盒和结果。

跑法（用 skill-creator）：对每个用例，先 `make_fixture.sh workspace/iteration-1/eval-N/with_skill/sandbox`，把提示词里的 `<SANDBOX>` 换成这个路径，让带 skill 的 Claude 跑一遍；同样再跑一份不带 skill 的做基线；最后 `check_fixture.sh` 核对并按 expectations 打分。
