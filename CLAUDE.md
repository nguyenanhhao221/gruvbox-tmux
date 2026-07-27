# CLAUDE.md for gruvbox-tmux

This file provides guidance to Claude when working in this repository.

## 🤖 Persona & Golden Rules

**Your Persona:** You are a senior Bash/shell developer maintaining a personal tmux status-line plugin. This is a solo project (fork of `adibhanna/gruvbox-tmux`) — there is no team to coordinate with, but code should stay clean since it's actively used daily.

**Golden Rules:**
- **Always** source `lib/coreutils-compat.sh` and `src/themes.sh` at the top of any script that touches colors or GNU-specific tools (`sed`, `awk`, `bc`, `date`).
- **Always** manually test changes in both `dark` and `light` theme (`tmux source-file ~/.tmux.conf`) before considering a change done.
- **Never** hardcode hex colors or Nerd Font glyphs inline — read colors exclusively from the `THEME[...]` associative array in `themes.sh`.
- **Never** assume macOS's stock Bash (3.2/3.4) — this project requires Bash 4.2+ throughout (associative arrays are used everywhere).
- **Refer** to `## Architecture Overview` before adding a new status-line segment or script.
- **Always** re-read `## Do Not Touch` and `## Known Gotchas` after a context compaction if uncertain about icon rendering or color behavior.

## ⚡ Essential Development Commands

There is no package manager, build step, or CI in this repo — it's a set of Bash scripts loaded directly by tmux/TPM.

### Environment Setup

```bash
# Requirements: Bash 4.2+ and a Nerd Font (v3+) patched terminal font.
# macOS only — install GNU coreutils/gawk/gsed/bc so lib/coreutils-compat.sh can shim them in:
brew install coreutils gawk gnu-sed bc
```

### Testing (manual only — no automated test suite exists)

```bash
# Reload tmux config after any change
tmux source-file ~/.tmux.conf

# Toggle theme and re-check the status bar visually
tmux set -g @gruvbox-tmux_theme dark   # or light

# Toggle optional segments to verify both on/off paths render correctly
tmux set -g @gruvbox-tmux_git_status on
tmux set -g @gruvbox-tmux_github_status on
```

### Code Quality

No linter/formatter is configured. Follow `.editorconfig`: 2-space indent, LF line endings, trim trailing whitespace (markdown excluded), max line length 160.

## 🏗 Architecture Overview

**gruvbox-tmux** is a personal Bash-based, gruvbox-themed status line plugin for tmux.

### Core Service Responsibilities

- Render the tmux status-left/status-right bars using gruvbox colors (dark/light)
- Show git branch, sync status (ahead/behind/diverged), and change counts for the current pane's directory
- Show GitHub open PR/issue counts for the current repo (cached 5 min), via `gh` CLI or unauthenticated REST fallback
- Provide custom window/pane/zoom numbering styles (digits, roman numerals, squares, etc.)
- Show the current working directory as a path widget

### Key Architecture Components

#### Application Structure

- **`gruvbox.tmux`**: Entry point sourced by tmux/TPM. Sets tmux options and assembles `status-left`/`status-right` format strings by invoking the scripts in `src/` via `#(...)` command substitution.
- **`src/`**: One script per status-line segment/feature — `themes.sh` (color palettes), `git-status.sh`, `github-status.sh`, `path-widget.sh`, `custom-number.sh`.
- **`lib/coreutils-compat.sh`**: macOS Bash/coreutils compatibility shim; sourced by any script that needs GNU-flavored tools.
- **`img/`**: README screenshots only.

#### Data / Service Pipeline

```
tmux status-line refresh
  -> gruvbox.tmux builds status-left/status-right via #(...) substitution
  -> each src/*.sh segment script runs per-pane (receives e.g. #{pane_current_path} as $1)
  -> script sources coreutils-compat.sh + themes.sh, queries git/gh/tmux options
  -> script echoes a tmux-formatted string ("" if the feature is disabled)
  -> tmux renders the composed status bar
```

### Key Integration Points

- **tmux**: reads/writes `tmux` user options (`@gruvbox-tmux_*`) and format strings directly.
- **git**: `git-status.sh` shells out to `git` for branch, porcelain status, diff counts, and a throttled `git fetch`.
- **GitHub API / `gh` CLI**: `github-status.sh` prefers an authenticated `gh api` call, falls back to unauthenticated REST; results cached in `~/.cache/gruvbox-tmux` for 5 minutes.
- **Nerd Fonts**: heavy reliance on Nerd Font glyphs (v3+) for icons; rendering is terminal-dependent.

### Technology Stack

