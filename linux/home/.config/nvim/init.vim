" Not not open as readonly (for vimdiff)
set noro
" Show line numbers
set nu
" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Disable auto-ident when pasting
set paste
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugins')
Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'
call plug#end()

" Palenight
set background=dark
colorscheme palenight
let g:lightline = { 'colorscheme': 'palenight' }
if (has("termguicolors"))
"  set termguicolors
endif
