# Lesson Illustrations

This directory stores reusable educational illustration requests and generated assets.

The CLI entry point is:

```bash
./tools/illustrations list
./tools/illustrations request <step_id> <topic>
```

The agent uses the recorded request to generate a gentle educational PNG illustration with `imagegen`.
Generated assets should be stored under:

```text
illustrations/lesson14/<step_id>/<topic-slug>.png
```

The dashboard reads the same metadata so generated illustrations can be reviewed later.
