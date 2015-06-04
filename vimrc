"""""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""""
" Begin Vundle plugins
set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" CtrlP Fuzzzy Find & Most Recently Used
" Plugin 'Shougo/unite.vim'
Plugin 'kien/ctrlp.vim'

" Zoomwin for Making Splits fullscreen then back
Plugin 'taylor/vim-zoomwin'

" The Nice line at the bottom of the screen¬
Plugin 'itchyny/lightline.vim'

" Markdown Vim Mode
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Synctastic for awesomeness
Plugin 'scrooloose/syntastic'

" Tagbar
Plugin 'majutsushi/tagbar'

" Nesting sessions with double prefix
Plugin 'christoomey/vim-tmux-navigator'

" Themes¬
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'

" Integrate with hdevtools
Plugin 'bitc/vim-hdevtools'

" Integrate with Arcanist
Plugin 'phleet/vim-arcanist'

" Search Dash.app from Vim
Plugin 'rizzatti/dash.vim'

" Indexing incremental search
Plugin 'henrik/vim-indexed-search'

call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""""
" Themes
"""""""""""""""""""""""""""""
" Enable Syntax Highlighting
syntax on

" 256 colors in terminal
set t_Co=256 

" Set the Colorscheme 
" colorscheme solarized
" colorscheme molokai
colorscheme desert

" Color Overrides
highlight Normal ctermbg=NONE
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0
highlight ColorColumn ctermbg=23 guibg=#2c2d27

" Set Text Gutter at 80 chars
let textwidth=80
set colorcolumn=+1

""""""""""""""""""""""""""""""
" Syntastic
""""""""""""""""""""""""""""""
" Syntastic https://github.com/scrooloose/syntastic
" Use Syntastic in the Statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Options for Syntastic
" Show Location List, on Save & Use multiple checkers
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

" Default Per-Language Checkers
let g:syntastic_haskell_checkers = ['hlint', 'hdevtools']
let g:syntastic_python_checkers = ['python', 'flake8', 'pyflakes']

" hdevtools jump to definitions
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" Python, supress some noisy errors
let g:syntastic_python_flake8_args='--ignore=E501,E302'
let g:syntastic_python_pep8_args='--ignore=E501,E302'

""""""""""""""""""""""""""""""
" Plugin Configuration
""""""""""""""""""""""""""""""
" Tagbar
let g:tagbar_autofocus = 1
nmap <C-S-t> :TagbarOpen j<CR>

" CtrlP Starts in MRU
let g:ctrlp_cmd = 'CtrlPMRUFiles'

"""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""
" Use Linenumber, Relative
" set relativenumber
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
set listchars =tab:▸\ ,eol:¬
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
