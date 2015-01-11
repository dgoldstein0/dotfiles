set mouse=a
syntax on
set tabstop=4
set shiftwidth=4
set expandtab "spaces, not tabs

" Coffeescript settings
autocmd Filetype coffee set tabstop=2|set shiftwidth=2
autocmd Filetype scss set tabstop=2|set shiftwidth=2

" Match trailing whitespace, tabs, and anything past 80 characters,
" and color it yellow.
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\(\s\+$\|\t\|\%100v.\+\)/

" when editing a file, jump to last cursor position
au BufReadPost * normal g'"
