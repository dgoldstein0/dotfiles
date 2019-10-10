" load plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" enable normal backspace behavior
set backspace=indent,eol,start

set mouse=a " enable the mouse
" make dragging the vsplit divider with the mouse work.  Seems to work by default
" in ubuntu over putty but not for git-for-windows - probably because the ttymouse
" defaults to xterm there instead of xterm2, per
" http://superuser.com/questions/549930/cant-resize-vim-splits-inside-tmux
if &term == "xterm"
    set ttymouse=xterm2
endif

filetype on " turn on filetype detection
syntax on   " turn on syntax highlighting
filetype indent on " turns on filetype specific indents from ~/.vim/indent/*
filetype plugin on " for pytest.vim to work

" path completion settings
set wildmenu    " visual autocomplete for command line.
" case insensitivity.
" Set if exists (it doesn't for windows with msysgit vim) avoids error on vim start.
if exists("&wildignorecase")
    set wildignorecase
endif
" ignore *.pyc for filename autocompletion
set wildignore=*.pyc

" shiftwidth deals with < and >.  tabstop deals with visual tab size.  softtabstop is
" for tab size while editing (e.g. backspacing). You probably want these all equal.
set tabstop=4 shiftwidth=4 softtabstop=4
set expandtab " spaces, not tabs

set ruler       " show the current cursor position in the bottom right of the buffer
"set number      " show line numbers
set showcmd     " show last command entered at the bottom
set cursorline  " highlight the current line
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

""" Overrides to mark certain nonstandard files as certain types
" Use setlocal instead of set so the command only affects the current buffer
" instead of all buffers
autocmd BufRead,BufNewFile *.pyst setlocal filetype=python
autocmd BufRead,BufNewFile .gitconfig* setlocal filetype=gitconfig

""" Filetype specific settings follow.
" Makefile settings
autocmd FileType make setlocal shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab

" Coffeescript, scss, javascript, scala, yaml, and typescript settings
" and puppet (conf = .pp files)
autocmd FileType conf,coffee,scss,javascript,typescript,scala,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

""" END filetype specific settings

" Match trailing whitespace
highlight ExtraChars ctermbg=red guibg=red
autocmd BufWinEnter * call matchadd('ExtraChars', '\(\s\+$\)')

" highlight anything past 100 characters... for some filetypes
autocmd BufWinEnter *.py,*.coffee,*.js,*.ts call matchadd('ExtraChars', '\(\%100v.\+\)')
" supposedly clearing matches when leaving a buffer fixes a memory leak.
" function only available in vim 7.2+
autocmd BufWinLeave * call clearmatches()

" when editing a file, jump to last cursor position
au BufReadPost * normal g'"

" auto set file types (most do this by default)
" ts => typescript
au BufRead,BufNewFile *.ts set filetype=typescript

" use bash aliases when running shell commands from vim
let $BASH_ENV = "~/.vim_bash_env"

""" plugin settings
" turn off quote concealment for vim-json
let g:vim_json_syntax_conceal = 0

" ignore filetypes for nerdtree
let NERDTreeIgnore=['\.pyc$', '\~$']

""" Syntastic settings
" some of the suggested defaults for syntastic.  Don't clobber the statusline.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

" disable pylint, since it seems to not follow the configured python paths.
" arc works... but is really slow.
let g:syntastic_python_checkers = ['flake8'] " todo make pyxl-python syntaxt checker work
let g:syntastic_coffee_checkers = ['coffee', 'coffeelint'] " arc should run coffeelint... but arc lint via syntastic is disabled for now

" use tsuquyomi for syntastic typescript checking, instead of tsuquyomi's
" default quickfix stuff.  syntastic is slightly nicer.
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']

" This checks on each change of window whether there's only one window left, and if that one is a quickfix / location list, it quits Vim.  Not exactly what I want, but it's a start.
autocmd WinEnter * if &buftype ==# 'quickfix' && winnr('$') == 1 | quit | endif

" vim launched via git having the wrong $SHELL env variable.  This works around that.
set shell=bash

""" vim-markdown settings
let g:vim_markdown_folding_disabled = 1

""" gundo settings
" gundo defaults to trying to use py2, make it use py3 instead.  this is necessary
" if vim is compiled with py3 instead of py2, and using both together is usually also problematic
let g:gundo_prefer_python3 = 1
" set up ctrl+u to toggle the gundo panel
nnoremap <c-u> :GundoToggle<CR>

""" more undo stuff - persist undo history between sessions
set undodir=~/.vim/undo-dir
set undofile

""" Diffusion links
function! DiffusionLink()
  let line_number = line('.')
  let full_path = expand('%:p')
  if full_path !~ "^/srv/server/"
    echo "File is not in server repo"
    return
  endif
  let rel_path = substitute(full_path, "^/srv/server/", "", "")
  let rev = substitute(system("git rev-parse master"), '\n\+$', '', '')
  let link = "https://tails.corp.dropbox.com/diffusion/SERVER/browse/master/" . rel_path . ";" . rev . "$" . line_number
  echo link
endfunction
command! DiffusionLink call DiffusionLink()

""" prettier typescript on save
augroup fmt
  autocmd!
  autocmd BufWritePre *.tsx undojoin | Neoformat
  autocmd BufWritePre *.ts undojoin | Neoformat
augroup END

autocmd BufWritePost *.tsx | SyntasticCheck
autocmd BufWritePost *.ts | SyntasticCheck
