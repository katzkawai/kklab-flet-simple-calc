# Repository Guidelines

## Project Structure & Module Organization

This is a small Flet calculator app. The application source lives in `main.py`, including custom button controls and calculator state logic. Project metadata and dependencies are in `pyproject.toml`; locked versions are in `uv.lock`. `README.md` documents local usage and GitHub Pages deployment, while `TUTORIAL.md` contains tutorial notes. Generated output belongs in `build/`, and virtual environments belong in `.venv/`; neither should be committed.

## Build, Test, and Development Commands

- `uv sync`: install project and development dependencies from `pyproject.toml` and `uv.lock`.
- `uv run flet run`: run the calculator locally as a desktop Flet app.
- `uv run flet build web --base-url /kklab-flet-simple-calc/ --exclude .venv build .git`: build the web app for GitHub Pages under `build/web`.
- `./deploy.sh`: build and force-publish `build/web` to the `gh-pages` branch. Use this as the preferred deployment command.

## Coding Style & Naming Conventions

Use standard Python style with 4-space indentation and descriptive `snake_case` names for functions, methods, and variables. Use `PascalCase` for Flet control classes such as `CalculatorApp`, `DigitButton`, and `ActionButton`. Group related rows and buttons together. No formatter or linter is configured, so match the existing `main.py` style and avoid broad rewrites.

## Testing Guidelines

There is no automated test suite configured yet. For now, verify behavior manually with `uv run flet run`, checking digit entry, decimal input, `AC`, sign toggle, percent, arithmetic operations, equals, and division by zero. If adding tests, place them under `tests/` with names like `test_calculator_logic.py`; add the test dependency before relying on `uv run pytest`.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, sentence-case messages such as `Brighten calculator UI with a light color scheme`. Follow that pattern and keep each commit focused. Pull requests should include a concise description, manual test notes, deployment impact, and screenshots or screen recordings for visible UI changes.

## Deployment & Configuration Notes

GitHub Pages depends on the repository-specific base URL `/kklab-flet-simple-calc/`. If the repository name changes, update both `deploy.sh` and README deployment examples. Do not include `.venv`, `.git`, or previous `build` output in web builds.

## Agent-Specific Instructions

Keep repository guidance in this `AGENTS.md`. Do not commit personal Codex skill or plugin suppression settings here, especially absolute paths under `~/.codex` or `~/.agents`. If Codex reports shortened skill descriptions, tune user-level `~/.codex/config.toml` and restart Codex rather than adding machine-local settings to the repo.
