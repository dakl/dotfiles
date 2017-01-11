call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
noremap <C-p> :Files<CR>

" Autocompletion
Plug 'lifepillar/vim-mucomplete'
set completeopt+=menuone
set shortmess+=c
set completeopt+=noinsert,noselect
let g:mucomplete#enable_auto_at_startup = 1

" Omnicompletion/static analysis library for Python
Plug 'davidhalter/jedi'
Plug 'davidhalter/jedi-vim'
set completeopt+=longest
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 1
let g:jedi#show_call_signatures = "1"

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" put yanked stuff in system register "*
set clipboard=unnamed

" don't wrap lines
set nowrap

" undofile
set undofile
set undodir=$HOME/.vim_undo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Interface and visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Show a visual line under the cursor's current line
set cursorline

" Show current line/column
set ruler

" Use 256 colors
set t_Co=256

" Dont syntax highlight more then 256 chars
set synmaxcol=256
syntax sync minlines=256

" Don't redraw on non typed commands
set lazyredraw

" Use a blinking upright bar cursor in Insert mode, a solid block in normal
" and a blinking underline in replace mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[2 q"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set tabs to have 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Indent when moving to the next line while writing code
set autoindent

" Preview substitutions as you type
set inccommand=nosplit

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Netrw, borrowed from mcantor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <D-Z> u 
map! <D-Z> <C-O>u 


