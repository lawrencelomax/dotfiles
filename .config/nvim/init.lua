-- Neovim Configuration
-- Sources shared vim config, then adds nvim-specific enhancements

--------------------------------------------------
-- Source Core Editor Settings
--------------------------------------------------
-- Core editor settings (appearance, editing behavior, keybindings)
-- Note: Colors/themes are NOT included here (set below)
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/settings.vim')

--------------------------------------------------
-- Disable netrw (use Telescope for directories)
--------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- Make background transparent to use terminal's background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })

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
  -- Which-key: shows available keybindings after pressing leader
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup({
        delay = 200,  -- Show popup after 200ms
      })
      -- Register group names
      wk.add({
        { "<leader>f", group = "File" },
        { "<leader>s", group = "Sapling" },
      })
      -- Command to adjust delay on the fly: :WhichKeyDelay 500
      vim.api.nvim_create_user_command('WhichKeyDelay', function(opts)
        wk.setup({ delay = tonumber(opts.args) })
        print('which-key delay set to ' .. opts.args .. 'ms')
      end, { nargs = 1 })
    end,
  },

  -- Lualine: statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
        },
      })
    end,
  },

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
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      -- Telescope setup
      telescope.setup({
        defaults = {
          -- Layout
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              width = 0.95,
              preview_width = 0.6,
            },
          },
          -- Mappings for preview scrolling (Shift+Arrow keys)
          mappings = {
            i = {
              ["<S-Up>"] = actions.preview_scrolling_up,
              ["<S-Down>"] = actions.preview_scrolling_down,
              ["<S-Left>"] = actions.preview_scrolling_left,
              ["<S-Right>"] = actions.preview_scrolling_right,
            },
            n = {
              ["<S-Up>"] = actions.preview_scrolling_up,
              ["<S-Down>"] = actions.preview_scrolling_down,
              ["<S-Left>"] = actions.preview_scrolling_left,
              ["<S-Right>"] = actions.preview_scrolling_right,
            },
          },
          -- Ignore patterns (skip VCS/build dirs)
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
            case_mode = "ignore_case",
          },
        },
      })

      -- Load fzf extension for faster sorting
      telescope.load_extension('fzf')

      --------------------------------------------------
      -- Sapling (sl) commit picker
      --------------------------------------------------
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local previewers = require('telescope.previewers')
      local action_state = require('telescope.actions.state')

      -- Use table for mutual recursion
      local sl = {}

      -- Configurable format (can be overridden in local config)
      -- e.g., vim.g.sl_log_template = '{node|short} {author|user} {desc|firstline}\n'
      local function get_sl_log_template()
        return vim.g.sl_log_template or '{node|short} {desc|firstline}\n'
      end

      -- Generic async buffer previewer: shows "Loading..." then fills with job output
      local function make_async_buffer_previewer(title, get_cmd, filetype)
        return previewers.new_buffer_previewer({
          title = title,
          define_preview = function(self, entry, _)
            local bufnr = self.state.bufnr
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Loading..." })

            vim.fn.jobstart(get_cmd(entry), {
              stdout_buffered = true,
              on_stdout = function(_, data)
                if data and vim.api.nvim_buf_is_valid(bufnr) then
                  vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(bufnr) then
                      if data[#data] == "" then table.remove(data) end
                      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
                      vim.api.nvim_buf_set_option(bufnr, 'filetype', filetype)
                    end
                  end)
                end
              end,
            })
          end,
        })
      end

      -- Define signs for diff gutter
      vim.fn.sign_define('SlDiffAdd', { text = '+', texthl = 'DiffAdd' })
      vim.fn.sign_define('SlDiffDelete', { text = '-', texthl = 'DiffDelete' })
      vim.fn.sign_define('SlDiffChange', { text = '~', texthl = 'DiffChange' })

      -- Parse diff hunks to get line changes
      -- Returns: { first_line = N, additions = {line1, line2, ...}, deletions = {line1, ...} }
      local function parse_diff_hunks(diff_output)
        local result = { first_line = nil, additions = {}, deletions = {} }
        local current_line = 0

        for line in diff_output:gmatch("[^\n]+") do
          -- Match hunk header: @@ -old,count +new,count @@
          local new_start = line:match("^@@ .-%+(%d+)")
          if new_start then
            current_line = tonumber(new_start)
          elseif current_line > 0 then
            if line:match("^%+") and not line:match("^%+%+%+") then
              -- Added line
              table.insert(result.additions, current_line)
              if not result.first_line then
                result.first_line = current_line
              end
              current_line = current_line + 1
            elseif line:match("^%-") and not line:match("^%-%-%-") then
              -- Deleted line (mark on previous line or current position)
              table.insert(result.deletions, current_line)
              if not result.first_line then
                result.first_line = current_line
              end
              -- Don't increment - deleted lines don't exist in new file
            elseif not line:match("^\\") then
              -- Context line (not "\ No newline at end of file")
              current_line = current_line + 1
            end
          end
        end

        return result
      end

      -- Open a file at a specific commit in a read-only buffer with diff signs
      local function open_file_at_commit(commit, filepath)
        local bufnr = vim.api.nvim_create_buf(true, true)
        local filename = filepath:match('[^/]+$') or filepath
        vim.api.nvim_buf_set_name(bufnr, commit .. ':' .. filename)
        vim.api.nvim_set_current_buf(bufnr)
        vim.bo[bufnr].buftype = 'nofile'
        vim.bo[bufnr].modifiable = true
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Loading..." })

        -- Fetch file content and diff in parallel
        local file_loaded = false
        local diff_parsed = nil
        local sign_group = 'SlDiff_' .. bufnr

        local function apply_signs_and_jump()
          if file_loaded and diff_parsed and vim.api.nvim_buf_is_valid(bufnr) then
            vim.schedule(function()
              -- Clear any existing signs
              vim.fn.sign_unplace(sign_group, { buffer = bufnr })

              -- Place addition signs
              for _, lnum in ipairs(diff_parsed.additions) do
                vim.fn.sign_place(0, sign_group, 'SlDiffAdd', bufnr, { lnum = lnum })
              end

              -- Place deletion signs (on line before deletion, or line 1)
              for _, lnum in ipairs(diff_parsed.deletions) do
                local sign_line = math.max(1, lnum - 1)
                vim.fn.sign_place(0, sign_group, 'SlDiffDelete', bufnr, { lnum = sign_line })
              end

              -- Jump to first changed line
              if diff_parsed.first_line then
                vim.api.nvim_win_set_cursor(0, { diff_parsed.first_line, 0 })
              end
            end)
          end
        end

        -- Fetch file content
        vim.fn.jobstart({ 'sl', 'cat', '-r', commit, filepath }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and vim.api.nvim_buf_is_valid(bufnr) then
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
                  local ft = vim.filetype.match({ filename = filepath, buf = bufnr })
                  if ft then
                    vim.bo[bufnr].filetype = ft
                  end
                  vim.bo[bufnr].modifiable = false
                  file_loaded = true
                  apply_signs_and_jump()
                end
              end)
            end
          end,
        })

        -- Fetch diff for this file
        vim.fn.jobstart({ 'sl', 'diff', '-c', commit, '--color=never', filepath }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data then
              local diff_output = table.concat(data, "\n")
              diff_parsed = parse_diff_hunks(diff_output)
              apply_signs_and_jump()
            end
          end,
        })
      end

      -- Show files changed in a specific commit
      sl.commit_files = function(commit_hash)
        pickers.new({}, {
          prompt_title = 'Files in ' .. commit_hash,
          finder = finders.new_oneshot_job(
            { 'sl', 'status', '--change', commit_hash },
            { entry_maker = function(line)
              local status, filepath = line:match('^(%S+)%s+(.+)$')
              if filepath then
                return {
                  value = filepath,
                  display = line,
                  ordinal = filepath,
                  commit = commit_hash,
                }
              end
            end }
          ),
          sorter = conf.generic_sorter({}),
          previewer = make_async_buffer_previewer("File Diff", function(entry)
            return { 'sl', 'diff', '-c', entry.commit, '--color=never', entry.value }
          end, 'diff'),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                open_file_at_commit(selection.commit, selection.value)
              end
            end)
            local function go_back()
              vim.api.nvim_buf_delete(prompt_bufnr, { force = true })
              vim.schedule(function()
                sl.stack()
              end)
            end
            map('i', '<Esc>', go_back)
            map('n', '<Esc>', go_back)
            map('n', 'q', go_back)
            map('i', '<C-c>', go_back)
            map('n', '<C-c>', go_back)
            return true
          end,
        }):find()
      end

      sl.stack = function()
        -- Cache for commit diffs (scoped to this picker session)
        local diff_cache = {}

        -- Get current commit hash async for highlighting
        vim.fn.jobstart({ 'sl', 'log', '-r', '.', '--template', '{node|short}' }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            local current_hash = (data and data[1] or ''):gsub('%s+$', '')
            vim.schedule(function()
              pickers.new({}, {
                prompt_title = 'Sapling Stack',
                finder = finders.new_oneshot_job(
                  { 'sl', 'log', '-r', 'bottom()::top()', '--template', get_sl_log_template() },
                  { entry_maker = function(line)
                    local hash, rest = line:match('^(%S+)%s+(.*)$')
                    if hash then
                      local is_current = hash == current_hash
                      return {
                        value = hash,
                        display = is_current and ('→ ' .. line) or ('  ' .. line),
                        ordinal = line,
                      }
                    end
                  end }
                ),
                sorter = conf.generic_sorter({}),
                previewer = previewers.new_buffer_previewer({
                  title = "Commit Diff",
                  define_preview = function(self, entry, _)
                    local bufnr = self.state.bufnr
                    local commit = entry.value

                    -- Check cache first
                    if diff_cache[commit] then
                      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_cache[commit])
                      vim.api.nvim_buf_set_option(bufnr, 'filetype', 'diff')
                      return
                    end

                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Loading..." })

                    vim.fn.jobstart({ 'sl', 'show', '--color=never', commit }, {
                      stdout_buffered = true,
                      on_stdout = function(_, diff_data)
                        if diff_data and vim.api.nvim_buf_is_valid(bufnr) then
                          -- Cache the result
                          diff_cache[commit] = diff_data
                          vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(bufnr) then
                              if diff_data[#diff_data] == "" then table.remove(diff_data) end
                              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_data)
                              vim.api.nvim_buf_set_option(bufnr, 'filetype', 'diff')
                            end
                          end)
                        end
                      end,
                    })
                  end,
                }),
                attach_mappings = function(prompt_bufnr, map)
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                      sl.commit_files(selection.value)
                    end
                  end)
                  -- Ctrl-u to goto/checkout the selected commit
                  local function goto_commit()
                    local selection = action_state.get_selected_entry()
                    if selection then
                      actions.close(prompt_bufnr)
                      vim.fn.jobstart({ 'sl', 'goto', selection.value }, {
                        on_exit = function(_, code)
                          vim.schedule(function()
                            if code == 0 then
                              vim.notify('Checked out ' .. selection.value, vim.log.levels.INFO)
                            else
                              vim.notify('Failed to checkout ' .. selection.value, vim.log.levels.ERROR)
                            end
                          end)
                        end,
                      })
                    end
                  end
                  map('i', '<C-u>', goto_commit)
                  map('n', '<C-u>', goto_commit)
                  return true
                end,
              }):find()
            end)
          end,
        })
      end

      -- Register keybinding for Sapling stack
      vim.keymap.set('n', '<leader>sl', sl.stack, { desc = 'Sapling stack' })

      --------------------------------------------------
      -- Portable Sapling diff file pickers
      --------------------------------------------------

      -- Helper: Parse sl diff output into file entries with first line numbers
      local function parse_diff_files(diff_output)
        local files = {}
        local current_file = nil
        local first_line = nil

        for line in diff_output:gmatch("[^\n]+") do
          -- Match diff header: diff --git a/path b/path
          local file = line:match("^diff %-%-git a/(.-) b/")
          if file then
            if current_file then
              table.insert(files, { filename = current_file, lnum = first_line or 1 })
            end
            current_file = file
            first_line = nil
          end
          -- Match hunk header to get first line number: @@ -N,N +M,M @@
          if current_file and not first_line then
            local lnum = line:match("^@@ .-%+(%d+)")
            if lnum then
              first_line = tonumber(lnum)
            end
          end
        end
        -- Add last file
        if current_file then
          table.insert(files, { filename = current_file, lnum = first_line or 1 })
        end
        return files
      end

      -- Attach mappings: open file at line number with filetype detection
      local function attach_with_filetype(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection and selection.filename then
            vim.cmd("edit " .. vim.fn.fnameescape(selection.filename))
            if selection.lnum then
              vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
            end
            vim.cmd("filetype detect")
          end
        end)
        return true
      end

      -- Entry maker for diff file pickers
      local function make_diff_entry_maker(entry)
        return {
          value = entry.filename,
          ordinal = entry.filename,
          display = entry.filename,
          filename = entry.filename,
          lnum = entry.lnum,
        }
      end

      -- Async refresh picker with parsed diff output
      local function refresh_picker_with_diff(picker, diff_cmd, empty_msg)
        vim.fn.jobstart(diff_cmd, {
          stdout_buffered = true,
          on_stdout = function(_, diff_data)
            if diff_data then
              local diff_output = table.concat(diff_data, "\n")
              local files = parse_diff_files(diff_output)
              vim.schedule(function()
                if #files == 0 then
                  vim.notify(empty_msg, vim.log.levels.WARN)
                elseif picker then
                  picker:refresh(finders.new_table({
                    results = files,
                    entry_maker = make_diff_entry_maker,
                  }), { reset_prompt = false })
                end
              end)
            end
          end,
        })
      end

      -- Diff file picker for uncommitted changes (against base of stack)
      local function sl_diff_files(opts)
        opts = opts or {}
        local base = nil

        -- Create picker immediately with empty finder
        local picker = pickers.new(opts, {
          prompt_title = "Changed Files (uncommitted)",
          finder = finders.new_table({
            results = {},
            entry_maker = make_diff_entry_maker,
          }),
          previewer = make_async_buffer_previewer("Diff", function(entry)
            local cmd = { "sl", "diff" }
            if base then
              table.insert(cmd, "-r")
              table.insert(cmd, base)
            end
            table.insert(cmd, entry.filename)
            return cmd
          end, 'diff'),
          sorter = conf.file_sorter(opts),
          attach_mappings = attach_with_filetype,
        })
        picker:find()

        -- Async: get base revision, then get diff
        vim.fn.jobstart({ 'sl', 'log', '-r', 'last(ancestors(.) & public())', '--template', '{node|short}' }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and data[1] and data[1] ~= '' then
              base = data[1]:gsub('%s+$', '')
            end
          end,
          on_exit = function()
            local diff_cmd = base and { "sl", "diff", "-r", base } or { "sl", "diff" }
            refresh_picker_with_diff(picker, diff_cmd, "No changed files")
          end,
        })
      end

      -- Diff file picker for a specific commit
      local function sl_show_files(rev)
        rev = rev or "."

        -- Create picker immediately with empty finder
        local picker = pickers.new({}, {
          prompt_title = "Changed Files (" .. rev .. ")",
          finder = finders.new_table({
            results = {},
            entry_maker = make_diff_entry_maker,
          }),
          previewer = make_async_buffer_previewer("Diff", function(entry)
            return { "sl", "diff", "-c", rev, entry.filename }
          end, 'diff'),
          sorter = conf.file_sorter({}),
          attach_mappings = attach_with_filetype,
        })
        picker:find()

        -- Async: get diff output and refresh picker
        refresh_picker_with_diff(picker, { "sl", "diff", "-c", rev }, "No changed files in commit")
      end

      -- Sapling diff keybindings
      vim.keymap.set('n', '<leader>sd', sl_diff_files, { desc = 'Sapling diff files (uncommitted)' })
      vim.keymap.set('n', '<leader>ss', function() sl_show_files() end, { desc = 'Sapling show files (current commit)' })

      -- Keybindings
      -- Ctrl-P for file finding
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

--------------------------------------------------
-- Open Telescope when opening a directory
--------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      -- Delete the directory buffer and open Telescope
      vim.cmd("bd")
      require('telescope.builtin').find_files({ cwd = arg, follow = true, hidden = true })
    end
  end,
  desc = "Open Telescope find_files when opening a directory",
})

-- Also handle directories opened mid-session (e.g., :e somedir/)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bufname = vim.fn.expand("%")
    if bufname ~= "" and vim.fn.isdirectory(bufname) == 1 then
      local dir = vim.fn.expand("%:p")
      vim.schedule(function()
        vim.cmd("bd!")
        require('telescope.builtin').find_files({ cwd = dir, follow = true, hidden = true })
      end)
    end
  end,
  desc = "Open Telescope find_files when entering a directory buffer",
})

--------------------------------------------------
-- :Ex command (netrw replacement)
--------------------------------------------------
vim.api.nvim_create_user_command('Ex', function()
  require('telescope.builtin').find_files({ cwd = vim.fn.getcwd(), follow = true, hidden = true })
end, { desc = 'Explore files in cwd' })
