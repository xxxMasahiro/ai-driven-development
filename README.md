# AI Driven Development Lesson

AIエージェントと一問一答で進めながら、GitHub設定から小さなタスク管理表の体験開発まで学ぶための教材です。

## Start

```bash
git clone <repository-url>
cd ai-driven-development
./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh
./tools/lesson 現在地
```

最初に読む入口は `index.md` です。

## Layout

```text
$HOME/projects/
├─ ai-driven-development/       lesson repository
└─ task-tracker-repository/     product repository created during the lesson
```

The product repository name and project root can be changed in `lesson/LESSON_CONFIG.tsv`.

## Main Files

```text
index.md                         lesson entry point
github-login-setup-guide.md      GitHub setup lesson
ai-driven-task-tracker-scenario.md  AI-driven development scenario
lesson/LESSON_CONFIG.tsv         configurable repository and file paths
lesson/LESSON_FLOW.tsv           canonical lesson flow
learning/LESSON_STATE.tsv        current lesson state
tools/lesson                     ordered lesson control
tools/learn                      learning progress logging
tools/check_lesson_structure.sh  structure and state validation
tools/check_repository_boundary.sh repository boundary validation
```

## Checks

```bash
./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh
./tools/lesson 現在地
./tools/learn 現在地
```

The Git pre-commit hook runs the structure and repository-boundary checks.

## License

MIT
