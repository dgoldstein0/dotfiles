" First set a bunch of defaults.
set mouse=a
filetype on
syntax on

" case insensitivity for path completion
set wildignorecase

" shiftwidth deals with < and >.  tabstop deals with tab size.
" You probably want these equal.
set tabstop=4 shiftwidth=4
set expandtab "spaces, not tabs


""" Filetype specific settings follow.
" Use setlocal instead of set so the command only affects the current buffer.

" Makefile settings
autocmd FileType make setlocal shiftwidth=8 tabstop=8 noexpandtab

" Coffeescript & scss settings
autocmd Filetype coffee,scss,javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab

""" END filetype specific settings




" Match trailing whitespace and anything past 100 characters and color it red.
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\(\s\+$\|\%100v.\+\)/

" when editing a file, jump to last cursor position
au BufReadPost * normal g'"

" auto set file types (most do this by default)
au BufRead,BufNewFile *.ts set filetype=typescript

" use bash aliases when running shell commands from vim
let $BASH_ENV = "~/.bash_aliases"
