# Claude Code working rules (fishr)

## Goal: minimize API calls and context bloat

- Prefer ONE request per phase: Design → Implement → Fix failures →
  Polish.
- Do not iterate in tiny steps. Batch edits and run checks once per
  phase.

## Reading files

- NEVER read whole files by default.
- First: use rg to locate symbols. Then read only the smallest necessary
  window (≈ ±80–150 lines).
- If more context is needed, ask explicitly which section to expand.

## Command output

- Do not paste full `R CMD check`, `devtools::check()`, or benchmark
  output into the conversation.
- Only capture and show:
  - ERROR lines
  - WARNING lines
  - the immediate stack/trace context (≤ 60 lines total)
- For benchmarks, report only the summary table / key numbers.

## Edits

- When editing, prefer a single coherent patch that addresses all items
  in the phase.
- After large edits, provide a short “what changed” list + exact files
  touched.

## Tests

- Default: write tests that can run offline where possible
- If a test does require login/network, ensure it is guarded with
  skip_if().

## Checkpoints

Before making edits on a non-trivial refactor, start by producing: 1)
design sketch 2) cache semantics & invalidation plan 3) performance
risks 4) concurrency/locking assumptions 5) test plan Then wait for
confirmation to implement.

## Git workflow

- **Always ask before pushing to master**
- **Feature branches** for: new functions, refactors, bug fixes touching
  multiple files, cache/logic changes, any non-trivial code
- **Direct to master** only for: typo fixes, small doc tweaks, version
  bumps, NEWS, release prep
- Before committing: pause and say “Changes ready for review” so user
  can check RStudio Git pane
- Wait for go-ahead before committing

## R Package Documentation

- For internal/non-exported functions, use `@noRd` in roxygen comments

## Session hygiene

- After completing a subtask, run /compact.
- Between unrelated tasks, run /clear.
