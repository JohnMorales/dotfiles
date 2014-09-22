set nocompatible
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
"Plugin 'git://github.com/tpope/vim-surround.git'
Plugin 'git://github.com/bling/vim-airline.git'
Plugin 'git://github.com/scrooloose/syntastic.git'
Plugin 'git://github.com/tpope/vim-repeat.git'
Plugin 'git://github.com/terryma/vim-multiple-cursors.git'
Plugin 'git://github.com/kana/vim-textobj-user.git'
Plugin 'git://github.com/nelstrom/vim-textobj-rubyblock.git'
Plugin 'git://github.com/Raimondi/delimitMate.git'
Plugin 'git://github.com/Shougo/neocomplete.git'
Plugin 'git://github.com/Shougo/neosnippet.vim.git'
Plugin 'git://github.com/Shougo/neosnippet-snippets.git'
" Switching to neosnippets
" Plugin 'git://github.com/SirVer/ultisnips.git'
" Neosnippet doesn't fully support vim-snippets. (select mode snippets are not
" supported.
" Plugin 'git://github.com/honza/vim-snippets.git'
Plugin 'git://github.com/JohnMorales/vim-bootstrap3-snippets.git'
Plugin 'git://github.com/nathanaelkane/vim-indent-guides.git'
Plugin 'git://github.com/majutsushi/tagbar.git'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
"Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-projectionist' " Project specific plugins.
Plugin 'dbakker/vim-projectroot'
Plugin 'ivalkeen/vim-ctrlp-tjump'
Plugin 'vadv/vim-chef'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'kchmck/vim-coffee-script'


call vundle#end()            " required
filetype plugin indent on
" End vundle
" After installing a new plugin, reload the vimrc and run :PluginInstall

" cmatcher
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

" hack to support shift enter in console vim ref:http://stackoverflow.com/questions/5388562/cant-map-s-cr-in-vim
imap ✠ <S-CR>
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
" Status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)\ [%p%%]\ Buf:%n\ [%b][0x%B]

" Disable clearing scrollback buffer when exiting vim
set t_ti= t_te=
set incsearch
set ignorecase

