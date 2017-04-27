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
Plugin 'kien/ctrlp.vim'

" Silver Surfer Commands
Plugin 'rking/ag.vim'

" Zoomwin for Making Splits fullscreen then back
Plugin 'taylor/vim-zoomwin'

" The Nice line at the bottom of the screen¬
Plugin 'itchyny/lightline.vim'

" Syntastic for syntax checking
" Don't forget to run:
Plugin 'scrooloose/syntastic'

" Tagbar
Plugin 'majutsushi/tagbar'

" Integrate with Arcanist
Plugin 'phleet/vim-arcanist'

" Indexed incremental search
Plugin 'henrik/vim-indexed-search'

" Fast Semantic Completion
" ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
Plugin 'Valloric/YouCompleteMe'

call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""""
" Themes
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

" Additional matching of FileTypes
au BufRead,BufNewFile *.include set ft=sh

" Default Per-Language Checkers
let g:syntastic_haskell_checkers = ['hlint', 'hdevtools']
let g:syntastic_python_checkers = ['python', 'flake8', 'pyflakes', 'mypy']
let g:syntastic_php_checkers = []

" hdevtools jump to definitions
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" Python, supress some noisy errors
let g:syntastic_python_flake8_args='--ignore=E501,E302'
let g:syntastic_python_pep8_args='--ignore=E501,E302'

""""""""""""""""""""""""""""""
" YouCompleteMe
""""""""""""""""""""""""""""""
" YouCompleteMe https://github.com/Valloric/YouComplete
" Don't complete until there are at least a few chars
let g:ycm_min_num_of_chars_for_completion = 3

" Disable automatic triggering, use <C-Space> to manually trigger
let g:ycm_auto_trigger = 3
let g:ycm_key_invoke_completion = '<C-Space>'

" Accept Completion with Enter as well
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

""""""""""""""""""""""""""""""
" Plugin Configuration
""""""""""""""""""""""""""""""
" Focus on the Tagbar
let g:tagbar_autofocus = 1

" Opens the CtrlP Tag Searcher
" Alt+t is all buffers
" Alt+T is the current buffer
nmap <silent> † :CtrlPTag<CR>
nmap <silent> ˇ :CtrlPBufTag<CR>

" Open the TagBar with Ctrl-shift-t
nmap <silent> <C-S-t> :TagbarToggle<CR>

" CtrlP Starts in MRU
let g:ctrlp_cmd = 'CtrlPMRUFiles'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$' }

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

" Add the Visual autocomplete menu for the Vim Command Line
set wildmenu
