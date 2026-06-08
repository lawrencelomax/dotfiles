# dotfiles

Personal dotfiles with modular vim/nvim configuration, shell customization, and development environment setup.

## Overview

This repository contains a minimal, well-organized dotfiles setup with:
- **Neovim configuration** - Modern setup with Telescope fuzzy finder and lazy.nvim
- **Zsh shell configuration** - Custom prompt, PATH management, aliases
- **Ghostty terminal** - Managed terminal config (theme); nvim inherits its colorscheme
- **Claude Code settings** - Permission allowlist for safe development operations

## Features

### Neovim Configuration
- **Core settings** (`.config/nvim/settings.vim`) - Editor behavior, appearance, keybindings
- **Modern setup** - Telescope fuzzy finder, Ghostty terminal colors, lazy.nvim plugin manager
- **Sapling integration** - Telescope-based stack and diff pickers (see `.config/nvim/README.md`)

### Shell Configuration
- **Zsh with Antigen** - Plugin management for zsh
- **Homebrew PATH setup** - Proper PATH configuration for Apple Silicon/Intel Macs
- **Custom aliases** - Git, Mercurial, development helpers
- **LiquidPrompt** - Informative shell prompt

### Key Bindings
- **Nvim**: Space as leader key, line numbers, arrow keys enabled
- **Nvim Telescope**: `Ctrl-P` for file finding
- **Nvim Telescope**: `Space + fg` for live grep, `Space + fb` for buffers

## Architecture

```
~/.dotfiles/
├── README.md              # This file
├── setup                  # Interactive setup script (converge; --yes/--force)
├── macos                  # macOS system defaults (run once per machine)
├── dock                   # Dock items via dockutil (run on its own or via macos)
├── Brewfile               # Homebrew package manifest (brew bundle)
├── .gitignore             # Ignore compiled files and plugin lockfiles
│
├── zshrc                  # Zsh configuration entry point
├── env_exports            # Environment variables and PATH setup
├── antigen                # Antigen plugin manager for zsh
│
├── .config/               # XDG config (individual items symlinked to ~/.config/)
│   ├── ghostty/
│   │   └── config.ghostty # Ghostty terminal config (theme, etc.)
│   ├── nvim/
│   │   ├── init.lua       # Nvim entry point (plugins + keybindings)
│   │   ├── settings.vim   # Nvim core editor settings
│   │   └── README.md      # Nvim-specific documentation
│   └── powerline/         # Powerline prompt theme and colors
│
├── .claude/               # Claude Code configuration
│   └── settings.defaults.json  # Defaults merged ("healed") into ~/.claude/settings.json
│
├── tmux.conf              # Tmux configuration
├── hyper.js               # Hyper terminal configuration
└── colors                 # Terminal color definitions
```

### XDG Config Directory Approach

> **XDG** = X Desktop Group (now freedesktop.org). The XDG Base Directory Specification defines `~/.config` as the standard location for user configuration files, replacing scattered dotfiles in `~/`.

**Important:** `~/.config` is intentionally **not** symlinked to this repository. Only individual configuration directories within it are symlinked.

**Why not symlink all of ~/.config?**

Many applications store machine-specific or sensitive data in `~/.config/`:
- **Secrets and tokens** - OAuth tokens, API keys, authentication credentials
- **Machine-specific settings** - Hardware-dependent configs, local paths
- **Caches and state** - Plugin lockfiles, update timestamps, session data
- **Work-specific configs** - Corporate tools, internal systems

This dotfiles repository is designed for **portable configuration that works across machines**. By symlinking only specific directories (nvim, powerline), we:
1. Keep secrets out of version control
2. Avoid conflicts between machines with different setups
3. Let applications manage their own local state

```
~/.config/                          # Real directory (NOT a symlink)
├── nvim -> ~/.dotfiles/.config/nvim       # Symlink (tracked, portable)
├── powerline -> ~/.dotfiles/.config/powerline  # Symlink (tracked, portable)
└── ...other app configs...         # Local only (machine-specific or secrets)
```

## Installation

### Prerequisites
- macOS (tested on Apple Silicon)
- Homebrew installed
- Zsh installed (via Homebrew recommended)
- Git

### Quick Setup

```bash
# Clone to ~/.dotfiles
git clone https://github.com/lawrencelomax/dotfiles.git ~/.dotfiles

# Run the setup script — converges to the dotfiles config, skipping anything
# already in good shape and prompting before each change.
cd ~/.dotfiles
./setup            # interactive
# ./setup --yes   # non-interactive (assume yes to every prompt)
# ./setup --force  # re-apply config symlinks even if already correct

# Or manually symlink (see Manual Setup below)
```

### Manual Setup

Create symlinks for the configurations you want:

