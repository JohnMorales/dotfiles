call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nathanaelkane/vim-indent-guides'

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

set autochdir
" Filenames for the tag command
set tags=./tags;$HOME,./ctags;$HOME,./.vimtags;$HOME
" Do not wrap lines longer than the window's width
set nowrap
set relativenumber
set number
set ts=2
set sw=2
set expandtab
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2
let mapleader = ','

" By default denite uses find
call denite#custom#var('file_rec', 'command',
	\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#source(
	\ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
call denite#custom#source('file_mru', 'converters',
	      \ ['converter_relative_word'])
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

nnoremap <silent> <c-p> :Denite file_mru source buffer file_rec line<cr>
imap jj <Esc>
nnoremap <leader>sw :StripWhitespace<cr>
map <leader>m :NERDTreeToggle<CR>

"guicolors
set termguicolors
