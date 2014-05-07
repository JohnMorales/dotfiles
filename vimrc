filetype off
"execute pathogen#infect()

" Vundle configuration
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" A bit meta..
Plugin 'gmarik/Vundle.vim'

Plugin 'git://github.com/kien/ctrlp.vim.git'
Plugin 'git://github.com/scrooloose/nerdtree.git'
Plugin 'git://github.com/epmatsw/ag.vim.git'
Plugin 'git://github.com/taiansu/nerdtree-ag.git'
Plugin 'git://github.com/altercation/vim-colors-solarized.git'
Plugin 'git://github.com/tpope/vim-surround.git'
Plugin 'git://github.com/bling/vim-airline.git'
Plugin 'git://github.com/scrooloose/syntastic.git'
Plugin 'git://github.com/tpope/vim-repeat.git'
Plugin 'git://github.com/terryma/vim-multiple-cursors.git'
Plugin 'git://github.com/kana/vim-textobj-user.git'
Plugin 'git://github.com/nelstrom/vim-textobj-rubyblock.git'
Plugin 'git://github.com/Raimondi/delimitMate.git'
Plugin 'git://github.com/Valloric/YouCompleteMe.git'
Plugin 'git://github.com/SirVer/ultisnips.git'
Plugin 'git://github.com/honza/vim-snippets.git'
Plugin 'git://github.com/JohnMorales/bootstrap-snippets.git'
Plugin 'git://github.com/nathanaelkane/vim-indent-guides.git'
"Plugin 'git://github.com/JazzCore/ctrlp-cmatcher.git'


call vundle#end()            " required
filetype plugin indent on
" End vundle

" cmatcher
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

set nowrap
set ai
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab
set ruler
set cmdheight=2
set laststatus=2
set scrolloff=3
set virtualedit=all
" Allow backspacing
set backspace=indent,eol,start
set modeline
set modelines=5
runtime macros/matchit.vim
set backupdir=~/.backup,/tmp
set dir=/tmp
set nocompatible
" Status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)\ [%p%%]\ Buf:%n\ [%b][0x%B]

" Disable clearing scrollback buffer when exiting vim
set t_ti= t_te=
set incsearch
set nohls
set ignorecase

" let g:solarized_termcolors=256
"set t_Co=256
" Jellybeans colors
" let g:solarized_termcolors=16
let g:solarized_bold = 0
if $ITERM_PROFILE == "SolarizedLight"
  " echo "Setting light background"
  set background=light
  colorscheme solarized
  set cursorline
elseif $ITERM_PROFILE == "Misterioso"
  " echo "Setting dark background"
  set background=dark
  colorscheme tomorrow-night
elseif $ITERM_PROFILE == "SolarizedDark"
  " echo "Setting dark background"
  set background=dark
  colorscheme solarized
  set cursorline
else
  set background=dark
  colorscheme default
endif
"colorscheme jellybeans
"Only useful if using transparent backgrounds.
" let g:solarized_termtrans=1

" Add dictionary completion
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" Add dictionary to complete list
:set complete-=k complete+=k

syntax on
noremap <F4> :set hlsearch! <cr>
noremap <F8> :TagbarToggle <CR>

"inoremap jj <esc>

" Find todos
"nmap ,p :w \|!grep -r '\# TODO:' ./ \| grep ^./<cr>
"
"" Make sure ruby syntax is OK
"nmap ,c :w \|!ruby -c % <cr>
"
"" Test files using rspec
"nmap ,tr :w \|!rspec -I ./ % --format=doc --color <cr>
"
" Build tags for current directory using exuberant c-tags
nmap ,ta :!ctags -R . <cr>

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
nmap <C-k> <C-w><Up>
nmap <C-j> <C-w><Down>
nmap <C-t> :CtrlPBuffer<CR>
nmap <leader>r :CtrlPMRU<CR>
" contents of last global command in new window
nmap <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>

" toggle line numbers
" nmap <F12> :set number!<CR>

nmap :Q :q
nmap <leader>tr :%s/\s\+$//g<CR>:w<CR>:e<CR>

" TODO: figure out what PMenu and SpecialKey do.
" highlight Pmenu ctermbg=238 gui=bold
" highlight PMenu gui=bold guibg=#CECECE guifg=#444444
" highlight SpecialKey guifg=#4a4a59

map <leader>j !python -m json.tool<CR>
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Determine good colors for IdentGuides.
" let g:cterm_colors = (&g:background == 'dark') ? ['darkgrey', 'black'] : ['lightgrey', 'white']
" let g:gui_colors   = (&g:background == 'dark') ? ['grey15', 'grey30']  : ['grey70', 'grey85']
if &g:background == 'dark'
   hi IndentGuidesEven ctermbg='Black'
   hi IndentGuidesOdd  ctermbg='Black'
else
   hi IndentGuidesEven ctermbg='lightgrey'
   hi IndentGuidesOdd  ctermbg='lightgrey'
endif
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type d -depth +0 -name ".*" -prune -o -type f -print'
  \ }
nmap ,n :NERDTreeFind<CR>
nmap ,m :NERDTreeToggle<CR>

function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
   \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
map <C-d> YP
nmap cp cw<C-r>0<esc>b

" unmapping Ex mode
:map Q <Nop>

" quote single
map <leader>' ysiw'
map <leader>" ysiw"
nnoremap <leader>cs cs"'
nnoremap <leader>cd cs'"

set foldmethod=marker

" make last typed word uppercase.
":imap <c-u> <esc>viwUA
":nmap <c-u> gUiw
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

set number
set relativenumber
"set number
" Custom extenstions
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufReadPost *.hbs set ft=html
  au BufReadPost *.bats set ft=sh
  au BufReadPost *.md set ft=markdown
endif
"set verbose=9
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
"let g:html_indent_tags = 'html\|div\|table\|p'
"let g:html_indent_tags .= '\|p\|nav\|head'
"Still figuring this one out.
map <leader>d c<div><C-R>"</div><ESC>
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
inoremap jk <Esc>
nmap ,t :TagbarToggle<CR>


let g:ycm_key_list_previous_completion = ['<UP>']
let delimitMate_expand_cr = 1
