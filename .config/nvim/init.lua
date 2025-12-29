-- Neovim Configuration
-- Sources shared vim config, then adds nvim-specific enhancements

--------------------------------------------------
-- Source Shared Vim Configuration
--------------------------------------------------
-- This provides common settings used by both vim and nvim
-- (appearance, editing behavior, keybindings, etc.)
-- Note: colorscheme is NOT included in shared config
-- (vim uses desert in vim-plugins.vim, nvim uses its default)
vim.cmd('source ~/.dotfiles/vim-shared.vim')

--------------------------------------------------
-- Nvim-Specific Enhancements
--------------------------------------------------
-- These settings enhance or override the shared config for nvim

-- Enhanced terminal colors (24-bit color support)
vim.opt.termguicolors = true

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