" taken from https://github.com/vim-scripts/ingo-library/blob/master/autoload/ingo/str.vim
function! Trim( string )
  return substitute(a:string, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfunction

" let g:solarized_termcolors=256
"set t_Co=256
" Jellybeans colors
" let g:solarized_termcolors=16
let g:solarized_bold = 0
let bg_profile = Trim(substitute(system("tmux showenv -g ITERM_PROFILE"), ".*=", "", ""))
if bg_profile ==? "SolarizedLight"
  " echo "Setting light background"
  set background=light
  colorscheme solarized
  set cursorline
elseif bg_profile ==? "Misterioso"
  " echo "Setting dark background"
  set background=dark
  colorscheme tomorrow-night
elseif bg_profile ==? "SolarizedDark"
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
" highlight previous search term.
noremap <F4> :set hlsearch! <cr>
" show tagbar
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
set tags=./tags;
nnoremap <silent> <Leader>ta :ProjectRootExe !ripper-tags -R . $(bundle show --paths)<cr>
nnoremap <silent> <Leader>u :ProjectRootExe Ag<cr>

nmap ,, <C-^>

nnoremap <silent> <Leader>hm :%!xxd<cr> " Hex mode
nnoremap <silent> <Leader>bh :%!xxd -r<cr> " Back from hex

" nnoremap th  :tabfirst<CR>
" nnoremap tj  :tabnext<CR>
" nnoremap tk  :tabprev<CR>
" nnoremap tl  :tablast<CR>
" nnoremap tt  :tabedit<Space>
" nnoremap tn  :tabnext<Space>
" nnoremap tm  :tabm<Space>
" nnoremap td  :tabclose<CR>
nmap <C-h> <C-w><Left>
nmap <C-l> <C-w><Right>
nmap <C-k> <C-w><Up>
nmap <C-j> <C-w><Down>
nmap <C-t> :CtrlPBuffer<CR>
" Project level tags
nnoremap <leader>f :CtrlPTag<cr>
" File level tags
nnoremap <leader>m :CtrlPBufTag<cr>
" Jump to tags
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>
" Show recent files
nmap <leader>r :CtrlPMRU<CR>
" contents of last global command in new window
"nmap <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>
" TODO
"nmap <leader>n 
" select the current block
nmap <leader>v var
" toggle line numbers
" nmap <F12> :set number!<CR>

" Fat-fingering q.
nmap :Q :q

" Delete trailing whitespaces.
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
    \ 1: ['.git', 'cd %s && git ls-files -oc'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': '/usr/bin/find %s -maxdepth 4 -type d -depth +0 -name ".*" -prune -o -type f -print'
  \ }
nmap <silent> ,n :NERDTreeFind<CR>
nmap <silent> ,m :NERDTreeToggle<CR>

function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
   \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

nnoremap <leader>ev :ed $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
"
" Duplicate line
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
"set verbose=9
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
"let g:html_indent_tags = 'html\|div\|table\|p'
"let g:html_indent_tags .= '\|p\|nav\|head'
"Still figuring this one out.
map <leader>d c<div><C-R>"</div><ESC>
"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <Esc> 

nmap ,t :TagbarToggle<CR>


"let g:ycm_key_list_previous_completion = ['<UP>']
"let delimitMate_expand_cr = 1
let g:rootmarkers = ['.projectroot','.git','.hg','.svn','.bzr','_darcs','build.xml', 'Gemfile' ]

let g:ctrlp_tjump_shortener= ['/Users/jmorales/.rbenv/.*/gems/', 'gems/' ]
let g:ctrlp_tjump_only_silent = 1

" setting filetypes for files with multiple extensions
" http://stackoverflow.com/questions/8413781/automatically-set-multiple-file-types-in-filetype-if-a-file-has-multiple-exten
function MultiExtensionFiletype()
  let ft_default=&filetype
  let ft_prefix=substitute(matchstr(expand('%'),'\..\+\.'),'\.','','g')
  sil exe "set filetype=" . ft_prefix  . "." . ft_default
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto commands
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby set filetype=ruby.eruby.chef
" there are more in the neocomplete section
" Custom extenstions
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufReadPost *.hbs set ft=html
  au BufReadPost *.bats set ft=sh
  au BufReadPost *.md set ft=markdown
endif
autocmd BufReadPost *.*.* call MultiExtensionFiletype()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '/usr/share/dict/words',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:Ulti_ExpandOrJump_and_getRes()
  call UltiSnips#ExpandSnippetOrJump()
  return g:ulti_expand_or_jump_res
endfunction

function! s:handle_cr_with_popup()
  return <SID>Ulti_ExpandOrJump_and_getRes() > 0 ?  "" : neocomplete#close_popup() 
endfunction

"function! s:my_cr_function()
"  "return neocomplete#close_popup() . "\<CR>"
"  " For no inserting <CR> key.
"  return pumvisible() ? <SID>handle_cr_with_popup() : "\<CR>"
"endfunction
" <TAB>: completion.
"imap <expr><tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end neocomplete
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neosnippet
"
"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"       \ "\<Plug>(neosnippet_expand_or_jump)"
"       \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"       \ "\<Plug>(neosnippet_expand_or_jump)"
"       \: "\<TAB>"

" Using vim-snippets instead
"let g:neosnippet#disable_runtime_snippets = { '_': 1 }
" Enable snipmate style snippets
"let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory= [ '~/.vim/bundle/neosnippet-snippets/neosnippets', '~/.vim/bundle/vim-bootstrap3-snippets/neosnippets' ]

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

nnoremap <leader>se :<C-U>NeoSnippetEdit -split<cr>
