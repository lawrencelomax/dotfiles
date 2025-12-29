" Shared Vim Configuration
" Used by both vim (via vimrc) and nvim (via init.lua)
" Contains editor settings, appearance, and keybindings
" Does NOT include Vundle or plugin-specific configurations

"""""""""""""""""""""""""""""
" Themes and Colors
"""""""""""""""""""""""""""""
" Enable Syntax Highlighting
syntax on

" Set theme
colorscheme desert

" 256 colors in terminal
set t_Co=256

" Color Overrides
highlight Normal ctermbg=NONE
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0
highlight ColorColumn ctermbg=23 guibg=#2c2d27

" Set Text Gutter at 80 chars
set textwidth=80
set colorcolumn=+1
" Long lines are not broken in INSERT mode
set formatoptions+=l
set formatoptions-=t

" Additional file type associations
au BufRead,BufNewFile *.include set ft=sh

"""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""
" Use Linenumber
set number
set numberwidth=3

" Highlight Tab Stops
syn match tab display "\t"
" Display tabs as errors
hi link tab Error

" Display the Current Line with a Cursor
set cursorline
set ruler

" Leader
let mapleader = " "

" Increasing Drawing Performance
set ttyfast

"""""""""""""""""""""""""""""
" Editing Behavior
"""""""""""""""""""""""""""""
" Backspace deletes like most programs in insert mode
set backspace=2
set backspace=indent,eol,start

" http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set noswapfile
" display incomplete commands
set showcmd
" Always display the status line
set laststatus=2

" Show Whitepace Characters
set list
set listchars=tab:▸\ ,eol:¬
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab

" Disable folding
set nofoldenable

" Search as you type
set incsearch
nnoremap <CR> :nohlsearch<CR><CR>

" Inserting with newline with 'o' won't result in moving to insert mode
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k

" Word wrap on soft line wrap
set linebreak

" Add the Visual autocomplete menu for the Vim Command Line
set wildmenu
