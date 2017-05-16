" VIM Configuration

colors slate        " choose a color scheme

syntax enable       " enable syntax processing

" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in TAB when editing
set expandtab       " tabs are spaces

" UI Config
set number          " show line numbers
set showcmd         " show command in bottom bar
" set cursorline      " highlight current line

" Pretty Print XML Syntax
function PrettyXML()
    %!xmllint --format %
endfunction
