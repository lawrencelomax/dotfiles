" Vim-Only Plugin Configuration
" Contains Vundle setup and plugin-specific settings
" Used only by vim (not nvim)

"""""""""""""""""""""""""""""
" Vim-Specific Theme and Colors
"""""""""""""""""""""""""""""
" Enable Syntax Highlighting
syntax on

" Enable 256 color mode in terminal
" Allows vim to use full color palette instead of limited 16 colors
set t_Co=256

" Set desert colorscheme (works well in vim, but not with nvim's termguicolors)
colorscheme desert

" Color Overrides for desert theme
" Make background transparent (use terminal background color)
highlight Normal ctermbg=NONE

" Set NonText background (for ~  lines at end of buffer)
highlight NonText guibg=#060606

" Folded code highlighting (purple text on dark background)
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Column guide color (dark cyan/blue for 80-char marker)
highlight ColorColumn ctermbg=23 guibg=#2c2d27

" Highlight literal tab characters as errors (prefer spaces for indentation)
" This makes any hard tabs visible as errors to maintain consistent spacing
syn match tab display "\t"
hi link tab Error

"""""""""""""""""""""""""""""
" Vundle Setup
"""""""""""""""""""""""""""""
" Begin Vundle plugin manager configuration
set nocompatible              " Disable vi compatibility (enables vim features)
filetype off                  " Required by Vundle during plugin loading

" Add Vundle to runtime path and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage itself (required by Vundle)
Plugin 'gmarik/Vundle.vim'

" CtrlP - Fuzzy file finder and Most Recently Used files
" Press Ctrl-P to search files, navigate buffers, tags
Plugin 'kien/ctrlp.vim'

" vim-ripgrep - Integration with ripgrep (faster alternative to grep/ag)
" Provides :Rg command for fast text search across files
Plugin 'jremmen/vim-ripgrep'

" ZoomWin - Make splits fullscreen and restore
" Press <C-w>o to zoom current split, again to restore layout
Plugin 'taylor/vim-zoomwin'

" Lightline - Statusline plugin (lightweight alternative to powerline/airline)
" Displays mode, filename, git branch, file type in bottom status bar
Plugin 'itchyny/lightline.vim'

" ALE (Asynchronous Lint Engine) - Modern async syntax checker
" Replaces Syntastic with better performance (doesn't block vim)
" Runs linters in background and displays errors inline
Plugin 'w0rp/ale'

" Tagbar - Display tags (functions, classes, variables) in sidebar
" Press <C-S-t> to toggle tag browser
Plugin 'majutsushi/tagbar'

" vim-arcanist - Integration with Phabricator's arc tool
" Provides commands for code review workflow
Plugin 'phleet/vim-arcanist'

" vim-indexed-search - Shows "Match 3 of 12" when searching
" Enhances search feedback by showing match count
Plugin 'henrik/vim-indexed-search'

" YouCompleteMe - Fast semantic code completion engine
" Requires compilation: ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
" Provides intelligent autocomplete for C/C++/Python/etc.
Plugin 'Valloric/YouCompleteMe'

call vundle#end()            " Finish Vundle setup
filetype plugin indent on    " Re-enable filetype detection, plugins, and indent

""""""""""""""""""""""""""""""
" Syntastic Configuration
""""""""""""""""""""""""""""""
" Syntastic - Legacy syntax checker (mostly replaced by ALE in config above)
" https://github.com/scrooloose/syntastic

" Add Syntastic errors to statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Syntastic Options
" always_populate_loc_list - Always update location list (:lopen to view errors)
" auto_loc_list - Automatically open/close location list window when errors appear/clear
" check_on_open - Run syntax check when opening a file
" check_on_wq - Don't check when doing :wq (write-quit) to avoid delays on save+exit
" aggregate_errors - Combine errors from multiple checkers into one list
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

" Language-specific syntax checkers
" Haskell: hlint (style suggestions) + hdevtools (type checking)
let g:syntastic_haskell_checkers = ['hlint', 'hdevtools']

" Python: flake8 (style + errors) + mypy (type checking)
let g:syntastic_python_checkers = ['flake8', 'mypy']

" PHP: Disable all checkers (uncomment/add specific checkers as needed)
let g:syntastic_php_checkers = []

" Haskell development tools keybindings
" F1 - Show type of expression under cursor
" F2 - Clear type highlighting
" F3 - Show detailed info about symbol under cursor
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

" Python linter error suppression
" E501 - Line too long (>79 chars) - Ignored because 80-char limit is handled by colorcolumn
" E302 - Expected 2 blank lines, found 1 - Too strict for practical code style
let g:syntastic_python_flake8_args='--ignore=E501,E302'
let g:syntastic_python_pep8_args='--ignore=E501,E302'

""""""""""""""""""""""""""""""
" YouCompleteMe Configuration
""""""""""""""""""""""""""""""
" YouCompleteMe - Semantic code completion
" https://github.com/Valloric/YouCompleteMe

" Minimum characters before showing completions
" Value of 3 prevents popup spam while typing short words
let g:ycm_min_num_of_chars_for_completion = 3

" Auto-trigger threshold (lower = more aggressive)
" Value of 3 means completion suggestions appear after typing 3 characters
" Use Ctrl-Space to manually trigger completion anytime
let g:ycm_auto_trigger = 3
let g:ycm_key_invoke_completion = '<C-Space>'

" Keybindings for selecting completions
" TAB or Down arrow to cycle through suggestions
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

""""""""""""""""""""""""""""""
" Plugin Keybindings and Settings
""""""""""""""""""""""""""""""
" Tagbar - Automatically focus tagbar window when opened
let g:tagbar_autofocus = 1

" CtrlP Tag Search Keybindings
" † (Alt+t on macOS) - Search tags across all buffers
" ˇ (Alt+T on macOS) - Search tags in current buffer only
" These are non-ASCII characters produced by Alt+t/Alt+Shift+t on macOS keyboards
nmap <silent> † :CtrlPTag<CR>
nmap <silent> ˇ :CtrlPBufTag<CR>

" Toggle Tagbar sidebar with Ctrl-Shift-t
nmap <silent> <C-S-t> :TagbarToggle<CR>

" CtrlP Configuration
" Start in MRU (Most Recently Used) mode by default for faster workflow
" Shows recently edited files first instead of searching all project files
let g:ctrlp_cmd = 'CtrlPMRUFiles'

" CtrlP ignore patterns
" dir - Ignore VCS directories (.git, .hg, .svn) to speed up search
" file - Ignore binary files (compiled executables, libraries) that can't be edited
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$' }
