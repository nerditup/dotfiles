" VIM Configuration
"
colorscheme desert 

syntax enable           " enable syntax processing

" Spaces & Tabs
set tabstop=4           " number of visual spaces per TAB
set shiftwidth=4        " number of spaces per TAB
set softtabstop=4       " number of spaces in TAB when editing
set expandtab           " tabs are spaces

" Folding
set foldmethod=syntax   " Fold on syntax
set foldcolumn=1        " Show a single character in the fold column
set foldlevel=20        " Open all of the folds on load

" UI Config
set number              " show line numbers
set showcmd             " show command in bottom bar
" set cursorline          " highlight current line
