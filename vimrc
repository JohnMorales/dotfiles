filetype off
execute pathogen#infect()

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

" Status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)\ [%p%%]\ Buf:%n\ [%b][0x%B]

" Disable clearing scrollback buffer when exiting vim
set t_ti= t_te=
set incsearch
set hlsearch
set ignorecase
filetype plugin indent on

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
nmap <C-k> <C-w><Up>
nmap <C-j> <C-w><Down>
nmap <C-t> :CtrlPBuffer<CR>

" contents of last global command in new window
nmap <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>

" toggle line numbers
" nmap <F12> :set number!<CR>

nmap :Q :q

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
  " hi IndentGuidesEven ctermbg='Black'
  " hi IndentGuidesOdd  ctermbg='Black'
else
  " hi IndentGuidesEven ctermbg='lightgrey'
  " hi IndentGuidesOdd  ctermbg='lightgrey'
endif
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235

let g:ctrlp_working_path_mode = 'b:ra'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
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

set foldmethod=marker

" make last typed word uppercase.
:imap <c-u> <esc>viwUA
:nmap <c-u> gUiw
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
"set relativenumber
set number
" Custom extenstions
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufReadPost *.hbs set syntax=html
  au FocusLost * :set number
  au FocusGained * :set relativenumber
  au InsertEnter * :set number
  au InsertLeave * :set relativenumber
endif
"set verbose=9
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
"let g:html_indent_tags = 'html\|div\|table\|p'
"let g:html_indent_tags .= '\|p\|nav\|head'
