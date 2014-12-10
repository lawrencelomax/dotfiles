"""""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""""

" Begin Vundle lugins
set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The Super awesome file manager¬
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'

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

" Nesting sessions with double prefix
Bundle 'christoomey/vim-tmux-navigator'

" Themes¬
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'

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
let &colorcolumn="80,".join(range(120,999),",")

"""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""

" Use Linenumber, Relative
set relativenumber
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

" CtrlP Starts in MRU
let g:ctrlp_cmd = 'CtrlPMRU'
