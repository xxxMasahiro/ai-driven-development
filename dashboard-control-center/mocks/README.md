# Dashboard Control Center Mocks

This directory stores dashboard-control-center visual references.

- Current source-of-truth mocks live directly in this directory.
- Older mock references live in `archive/`.
- Runtime UI must treat the current `mock-context-*.png` files as visual source references for layout, density, color direction, icon shape, icon fill/transparent treatment, and content amount.
- These images are not pixel-perfect automated test oracles; tests should verify structure, safety, data ownership, localization, and responsive behavior.
