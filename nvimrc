call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

call plug#end()

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
"let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#syntastic#enabled = 1
" enable tabs for buffers at the top
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
let g:airline_powerline_fonts = 1
let g:airline_symbols = {}

set nowrap
set relativenumber
set number
set ts=2
set sw=2
set expandtab
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2
let mapleader = ','