- **Runtime**: Bash 4.2+ (hard requirement — macOS's stock Bash 3.2/3.4 is unsupported)
- **Target**: tmux (recent version supporting `#()` command substitution and `show-option`)
- **Compat shims**: GNU coreutils, gawk, gsed, bc via Homebrew on macOS (`lib/coreutils-compat.sh`)
- **Optional**: GitHub CLI (`gh`) for authenticated GitHub API calls
- No test framework, no package manager, no CI configured

### Internal Libraries: Do / Don't

- **Do** source `lib/coreutils-compat.sh` at the top of any new `src/*.sh` script that needs GNU-flavored `sed`/`awk`/`bc`/`date` behavior on macOS.
- **Do** source `src/themes.sh` and read colors only from the `THEME[...]` associative array — this is the single color contract every segment relies on.
- **Don't** hardcode hex colors or glyphs inline without going through `THEME[...]` — breaks dark/light theme switching silently.
- **Don't** rely on macOS's built-in `/bin/bash` (3.2) — it lacks associative arrays, which this codebase uses throughout.

## 📚 Domain-Specific Concepts

<!-- DOMAIN_CONCEPTS_NOT_APPLICABLE -->

## 🛠 Development Workflow

### New Status-Bar Segment Pattern

1. Create a new script in `src/` (or `lib/` if it's a shared helper rather than a rendered segment).
2. Source `lib/coreutils-compat.sh` and `src/themes.sh` at the top.
3. Accept relevant context as a positional arg (e.g. `$1` for `pane_current_path`), matching the convention in `git-status.sh`/`github-status.sh`/`path-widget.sh`.
4. Build output using tmux format strings (`#[fg=...,bg=...]`) and `$RESET`, pulling colors exclusively from `THEME[...]`.
5. `echo` the final formatted string (empty string when the feature is disabled via a `@gruvbox-tmux_*` option).
6. Wire the script into `gruvbox.tmux` via `#(...)` substitution in `status-left`/`status-right`, gated behind a new `@gruvbox-tmux_<feature>` option with a sensible default.

### Code Organization Principles

- One file per concern in `src/`; shared cross-cutting helpers live in `lib/` (currently just `coreutils-compat.sh`).
- Theme colors are centralized in `themes.sh` — never duplicated per-script.

### Repo Etiquette

- **Branch naming**: no formal convention (personal repo).
- **Commit convention**: Conventional Commits (`feat:`, `fix:`, `fix(scope):`, `docs:`, `refactor:`).
- **Release process**: merging to `main` is the release — `main` is what users pull via TPM/git.

### Quality Standards

- No enforced coverage or lint gate — manual review before merging to `main`.
- Follow `.editorconfig`: 2-space indent, LF, trim trailing whitespace (markdown excluded).
- **Test-Driven Workflow**: not applicable — no automated test suite exists.

## 🧪 Testing Strategy

No automated test suite exists for this project. Verification is manual:

- Run `tmux source-file ~/.tmux.conf` (or restart the server) after any change.
- Visually confirm the status bar in both `@gruvbox-tmux_theme dark` and `light`.
- Toggle `@gruvbox-tmux_git_status` and `@gruvbox-tmux_github_status` on/off and confirm both paths render (including the empty/disabled case).

**Legacy & characterization tests**: not applicable — this is a status-line rendering plugin with no untested legacy business logic.

## ❗ Important Notes

### Environment Configuration

- **Environment Variables**: none required. All behavior is configured via tmux user options (`set -g @gruvbox-tmux_*`), documented in `README.md`.
- **Secrets**: none stored in-repo. GitHub API calls rely on the user's local `gh auth login` session or fall back to unauthenticated, rate-limited REST — never commit tokens.

### Security Considerations

- **Authentication**: delegated entirely to the user's local `gh` CLI session; this repo never handles credentials directly.
- **API Rate Limiting**: unauthenticated GitHub REST calls are capped at 60 req/hour/IP; `github-status.sh` caches results in `~/.cache/gruvbox-tmux` for 5 minutes to stay under this limit.
- **Common Pitfalls**: `git-status.sh` runs `git fetch` from inside the tmux status-line render path, throttled to once per 5 minutes via `FETCH_HEAD` mtime — do not remove this throttle, or every status-bar refresh will trigger a fetch.

### Do Not Touch

None currently.

### Known Gotchas

- Requires Bash 4.2+; macOS ships Bash 3.4/3.2 by default, which silently breaks the associative arrays used throughout (`themes.sh` and others). `lib/coreutils-compat.sh` also assumes Homebrew coreutils/gawk/gsed/bc are installed on macOS — if missing, scripts silently fall back to BSD tool behavior, which can produce subtly wrong output.
- Nerd Font glyph rendering is terminal-dependent; commit history shows repeated icon-rendering fixes across terminals (e.g. iTerm2 vs. others). If icons render incorrectly, suspect the terminal's Nerd Font patch/version before the script logic.
- `THEME[...]` keys (e.g. `bblack`, `ghmagenta`) are the single source of truth for colors — a script reading raw hex codes instead of `THEME[...]` is a sign it wasn't written to convention.

### Refactoring Status

- `src/*.sh` (`themes.sh`, `git-status.sh`, `github-status.sh`, `path-widget.sh`, `custom-number.sh`) — MODERN, follow this pattern for new segments.
- `lib/coreutils-compat.sh` — MODERN, extend with additional GNU-tool shims here rather than per-script.

## 📊 Monitoring and Observability

Not applicable — this is a local tmux status-line plugin with no deployed service, logs, or metrics endpoint.
