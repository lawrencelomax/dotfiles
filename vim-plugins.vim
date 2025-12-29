" Vim-Only Plugin Configuration
" Contains Vundle setup and plugin-specific settings
" Used only by vim (not nvim)

"""""""""""""""""""""""""""""
" Vundle Setup
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
Plugin 'jremmen/vim-ripgrep'

" Zoomwin for Making Splits fullscreen then back
Plugin 'taylor/vim-zoomwin'

" The Nice line at the bottom of the screen¬
Plugin 'itchyny/lightline.vim'

" Syntastic for syntax checking
" Don't forget to run:
" Plugin 'scrooloose/syntastic'
Plugin 'w0rp/ale'

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

""""""""""""""""""""""""""""""
" Syntastic Configuration
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
let g:syntastic_python_checkers = ['flake8', 'mypy']
let g:syntastic_php_checkers = []

" hdevtools jump to definitions
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" Python, supress some noisy errors
let g:syntastic_python_flake8_args='--ignore=E501,E302'
let g:syntastic_python_pep8_args='--ignore=E501,E302'

""""""""""""""""""""""""""""""
" YouCompleteMe Configuration
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
" Plugin Keybindings and Settings
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
