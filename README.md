# niri-worktree-management

Git worktree manager for [Niri](https://github.com/YaLTeR/niri). Create, manage, and clean up worktrees with dedicated Niri workspaces — each worktree gets its own named workspace with your editor, terminal, and browser launched automatically.

## Features

- **Interactive TUI** — fuzzy-find branches, worktrees, and actions with fzf
- **Niri workspace integration** — each worktree gets a dedicated named workspace
- **Branch management** — create new branches or check out existing remote ones
- **Clean deletion** — merge into your target branch and push, or archive without merging
- **Fully configurable** — repo path, apps, commands, and workflow in a single config file

## Requirements

- [Niri](https://github.com/YaLTeR/niri) compositor
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder
- [jq](https://github.com/jqlang/jq) — JSON processor
- git

## Setup

### 1. Install

```bash
git clone https://github.com/nskha101/niri-worktree-management.git
cd niri-worktree-management
chmod +x install.sh
./install.sh
```

This copies `wk` and `dev` to `~/.local/bin/` and creates a config file at `~/.config/wk/wk.conf`.

Make sure `~/.local/bin` is in your PATH:

```bash
# Add to your ~/.bashrc or ~/.zshrc if not already present
export PATH="$HOME/.local/bin:$PATH"
```

Or install manually:

```bash
cp wk dev ~/.local/bin/
chmod +x ~/.local/bin/wk ~/.local/bin/dev
```

### 2. Configure

Run the init command to create and edit the config:

```bash
wk init
```

Or edit `~/.config/wk/wk.conf` directly. At minimum, set `MAIN_REPO`:

```bash
# Path to your main git repository
MAIN_REPO="$HOME/Code/my-project"
```

### 3. Verify

```bash
wk help    # Check it's installed
wk list    # List existing worktrees (should show none initially)
```

## Configuration

All settings live in `~/.config/wk/wk.conf` (or `$WK_CONFIG` if set). The file is sourced by bash so you can use variables like `$HOME`.

See [wk.conf.example](wk.conf.example) for all options with documentation.

### Key options

| Option | Default | Description |
|--------|---------|-------------|
| `MAIN_REPO` | *(required)* | Path to your main git repository |
| `WORKTREE_BASE` | `$HOME/worktrees` | Directory where worktrees are created |
| `WT_PREFIX` | repo directory name | Prefix for worktree dirs (e.g. `proj` creates `proj-branchname`) |
| `BASE_BRANCH` | `origin/main` | Branch to fork new branches from |
| `MERGE_TARGET` | `main` | Branch to merge into when finishing a worktree |
| `EXCLUDED_BRANCHES` | `main` | Branches to hide from the remote picker (space-separated) |
| `COPY_FILES` | `.env` | Files to copy from main repo to new worktrees (space-separated) |
| `POST_CREATE_CMD` | *(empty)* | Command to run after creating a worktree (e.g. `pnpm install`) |
| `EDITOR_CMD` | `code {dir}` | Editor to launch (`{dir}` = worktree path) |
| `TERMINAL_CMD` | *(empty)* | Terminal to launch (`{dir}` = worktree path) |
| `BROWSER_CMD` | *(empty)* | Browser to launch (`{url}` = BROWSER_URL) |
| `BROWSER_URL` | *(empty)* | URL to open in browser (e.g. `http://localhost:3000`) |

### Terminal examples

Different terminals use different flags for the working directory:

| Terminal | Config |
|----------|--------|
| Ghostty | `TERMINAL_CMD="ghostty --working-directory={dir}"` |
| Kitty | `TERMINAL_CMD="kitty --directory {dir}"` |
| Alacritty | `TERMINAL_CMD="alacritty --working-directory {dir}"` |
| Foot | `TERMINAL_CMD="foot --working-directory={dir}"` |
| WezTerm | `TERMINAL_CMD="wezterm start --cwd {dir}"` |

### Example config

```bash
MAIN_REPO="$HOME/Code/my-project"
WORKTREE_BASE="$HOME/worktrees"
WT_PREFIX="proj"
BASE_BRANCH="origin/develop"
MERGE_TARGET="develop"
EXCLUDED_BRANCHES="main develop"
COPY_FILES=".env .env.local"
POST_CREATE_CMD="pnpm install"
EDITOR_CMD="code {dir}"
TERMINAL_CMD="ghostty --working-directory={dir}"
BROWSER_CMD="brave --new-window {url}"
BROWSER_URL="http://localhost:3000"
DEV_PORTS="3000 4111 8787"
DEV_CMD="pnpm dev"
```

## Usage

### `wk` — Interactive menu

```
$ wk
```

Opens an interactive fzf menu showing all active worktrees with status indicators, or create a new one. This is the main entry point.

### `wk create` — Create a worktree

```
$ wk create
```

Choose to create a new branch (forked from `BASE_BRANCH`) or check out an existing remote branch. The command:

1. Creates a git worktree in `$WORKTREE_BASE`
2. Copies configured files (e.g. `.env`)
3. Runs your post-create command (e.g. `pnpm install`)
4. Opens a new Niri workspace with your configured apps

### `wk list` — List and manage worktrees

```
$ wk list
```

Shows all active worktrees sorted by last commit date with `[OPEN]` indicators for those with active Niri workspaces. Select one to focus, reopen, or delete.

### `wk delete [branch]` — Delete a worktree

```
$ wk delete              # interactive selection
$ wk delete my-branch    # delete specific branch
```

Two options:

1. **Merge & push** — pushes the branch, merges into `MERGE_TARGET`, pushes, then cleans up the worktree, branch, and Niri workspace
2. **Archive** — removes the worktree and deletes the branch without merging

### `wk init` — Set up config

```
$ wk init
```

Creates a config file at `~/.config/wk/wk.conf` from the example template and opens it in your editor.

## Companion: `dev`

The `dev` script is a dev server launcher that reads from the same config file. It kills any processes occupying your configured ports before starting the dev server.

```
$ cd ~/worktrees/proj-my-feature
$ dev
```

Configure it in `wk.conf`:

```bash
DEV_PORTS="3000 8080"
DEV_CMD="npm run dev"
```

## License

MIT
