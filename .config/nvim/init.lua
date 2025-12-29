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
-- lazy.nvim Plugin Manager Setup
--------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Telescope fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      -- Telescope setup
      telescope.setup({
        defaults = {
          -- Layout
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
          -- Ignore patterns (like CtrlP)
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.zwc$",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load fzf extension for faster sorting
      telescope.load_extension('fzf')

      -- Keybindings
      -- Ctrl-P for file finding (same as vim CtrlP)
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })

      -- Leader-based shortcuts
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
    end,
  },
}

-- Load local/machine-specific plugins if they exist
-- This file is gitignored and can contain work-specific plugins
local local_plugins_path = vim.fn.stdpath("config") .. "/lua/local/plugins.lua"
if vim.fn.filereadable(local_plugins_path) == 1 then
  local local_plugins = require("local.plugins")
  if local_plugins then
    for _, plugin in ipairs(local_plugins) do
      table.insert(plugins, plugin)
    end
  end
end

-- Setup lazy.nvim
require("lazy").setup(plugins, {
  -- UI for plugin management
  ui = {
    border = "rounded",
  },
})
