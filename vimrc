" load plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set mouse=a " enable the mouse
filetype on " turn on filetype detection
syntax on   " turn on syntax highlighting
filetype indent on " turns on filetype specific indents from ~/.vim/indent/*

" case insensitivity for path completion.
" Set if exists (it doesn't for windows) avoids error on vim start.
if exists("&wildignorecase")
    set wildignorecase
endif

" shiftwidth deals with < and >.  tabstop deals with visual tab size.  softtabstop is
" for tab size while editing (e.g. backspacing). You probably want these all equal.
set tabstop=4 shiftwidth=4 softtabstop=4
set expandtab " spaces, not tabs

"set number      " show line numbers
set showcmd     " show last command entered at the bottom
set cursorline  " highlight the current line
set wildmenu    " visual autocomplete for command line.  Might be useful.
set lazyredraw  " supposedly speeds up things like macros
set showmatch   " highlight matching [{()}].  This seems to be default anyway.
set scrolloff=1 " always show 1 line above/below the current one
set laststatus=2    " make windows always show status line (even if there's only 1 open buffer)

" make maximization work on Windows (unsure this does anything)
au GUIEnter * simalt ~x

" search settings
set incsearch   " search as characters are entered
set hlsearch    " highlight all matches
nnoremap ,<space> :nohlsearch<CR>


""" Filetype specific settings follow.
" Use setlocal instead of set so the command only affects the current buffer
" instead of all buffers

" Makefile settings
autocmd FileType make setlocal shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab

" Coffeescript, scss, javascript and typescript settings
autocmd Filetype coffee,scss,javascript,typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

""" END filetype specific settings




" Match trailing whitespace and anything past 100 characters and color it red.
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\(\s\+$\|\%100v.\+\)/

" when editing a file, jump to last cursor position
au BufReadPost * normal g'"

" auto set file types (most do this by default)
" ts => typescript
au BufRead,BufNewFile *.ts set filetype=typescript

" use bash aliases when running shell commands from vim
let $BASH_ENV = "~/.bash_aliases"
