" Shared Vim Configuration
" Used by both vim (via vimrc) and nvim (via init.lua)
" Contains editor settings, appearance, and keybindings
" Does NOT include colors, themes, or plugin-specific configurations

"""""""""""""""""""""""""""""
" Basic Settings
"""""""""""""""""""""""""""""
" Set text width to 80 characters (historical terminal width, improves readability)
" 80-char limit promotes concise code and allows side-by-side editor windows
set textwidth=80

" Visual column guide at textwidth+1 (column 81)
" Displays vertical line showing where text wrapping occurs
set colorcolumn=+1

" Format options for automatic text wrapping
" formatoptions+=l - Don't break long lines that were already long when entering insert mode
"                    (prevents reformatting existing long lines)
" formatoptions-=t - Disable automatic text wrapping while typing in insert mode
"                    (allows manual control over line breaks)
set formatoptions+=l
set formatoptions-=t

" Additional file type associations
" Treat .include files as shell scripts (common in build systems/configs)
au BufRead,BufNewFile *.include set ft=sh

"""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""
" Enable line numbers in gutter (left margin)
set number

" Width of line number gutter (3 digits = supports files up to 999 lines comfortably)
set numberwidth=3

" Highlight the line containing the cursor
" Makes it easy to see current line in long files
set cursorline

" Show cursor position (line, column) in status bar
set ruler

" Don't show mode indicator (-- INSERT --, -- VISUAL --, etc.) on command line
" Statusline plugins like lualine already show the mode
set noshowmode

" Set leader key to spacebar
" Leader key is prefix for custom keybindings (e.g., <leader>w for custom command)
let mapleader = " "

" Optimize redrawing for faster scrolling in terminal
" Assumes fast terminal connection (standard for modern terminals)
set ttyfast

"""""""""""""""""""""""""""""
" Editing Behavior
"""""""""""""""""""""""""""""
" Enable backspace to delete indent, end-of-line, and characters inserted before insert mode
" Makes backspace behave like modern editors (vs vi's limited backspace)
" Note: Line 40 is redundant with line 41, but kept for compatibility
set backspace=2
set backspace=indent,eol,start

" Disable swap files (.swp)
" Swap files cause clutter and modern editors have better crash recovery
" See: http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set noswapfile

" Display incomplete commands in bottom-right while typing
" Shows partial command sequence (e.g., "d" when typing "dd")
set showcmd

" Always display status line (even with single window)
" Value 2 = always show, 1 = only with 2+ windows, 0 = never
set laststatus=2

" Visualize whitespace characters (tabs and end-of-line)
" Helps maintain consistent indentation and spot trailing whitespace
set list

" Whitespace character symbols
" tab:▸  - Display tabs as ▸ followed by space (▸   for 2-space tabs)
" eol:¬  - Display end-of-line as ¬ character
set listchars=tab:▸\ ,eol:¬

" Tab and indentation settings (2-space indent with soft tabs)
" softtabstop=2 - Treat 2 spaces as single tab when backspacing
" tabstop=2     - Display width of actual tab character (if encountered)
" shiftwidth=2  - Indent width for >> and << operators
" expandtab     - Convert tabs to spaces (soft tabs)
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab

" Disable code folding by default
" Code folding can hide code unexpectedly; disabled for transparency
set nofoldenable

" Enable incremental search (highlight matches as you type)
" Shows search results while typing search pattern
set incsearch

" Clear search highlighting when pressing Enter in normal mode
" First <CR> clears highlight, second <CR> acts as normal Enter
" This prevents search highlights from persisting after finding what you need
nnoremap <CR> :nohlsearch<CR><CR>

" Insert blank lines without entering insert mode
" Shift-Enter - Insert line above cursor and stay in normal mode
" Enter       - Insert line below cursor and stay in normal mode
" Useful for quickly adding spacing without leaving normal mode
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k

" Soft line wrapping at word boundaries (not mid-word)
" When lines are longer than window width, wrap at whitespace
set linebreak

" Enable visual autocomplete menu for vim command-line
" Shows suggestions when typing ex commands (e.g., :e, :set)
set wildmenu
