-- Neovim Configuration
-- Sources shared vim config, then adds nvim-specific enhancements

--------------------------------------------------
-- Source Shared Vim Configuration
--------------------------------------------------
-- This provides common settings used by both vim and nvim
-- (appearance, editing behavior, keybindings, etc.)
-- Note: Colors/themes are NOT included in shared config
vim.cmd('source ~/.dotfiles/vim-shared.vim')

--------------------------------------------------
-- Nvim-Specific Color Configuration
--------------------------------------------------
-- Use Ghostty terminal colors (no vim colorscheme)
-- This allows nvim to inherit Ghostty's theme

-- Enable syntax highlighting with terminal colors
vim.cmd('syntax on')

-- Use 24-bit terminal colors from Ghostty
vim.opt.termguicolors = true

-- Don't set a colorscheme - use terminal's colors
-- Ghostty will provide the color palette

--------------------------------------------------
-- Future Plugin Management (commented for now)
--------------------------------------------------
-- When ready to add plugins, consider using lazy.nvim:
-- https://github.com/folke/lazy.nvim
--
-- Example plugins you might want:
-- - nvim-lspconfig (LSP for code intelligence)
-- - telescope.nvim (fuzzy finder, better than CtrlP)
-- - nvim-treesitter (better syntax highlighting)
-- - Comment.nvim (easy commenting)
-- - nvim-tree.lua (file explorer)
