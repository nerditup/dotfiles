" VIM Configuration

colors gruvbox      " choose a color scheme
set background=dark " set the background to be dark (can also be light)

" Plug-in Management
execute pathogen#infect()

" Airline Plug-in
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Javascript Plug-in
let g:javascript_plugin_jsdoc = 1

syntax enable       " enable syntax processing

" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in TAB when editing
set expandtab       " tabs are spaces

" Folding
set foldmethod=syntax
set foldcolumn=1    " Show a single character in the fold column
set foldlevel=20    " Open all of the folds on load

" UI Config
set number          " show line numbers
set showcmd         " show command in bottom bar
" set cursorline      " highlight current line

" Pretty Print XML Syntax
function PrettyXML()
    %!xmllint --format %
endfunction
