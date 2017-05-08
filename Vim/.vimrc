" VIM Configuration

" Plug-in Management
execute pathogen#infect()

syntax enable       " enable syntax processing

" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in TAB when editing
set expandtab       " tabs are spaces

" UI Config
set number          " show line numbers
set showcmd         " show command in bottom bar
set cursorline      " highlight current line

" Tab Line
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
