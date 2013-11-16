filetype off
execute pathogen#infect()

set number
set ai
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set ruler
set background=dark
set cmdheight=2
set laststatus=2
set scrolloff=3
set virtualedit=all
" Allow backspacing set backspace=indent,eol,start

" Status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)\ [%p%%]\ Buf:%n\ [%b][0x%B]

" Disable clearing scrollback buffer when exiting vim
set t_ti= t_te=
set incsearch
set hlsearch
set ignorecase
set cursorline
filetype plugin on

set t_Co=256
" Jellybeans colors
set background=dark
colorscheme jellybeans
"let g:solarized_termtrans=1

" Add dictionary completion
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" Add dictionary to complete list
:set complete-=k complete+=k

syntax on
noremap <F4> :set hlsearch! <cr>
noremap <F8> :TagbarToggle <CR>

inoremap jj <esc>

" Find todos
nmap ,p :w \|!grep -r '\# TODO:' ./ \| grep ^./<cr>

" Make sure ruby syntax is OK
nmap ,c :w \|!ruby -c % <cr>

" Test files using rspec
nmap ,tr :w \|!rspec -I ./ % --format=doc --color <cr>

" Build tags for current directory using exuberant c-tags
nmap ,ta :w \|!ctags -R . <cr>

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gj :CommandTFlush<cr>\|:CommandT public/javascripts<cr>

let g:CommandTCursorStartMap='<leader>f'
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>

nmap ,, <C-^>

nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
nmap <C-h> <C-w><Left>
nmap <C-l> <C-w><Right>
nmap <C-t> :CtrlPMixed<CR>

" contents of last global command in new window
nmap <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>

" toggle line numbers
nmap <F12> :set number!<CR>

nmap :Q :q

highlight Pmenu ctermbg=238 gui=bold
highlight PMenu gui=bold guibg=#CECECE guifg=#444444
highlight SpecialKey guifg=#4a4a59



set list
set encoding=utf-8
" use the same symbols as textmate for tabstops and eols
set listchars=trail:~,nbsp:*,tab:▸\ ,eol:¬
