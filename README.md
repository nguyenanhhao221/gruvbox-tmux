A personalized gruvbox-inspired tmux status line, based on a fork of https://github.com/adibhanna/gruvbox-tmux and customized with my own configuration.

## Requirements

This theme has the following hard requirements:

- Any patched Nerd Fonts (v3 or higher)
- Bash 4.2 or newer

### Important for MacOS users

- As of the time of writing, latest version of MacOS's Bash is 3.4, which cannot be used with this theme.
- You need to install Bash 4.2 or newer.

## Options

Add these options into your `.tmux.conf` file:

```zsh
set -g @plugin "nguyenanhhao221/gruvbox-tmux"
set -g @gruvbox-tmux_theme dark # dark | light
set -g @gruvbox-tmux_git_status off # disable git status in tmux in favor of nvim status bar
set -g @gruvbox-tmux_show_path 1 # show current path 
set -g @gruvbox-tmux_path_format relative # full | relative, format to show path

# Optional: Configure GitHub status display (default: on)
set -g @gruvbox-tmux_github_status off # on or off
```

## Features

- **Git Status**: Shows current branch, sync status, and change counts
- **GitHub Integration**: Displays open pull requests and issues count for the current repository
  - 󰘬 Pull requests (magenta)
  - 󰌶 Issues (red)
  - Requires GitHub CLI (`gh`) for authenticated requests or falls back to unauthenticated API calls
  - Results are cached for 5 minutes to improve performance
  - Can be disabled with `set -g @gruvbox-tmux_github_status off`
- **Custom Window Numbers**: Configurable window and pane number styles
- **Path Widget**: Shows current directory path

### GitHub Integration Setup

For the best experience with GitHub integration:

1. **Install GitHub CLI**: `brew install gh` (macOS) or follow [installation instructions](https://cli.github.com/)
2. **Authenticate**: `gh auth login`
3. **Enjoy unlimited API requests** without rate limiting

Without GitHub CLI, the extension falls back to unauthenticated API requests which are rate-limited to 60 requests per hour per IP address.

## Dark

![dark](img/dark.png)

## Light

![light](img/light.png)