```bash
# Clone Antigen (required for zsh)
git clone https://github.com/zsh-users/antigen.git ~/.antigen

# Zsh shell
ln -s ~/.dotfiles/zshrc ~/.zshrc

# Neovim - individual symlink into ~/.config/
mkdir -p ~/.config
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim

# Powerline - individual symlink into ~/.config/
ln -s ~/.dotfiles/.config/powerline ~/.config/powerline

# Ghostty (only on hosts with Ghostty installed) - individual symlink into ~/.config/
ln -s ~/.dotfiles/.config/ghostty ~/.config/ghostty

# Tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
```

Claude Code settings are **not** symlinked — Claude Code owns `~/.claude/settings.json`
and writes to it. Instead, merge in the defaults (see [Claude Code Configuration](#claude-code-configuration)):

```bash
# Easiest: ./setup runs the "Claude Code Defaults" heal step for you.
# Or, on a fresh machine with no settings yet, seed it directly:
mkdir -p ~/.claude
cp ~/.dotfiles/.claude/settings.defaults.json ~/.claude/settings.json
```

### First Launch

**Zsh:**
```bash
source ~/.zshrc
# Antigen will install plugins automatically
```

**Neovim:**
```bash
nvim
# lazy.nvim and Telescope will auto-install on first launch
# Press Ctrl-P to start fuzzy finding files!
```

## Configuration Details

### Neovim Configuration

**.config/nvim/settings.vim** (core editor settings)
- Line numbers, cursor line highlighting
- 2-space indentation, whitespace visualization
- Space as leader key
- Incremental search
- No swap files

**.config/nvim/init.lua**
- Sources `settings.vim` for core settings
- Uses Ghostty terminal colors (no colorscheme)
- lazy.nvim plugin manager (modern, fast)
- Telescope.nvim fuzzy finder with live preview
- Sapling (sl) stack and diff pickers
- 24-bit terminal color support

**Telescope Keybindings:**
- `Ctrl-P` - Find files
- `Space + ff` - Find files
- `Space + fg` - Live grep (search in files)
- `Space + fb` - Find buffers
- `Space + fh` - Help tags
- `Space + fr` - Recent files

### Ghostty Configuration

**.config/ghostty/config.ghostty**
- Terminal theme and appearance (currently `iTerm2 Tango Dark`)
- Symlinked to `~/.config/ghostty` (XDG path) — only on hosts with Ghostty installed (e.g. laptop, not a development server)
- Reload at runtime with `cmd+shift+,`
- Machine-local overrides go in `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` (Ghostty loads it last, so it wins)

### Claude Code Configuration

Claude Code **owns** `~/.claude/settings.json` — it writes interactive permission
grants, enabled plugins, and marketplaces there. So this repo does **not** symlink
or replace that file. Instead, `setup` *heals* it: it merges the defaults from
`.claude/settings.defaults.json` into the real file, filling in anything missing
and unioning the permission allowlist, while **existing values always win**. It's
idempotent — re-running only adds what's absent, and Claude's own writes are never
clobbered (and never end up in this public repo).

**settings.defaults.json** (version controlled)
- Baseline permission allowlist for safe development operations
- Default `model`, `effortLevel`, and `env` (e.g. disabling the autoupdater)
- Portable across machines — general development tools only

**Machine-specific configuration:**
- Use `~/.claude/settings.local.json` for machine/work settings (plugins, marketplaces, work paths)
- Local settings override/extend `settings.json`
- Keep secrets and work-specific config in local settings only — never in this public repo

> Healing requires `jq` (included in the `Brewfile`). To re-apply defaults at any
> time, run `./setup` and accept the "Claude Code Defaults" step.

**Permissions included:**
- **Build systems**: `buck`, `buck2` — Meta's open-source build system
- **Package management**: `brew list` — List installed Homebrew packages (read-only)
- **Source control**: `git`, `hg`, `sl` — Git, Mercurial, and Sapling (hg/sl are synonyms)
- **File search**: `fd`, `find`, `grep`, `rg` — File and content search tools
- **File operations**: `cat`, `chmod`, `echo`, `jq`, `ln`, `ls`, `readlink`, `tree` — Read, inspect, and manipulate files
- **Text processing**: `patch`, `pandoc`, `pdftotext` — Patching, document conversion
- **Image tools**: `convert`, `magick`, `identify` — ImageMagick suite
- **Binary analysis**: `nm`, `otool`, `strings` — Inspect compiled binaries and libraries
- **Editors/multiplexers**: `nvim`, `tmux` — Neovim and terminal multiplexer
- **Apple toolchain**: `xcodebuild`, `xcodegen` — Xcode build and project generation
- **Reference**: `man` — Manual pages
- **Network**: `ping` — Basic connectivity checks
- **Claude tools**: `Read`, `WebSearch` — Built-in Claude Code tools

### Shell Configuration

**zshrc**
- Sources Antigen plugin manager
- Sources environment exports
- LiquidPrompt for informative prompt
- Custom aliases for git, hg, xcode-simctl
- Zsh syntax highlighting and autosuggestions

**env_exports**
- Homebrew paths (`/opt/homebrew/bin` for Apple Silicon)
- User-local package manager paths (rbenv, Cargo)
- EDITOR set to nvim
- Terminal color settings

## Homebrew

Packages are declared in the `Brewfile` and installed with `brew bundle`.

```bash
# Install Homebrew (if needed) and all Brewfile packages:
brew bundle --file=~/.dotfiles/Brewfile

# See what's missing without installing:
brew bundle check --file=~/.dotfiles/Brewfile
```

- `setup` offers to install Homebrew and run `brew bundle` for you.
- Work- or machine-specific packages go in an untracked **`Brewfile.local`** (gitignored, kept out of this public repo); `setup` applies it too if present.
- Mac App Store apps can be added via the `mas` CLI (see the commented example in the `Brewfile`).

## macOS Defaults

System settings are codified in the `macos` script — an idempotent set of
`defaults write` commands (Dark mode, Dock position/size, Finder list view,
small sidebar icons, fast key repeat, Bluetooth/Volume in the menu bar,
screenshots to `~/Desktop/Screenshots`, etc.). Dock **items** — pinned apps and
folder stacks (Applications, Home, Downloads as folders in list view) managed
with `dockutil` — live in a separate `dock` script so they can be re-applied on
their own; `macos` calls it automatically.

```bash
# Run once per machine (review/trim to taste first):
cd ~/.dotfiles && ./macos

# Re-pin just the Dock items (apps + folder stacks), without the other defaults:
./dock
```

- Safe to re-run — each command just sets a value.
- Only runs on macOS; `setup` offers it as an optional step.
- Some changes need a logout/restart to fully apply.

## Manual Setup (not scriptable)

A few settings live in TCC-protected or iCloud-synced stores and can't be applied
via `defaults`/scripts. The `macos` script **detects** what it can and prints
reminders at the end of its run; set these by hand once per machine:

- **Chrome web-app dock badging** — Gmail, Google Chat, Google Calendar (installed as Chrome web apps in `~/Applications/Chrome Apps.localized/`). System Settings → Notifications → each app → enable **Allow notifications** and **Badge application icon**. The badge flag lives in the TCC-protected `usernoted` database (`~/Library/Group Containers/group.com.apple.usernoted/db2/db`) — readable only with Full Disk Access, never writable by scripts.
- **World clocks** — Clock.app → World Clock → add *Los Angeles* (PST), *Reykjavík*/*London* (GMT), *New York* (EST); then add **World Clock** widgets (one city each). Stored in the Clock app's iCloud data, not scriptable.

## Updating

```bash
cd ~/.dotfiles
git pull

# Update nvim plugins
nvim
:Lazy update
```

## Neovim Plugin Management

```vim
:Lazy              " Open plugin manager UI
:Lazy update       " Update all plugins
:Lazy sync         " Install/update/clean plugins
```

## Adding More Nvim Plugins

Edit `~/.dotfiles/.config/nvim/init.lua` and add to the `plugins` table:

```lua
local plugins = {
  -- Existing plugins...
  { 'nvim-telescope/telescope.nvim', ... },

  -- Add new plugins:
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'neovim/nvim-lspconfig' },
}
```

Then run `:Lazy sync` in nvim.

## Customization

### Change Nvim Colorscheme

Edit `.config/nvim/init.lua` and add after the color configuration block:

```lua
vim.cmd('colorscheme <your-colorscheme>')
```

### Modify Shell Prompt

Edit `zshrc` to customize LiquidPrompt settings or use a different prompt.

### Add Shell Aliases

Edit `zshrc` and add aliases in the "Aliasing" section (around line 52).

## Structure Philosophy

- **Minimal & Maintainable**: Only include what you use
- **Version Controlled**: All dotfiles tracked in git
- **Modern Tools**: Nvim uses lazy.nvim and Telescope (modern, fast)
- **Portable**: Machine-specific config stays out of the repo (use local overrides)

## Troubleshooting

### Nvim colors look wrong
- Ensure Ghostty or your terminal supports 24-bit colors
- Check `termguicolors` is enabled in init.lua

### Zsh plugins not loading
- Source zshrc: `source ~/.zshrc`
- Antigen will auto-install on first source

### Telescope not finding files
- Press `Ctrl-P` in nvim
- Ensure you're in a directory with files
- Check `:Lazy` shows Telescope installed

## License

MIT

## Credits

Minimal dotfiles philosophy inspired by keeping things simple and adding as needed.
