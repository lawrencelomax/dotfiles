# Neovim Configuration

Modular Neovim configuration that shares common settings with vim while avoiding legacy Vundle dependencies.

## Architecture

### Configuration Files

```
~/.dotfiles/
├── vim-shared.vim       # Common settings for both vim and nvim
├── vim-plugins.vim      # Vim-only: Vundle and plugin configurations
├── vimrc                # Vim entry point (sources both shared and plugins)
└── .config/nvim/
    ├── init.lua         # Nvim entry point (sources shared + nvim enhancements)
    └── README.md        # This file
```

### How It Works

**vim-shared.vim** (90+ lines)
- Themes and colors (desert colorscheme)
- Line numbers and appearance settings
- Editing behavior (tabs, search, whitespace)
- Keybindings (space as leader, search clearing)
- File type associations
- Used by BOTH vim and nvim

**vim-plugins.vim** (Vim only, 120+ lines)
- Vundle setup and plugin declarations
- Plugin configurations (Syntastic, YouCompleteMe, CtrlP, Tagbar, etc.)
- Plugin-specific keybindings
- NOT used by nvim

**vimrc** (Vim entry point)
- Sources vim-shared.vim
- Sources vim-plugins.vim

**init.lua** (Nvim entry point)
- Sources vim-shared.vim
- Adds nvim-specific enhancements (24-bit colors)
- Ready for modern plugins (lazy.nvim, LSP, etc.)

## Features

### Core Requirements
- ✅ **Line numbers** in gutter
- ✅ **Arrow keys** for navigation (work by default)

### Shared Features (from vim-shared.vim)
- Syntax highlighting (desert colorscheme)
- Incremental search with highlight
- Current line highlighting
- 2-space indentation
- Whitespace visualization
- 80-character column guide
- Space as leader key

### Nvim-Specific Enhancements
- 24-bit terminal colors (termguicolors)
- Clean separation from vim plugins
- Fast startup (no Vundle overhead)

## Setup

The configuration is already active if you have the symlink:
```bash
~/.config/nvim -> ~/.dotfiles/.config/nvim
```

Just run:
```bash
nvim
```

## Benefits of This Architecture

1. **DRY Principle** - Common settings defined once in vim-shared.vim
2. **Clean Separation** - Vim plugins isolated from nvim
3. **Maintainability** - Easy to update shared vs vim-specific vs nvim-specific settings
4. **Performance** - Nvim doesn't load Vundle or heavy vim plugins
5. **Future-Ready** - Can add modern nvim plugins without affecting vim

## Adding Plugins (Optional)

When you're ready to add nvim plugins, consider using [lazy.nvim](https://github.com/folke/lazy.nvim):

```bash
# Install lazy.nvim
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
  ~/.local/share/nvim/lazy/lazy.nvim
```

Suggested modern plugins to replace vim plugin functionality:
- **nvim-lspconfig** - Language Server Protocol (replaces YouCompleteMe)
- **telescope.nvim** - Fuzzy finder (replaces CtrlP)
- **nvim-treesitter** - Better syntax highlighting
- **Comment.nvim** - Easy commenting
- **nvim-tree.lua** - File explorer

## Notes

- Vim and nvim configs are now modular and maintainable
- Shared settings ensure consistency between editors
- Vim users keep all their Vundle plugins
- Nvim users get a clean, fast editor ready for modern plugins
- Both editors use the same appearance and keybindings
