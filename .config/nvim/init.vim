call plug#begin('~/.config/nvim/plugged')


Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
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

Plug 'mgedmin/pythonhelper'

" Async linting engine
Plug 'w0rp/ale'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = {
  \   'python': ['flake8'],
  \}
  let g:ale_sign_column_always = 1
  let g:ale_sign_error = '⨉'
  let g:ale_sign_warning = '⚠'

Plug 'alfredodeza/pytest.vim'
nmap <silent><Leader>pf <Esc>:Pytest file -s<CR>
nmap <silent><Leader>pc <Esc>:Pytest class -s<CR>
nmap <silent><Leader>pm <Esc>:Pytest method -s<CR>

Plug 'Vimjas/vim-python-pep8-indent'

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

" Preserve selection when indenting selected blocks
vnoremap > >gv
vnoremap < <gv

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If you are using virtualenv, it is recommended that you create environments specifically for Neovim.
" This way, you will not need to install the neovim package in each virtualenv.

let g:python_host_prog = '/Users/daniel.klevebring/miniconda2/bin/python'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! UpdateMode(mode)
  if a:mode == 'i'
    hi User1 ctermbg=234 ctermfg=2
  else
    hi User1 ctermbg=0 ctermfg=12
  endif
endfunction

function! LintStatus()
  let status = ALEGetStatusLine()
  if status != ''
    return '['.status.']'
  else
    return ''
endfunction

set statusline=
set statusline +=%1*\ \%{toupper(mode())}\ \%*
set statusline +=%2*%f

" right aligned
set statusline +=%=
" set statusline +=%2*%=\ \[%{fugitive#head()}]\ \%*

"display a warning if fileformat isnt unix
set statusline +=%#warningmsg#
set statusline +=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline +=%#warningmsg#
set statusline +=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline +=%{TagInStatusLine()}
set statusline +=%{LintStatus()}
set statusline +=%*

