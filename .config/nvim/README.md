# Neovim Configuration

Modular Neovim configuration that shares common settings with vim while using modern nvim plugins.

## Architecture

### Configuration Files

```
~/.dotfiles/
├── vim-shared.vim       # Common settings for both vim and nvim
├── vim-plugins.vim      # Vim-only: Vundle and plugin configurations
├── vimrc                # Vim entry point (sources both shared and plugins)
└── .config/nvim/
    ├── init.lua         # Nvim entry point (shared + plugins + keybindings)
    └── README.md        # This file
```

### How It Works

**vim-shared.vim** (60+ lines)
- Editor settings (line numbers, tabs, search, etc.)
- Keybindings (space as leader, search clearing)
- File type associations
- NO color/theme settings (vim and nvim handle separately)
- Used by BOTH vim and nvim

**vim-plugins.vim** (Vim only, 130+ lines)
- Syntax highlighting and 256-color support
- Desert colorscheme with custom highlights
- Vundle setup and plugin declarations
- Plugin configurations (Syntastic, YouCompleteMe, CtrlP, Tagbar, etc.)
- Plugin-specific keybindings
- NOT used by nvim

**vimrc** (Vim entry point)
- Sources vim-shared.vim
- Sources vim-plugins.vim

**init.lua** (Nvim entry point, 95 lines)
- Sources vim-shared.vim
- Enables syntax highlighting with terminal colors
- Uses Ghostty's colorscheme (termguicolors)
- lazy.nvim plugin manager
- Telescope.nvim fuzzy finder

## Features

### Core Requirements
- ✅ **Line numbers** in gutter
- ✅ **Arrow keys** for navigation (work by default)

### Shared Features (from vim-shared.vim)
- Incremental search with highlight
- Current line highlighting
- 2-space indentation
- Whitespace visualization
- 80-character column guide
- Space as leader key

### Nvim-Specific Features
- **Ghostty terminal colors** (24-bit, no vim theme)
- **lazy.nvim** plugin manager (modern, fast)
- **Telescope.nvim** fuzzy finder

## Telescope Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-P` | Find files | Fuzzy find files (same as vim CtrlP) |
| `<leader>ff` | Find files | Alternative file finder |
| `<leader>fg` | Live grep | Search text across files |
| `<leader>fb` | Find buffers | Search open buffers |
| `<leader>fh` | Help tags | Search help documentation |
| `<leader>fr` | Recent files | Recently opened files |

**Note:** Leader key is `Space`

## Setup

The configuration is already active if you have the symlink:
```bash
~/.config/nvim -> ~/.dotfiles/.config/nvim
```

### First Launch

When you first run `nvim`, lazy.nvim will automatically:
1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install Telescope and its dependencies
3. Show installation progress

Just run:
```bash
nvim
```

Then press `Ctrl-P` to start fuzzy finding files!

## Plugin Management

### Check Plugin Status
```vim
:Lazy
```

### Update Plugins
```vim
:Lazy update
```

### Install New Plugins
Add to the `plugins` table in `init.lua`, save, and run `:Lazy sync`

## Benefits of This Architecture

1. **DRY Principle** - Common settings defined once in vim-shared.vim
2. **Clean Separation** - Vim plugins isolated from nvim
3. **Maintainability** - Easy to update shared vs vim-specific vs nvim-specific settings
4. **Performance** - Nvim doesn't load Vundle or heavy vim plugins
5. **Modern Workflow** - Telescope is faster and more powerful than CtrlP
6. **Future-Ready** - Can add LSP, Treesitter, etc. easily

## Adding More Plugins

Edit `~/.dotfiles/.config/nvim/init.lua` and add to the `plugins` table:

```lua
local plugins = {
  -- Telescope (already installed)
  { 'nvim-telescope/telescope.nvim', ... },

  -- Add new plugins here, for example:
  -- { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  -- { 'neovim/nvim-lspconfig' },
}
```

Suggested plugins:
- **nvim-lspconfig** - Language Server Protocol (replaces YouCompleteMe)
- **nvim-treesitter** - Better syntax highlighting
- **Comment.nvim** - Easy commenting
- **nvim-tree.lua** - File explorer

## Notes

- Vim and nvim configs are now modular and maintainable
- Shared settings ensure consistency between editors
- Vim users keep all their Vundle plugins
- Nvim users get modern, fast plugins with lazy.nvim
- Both editors share the same keybindings (except plugins)
