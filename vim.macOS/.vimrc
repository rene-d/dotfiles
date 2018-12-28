filetype plugin indent off
syntax on
"colorscheme torte
colorscheme delek

" Make Vim more useful
set nocompatible

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Don’t add empty newlines at the end of files
set binary
set noeol

" Respect modeline in files
set modeline
set modelines=4

" Enable line numbers
set number
set ruler
"set cursorcolumn
"set cursorline

" Highlight searches
set hlsearch
" Ignore case of searches
"set ignorecase
" Highlight dynamically as pattern is typed
"set incsearch

" Show the filename in the window titlebar
set title

" Enable mouse in all modes
set mouse=a


" Change mapleader
let mapleader=","

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>


" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif


"au BufNewFile,BufRead *.gp                  setf gnuplot
"au BufNewFile,BufRead *.gnuplot                  setf gnuplot

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


filetype plugin indent on

if has("gui_macvim")
    " set macvim specific stuff
    colorscheme torte
endif


" pylint.vim plugin
autocmd FileType python compiler pylint
let g:pylint_onwrite = 0

set laststatus=2
set ruler



" mieux que rien...
autocmd BufNewFile,BufRead *.ts setlocal filetype=javascript
