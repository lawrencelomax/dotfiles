# dotfiles

Personal dotfiles with modular vim/nvim configuration, shell customization, and development environment setup.

## Overview

This repository contains a minimal, well-organized dotfiles setup with:
- **Modular vim/nvim configuration** - Shared settings with editor-specific plugins
- **Zsh shell configuration** - Custom prompt, PATH management, aliases
- **Neovim with modern plugins** - Telescope fuzzy finder, lazy.nvim plugin manager
- **Ghostty terminal integration** - Nvim uses terminal colorscheme

## Features

### Vim/Neovim Configuration
- **Shared settings** (`vim-shared.vim`) - Common editor behavior for both vim and nvim
- **Vim plugins** (`vim-plugins.vim`) - Vundle setup with CtrlP, YouCompleteMe, ALE, Tagbar
- **Neovim modern setup** - Telescope fuzzy finder, Ghostty terminal colors, lazy.nvim
- **Clean separation** - No plugin conflicts between vim and nvim

### Shell Configuration
- **Zsh with Antigen** - Plugin management for zsh
- **Homebrew PATH setup** - Proper PATH configuration for Apple Silicon/Intel Macs
- **Custom aliases** - Git, Mercurial, development helpers
- **LiquidPrompt** - Informative shell prompt

### Key Bindings
- **Vim/Nvim**: Space as leader key, line numbers, arrow keys enabled
- **Nvim Telescope**: `Ctrl-P` for file finding (same as vim CtrlP)
- **Nvim Telescope**: `Space + fg` for live grep, `Space + fb` for buffers

## Architecture

```
~/.dotfiles/
├── README.md              # This file
├── setup.sh               # Interactive setup script (coming soon)
├── .gitignore             # Ignore compiled files and plugin lockfiles
│
├── zshrc                  # Zsh configuration entry point
├── env_exports            # Environment variables and PATH setup
├── antigen                # Antigen plugin manager for zsh
│
├── vim-shared.vim         # Shared vim/nvim settings (60+ lines)
├── vim-plugins.vim        # Vim-only plugins and colorscheme (130+ lines)
├── vimrc                  # Vim entry point (sources shared + plugins)
│
├── .config/
│   └── nvim/
│       ├── init.lua       # Nvim entry point (95 lines)
│       └── README.md      # Nvim-specific documentation
│
├── tmux.conf              # Tmux configuration
├── ghci                   # GHCi (Haskell REPL) configuration
├── hgrc                   # Mercurial configuration
├── hyper.js               # Hyper terminal configuration
└── colors.sh              # Terminal color definitions
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

# Run interactive setup script (coming soon)
cd ~/.dotfiles
./setup.sh

# Or manually symlink (see Manual Setup below)
```

### Manual Setup

Create symlinks for the configurations you want:

```bash
# Clone Antigen (required for zsh)
git clone https://github.com/zsh-users/antigen.git ~/.antigen

# Zsh shell
ln -s ~/.dotfiles/zshrc ~/.zshrc

# Vim (classic)
ln -s ~/.dotfiles/vimrc ~/.vimrc

# Neovim (modern)
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim

# Tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

# Mercurial
ln -s ~/.dotfiles/hgrc ~/.hgrc

# Haskell GHCi
ln -s ~/.dotfiles/ghci ~/.ghci
```

### First Launch

**Zsh:**
```bash
source ~/.zshrc
# Antigen will install plugins automatically
```

**Vim:**
```bash
# Install Vundle first
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Then install plugins
vim +PluginInstall +qall
```

**Neovim:**
```bash
nvim
# lazy.nvim and Telescope will auto-install on first launch
# Press Ctrl-P to start fuzzy finding files!
```

## Configuration Details

### Vim Configuration

**vim-shared.vim** (used by both vim and nvim)
- Line numbers, cursor line highlighting
- 2-space indentation, whitespace visualization
- 80-character column guide
- Space as leader key
- Incremental search
- No swap files

**vim-plugins.vim** (vim only)
- Desert colorscheme with custom highlights
- Vundle plugin manager
- CtrlP fuzzy finder
- YouCompleteMe code completion
- ALE linter
- Syntastic, Tagbar, vim-ripgrep
- 256-color terminal support

**vimrc**
- Simple entry point that sources both shared and plugins

### Neovim Configuration

**init.lua**
- Sources vim-shared.vim for common settings
- Uses Ghostty terminal colors (no vim colorscheme)
- lazy.nvim plugin manager (modern, fast)
- Telescope.nvim fuzzy finder with live preview
- 24-bit terminal color support

**Telescope Keybindings:**
- `Ctrl-P` - Find files (same as vim CtrlP)
- `Space + ff` - Find files
- `Space + fg` - Live grep (search in files)
- `Space + fb` - Find buffers
- `Space + fh` - Help tags
- `Space + fr` - Recent files

### Shell Configuration

**zshrc**
- Sources Antigen plugin manager
- Sources environment exports
- LiquidPrompt for informative prompt
- Custom aliases for git, hg, xcode-simctl
- Zsh syntax highlighting and autosuggestions

**env_exports**
- Homebrew paths (`/opt/homebrew/bin` for Apple Silicon)
- User-local package manager paths (Cabal, rbenv, Cargo)
- EDITOR set to vim
- Terminal color settings

## Updating

```bash
cd ~/.dotfiles
git pull

# Update nvim plugins
nvim
:Lazy update

# Update vim plugins (if using vim)
vim +PluginUpdate +qall
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

Edit `.config/nvim/init.lua` and add after line 22:

```lua
vim.cmd('colorscheme <your-colorscheme>')
```

### Change Vim Colorscheme

Edit `vim-plugins.vim` line 15:

```vim
colorscheme <your-colorscheme>
```

### Modify Shell Prompt

Edit `zshrc` to customize LiquidPrompt settings or use a different prompt.

### Add Shell Aliases

Edit `zshrc` and add aliases in the "Aliasing" section (around line 52).

## Structure Philosophy

- **DRY Principle**: Shared settings defined once in vim-shared.vim
- **Clean Separation**: Vim and nvim plugins don't interfere with each other
- **Minimal & Maintainable**: Only include what you use
- **Version Controlled**: All dotfiles tracked in git
- **Modern Tools**: Nvim uses lazy.nvim and Telescope (modern, fast)
- **Legacy Support**: Vim still works with Vundle and all classic plugins

## Troubleshooting

### Nvim colors look wrong
- Ensure Ghostty or your terminal supports 24-bit colors
- Check `termguicolors` is enabled in init.lua

### Vim plugins not working
- Install Vundle: `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
- Run `:PluginInstall` in vim

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
