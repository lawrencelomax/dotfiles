# Neovim Configuration

Neovim configuration using modern nvim plugins (lazy.nvim, Telescope) with Sapling integration.

## Architecture

### Configuration Files

```
~/.dotfiles/.config/nvim/
├── settings.vim      # Core editor settings (sourced by init.lua)
├── init.lua          # Entry point (settings + plugins + keybindings)
└── README.md         # This file
```

### How It Works

**settings.vim**
- Editor settings (line numbers, tabs, search, etc.)
- Keybindings (space as leader, search clearing)
- File type associations
- NO color/theme settings (handled in init.lua)

**init.lua**
- Sources settings.vim
- Enables syntax highlighting with terminal colors
- Uses Ghostty's colorscheme (termguicolors)
- lazy.nvim plugin manager
- Telescope.nvim fuzzy finder
- Sapling (sl) stack and diff pickers

## Features

### Core Requirements
- ✅ **Line numbers** in gutter
- ✅ **Arrow keys** for navigation (work by default)

### Core Settings (from settings.vim)
- Incremental search with highlight
- Current line highlighting
- 2-space indentation
- Whitespace visualization
- Space as leader key

### Nvim-Specific Features
- **Ghostty terminal colors** (24-bit, no colorscheme)
- **lazy.nvim** plugin manager (modern, fast)
- **Telescope.nvim** fuzzy finder

## Telescope Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-P` | Find files | Fuzzy find files |
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

1. **Separation** - Core editor settings (`settings.vim`) kept apart from plugins (`init.lua`)
2. **Maintainability** - Easy to update settings vs plugins independently
3. **Performance** - lazy.nvim loads plugins on demand
4. **Modern Workflow** - Telescope for fuzzy finding and Sapling integration
5. **Future-Ready** - Can add LSP, Treesitter, etc. easily

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
- **nvim-lspconfig** - Language Server Protocol
- **nvim-treesitter** - Better syntax highlighting
- **Comment.nvim** - Easy commenting
- **nvim-tree.lua** - File explorer

## Notes

- Config is modular: core settings in `settings.vim`, plugins/keybindings in `init.lua`
- Uses lazy.nvim for fast, on-demand plugin loading
- Colors come from the terminal (Ghostty) via `termguicolors`
