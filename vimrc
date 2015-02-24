set nocompatible
filetype off
"execute pathogen#infect()

" Vundle configuration
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" A bit meta..
Plugin 'gmarik/Vundle.vim'

Plugin 'kien/ctrlp.vim.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'rking/ag.vim.git' " use this version due to the dependency from nerdtree-ag
Plugin 'taiansu/nerdtree-ag.git'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'bling/vim-airline.git'
Plugin 'scrooloose/syntastic.git'
Plugin 'tpope/vim-repeat.git'
" ctrl-n seems to cause multiple issues.
"Plugin 'terryma/vim-multiple-cursors.git'
Plugin 'kana/vim-textobj-user.git'
Plugin 'nelstrom/vim-textobj-rubyblock.git'
Plugin 'Raimondi/delimitMate.git'
Plugin 'maxbrunsfeld/vim-emacs-bindings.git'
" Switching back to ycm+ultisnips
" Neosnippet doesn't fully support vim-snippets. (select mode snippets are not
" supported.
"Plugin 'Shougo/neocomplete.git'
"Plugin 'Shougo/neosnippet.vim.git'
"Plugin 'JohnMorales/neosnippet-snippets.git'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips.git'
Plugin 'git@github.com:JohnMorales/vim-snippets.git'
Plugin 'git@github.com:JohnMorales/vim-bootstrap3-snippets.git'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'majutsushi/tagbar'
Plugin 'vim-ruby/vim-ruby'
"Plugin 'tpope/vim-endwise'
"Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-projectionist' " Project specific plugins.
Plugin 'tpope/vim-rake' " Project specific plugins.
Plugin 'tpope/vim-rails'
Plugin 'dbakker/vim-projectroot'
Plugin 'ivalkeen/vim-ctrlp-tjump'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'kchmck/vim-coffee-script'
Plugin 'marijnh/tern_for_vim.git'
Plugin 'elzr/vim-json.git'
Plugin 'milkypostman/vim-togglelist'
Plugin 'godlygeek/tabular'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'freeo/vim-kalisi'
Plugin 'chriskempson/base16-vim'
Plugin 'chrisbra/NrrwRgn'
Plugin 'gilligan/vim-lldb'
Plugin 'fatih/vim-go.git'
" Plugin 'edkolev/promptline.vim'
" Plugin 'edkolev/tmuxline.vim'


call vundle#end()            " required
filetype plugin indent on
" End vundle
" After installing a new plugin, reload the vimrc and run :PluginInstall

" cmatcher
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

" hack to support shift enter in console vim ref:http://stackoverflow.com/questions/5388562/cant-map-s-cr-in-vim
imap ✠ <S-CR>
set wrap
set linebreak
set nolist
set ai
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=79
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
set pastetoggle=<F4>
set dir=/tmp
" Status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)\ [%p%%]\ Buf:%n\ [%b][0x%B]

" Disable clearing scrollback buffer when exiting vim
set t_ti= t_te=
set incsearch
set ignorecase

" Don't show the startup message
set shortmess=I

" taken from https://github.com/vim-scripts/ingo-library/blob/master/autoload/ingo/str.vim
function! Trim( string )
  return substitute(a:string, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfunction

" Turn on persistent undo
" Thanks, Mr Wadsten: github.com/mikewadsten/dotfiles/
if has('persistent_undo')
    set undodir=~/.vim/undo/
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" Use backups
" Source:
"   http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim/backup/

" Use a specified swap folder
" Source:
"   http://stackoverflow.com/a/15317146
set directory=~/.vim/swap/

" Check if a colorscheme exists
" http://stackoverflow.com/a/5703164
function! HasColorScheme(scheme)
    let basepath = '~/.vim/bundle/'

    for plug in g:color_schemes
        let path = basepath . '/' . plug . '/colors/' . a:scheme . '.vim'
        if filereadable(expand(path))
            return 1
        endif
    endfor

    return 0
endfunction

" let g:solarized_termcolors=256
"set t_Co=256
"set t_Co=88
" Jellybeans colors
" let g:solarized_termcolors=16
"let g:solarized_bold = 0
"let bg_profile = Trim(substitute(system("tmux showenv ITERM_PROFILE"), ".*=", "", ""))
let bg_profile = $ITERM_PROFILE
"echom bg_profile
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
else
  if !empty($BASE16_THEME)
    let base16colorspace=256
    exec "set background=" . $BASE16_VARIATION
    "echom 'setting colorscheme to ' . $BASE16_THEME
    colorscheme $BASE16_THEME
  endif
endif
"colorscheme jellybeans
"Only useful if using transparent backgrounds.
"let g:solarized_termtrans=1

" Add dictionary completion
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" Add dictionary to complete list
set complete-=k complete+=k

syntax on
" highlight previous search term.
"noremap <F4> :set hlsearch! <cr>
" show tagbar
noremap <F8> :TagbarToggle <CR>

"quickly get out of insert mode so that you can navigate (and practice quick keys)
inoremap jj <esc>

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

" Using alt keys for quick window movements Maybe for windows/linux setups...
" nmap <A-h> <C-w><Left>
" nmap <A-l> <C-w><Right>
" nmap <A-k> <C-w><Up>
" nmap <A-j> <C-w><Down>
nmap ˙ <C-w><Left>
nmap ¬ <C-w><Right>
nmap ˚ <C-w><Up>
nmap ∆ <C-w><Down>


" Control enhancements in insert mode
imap <C-F> <right>
imap <C-B> <left>
imap <M-BS> <esc>vBc
"imap <C-P> <up>
"imap <C-N> <down>

" Map Ctrl+V to paste in Insert mode
imap <C-V> <C-R>*

" Project level tags (alt-p)
nnoremap π :CtrlPTag<cr>
" File level tags (alt-f)
nnoremap ƒ :CtrlPBufTag<cr>
" Jump to tags (alt-])
nnoremap ‘ :CtrlPtjump<cr>
vnoremap ‘ :CtrlPtjumpVisual<cr>
" Show buffer (Alt-t)
nmap † :CtrlPBuffer<CR>
" Show recent files (Alt-r)
nmap ® :CtrlPMRU<CR>
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
    \ 1: ['.git', 'cd %s && git ls-files -oc --exclude-standard'],
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
nmap <leader>O :BufOnly<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
"let g:airline_theme='kalisi'
let g:airline_enable_branch = 1
let g:airline_enable_syntastic = 1
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
" unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.whitespace = 'Ξ'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end airline
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = [ '<Down>'] " Need to remember that YCM expects you to accept the text by just space
let g:ycm_key_list_previous_completion = [ '<Up>']
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf= 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
"imap <expr> <CR> pumvisible() ? \"\<c-y>\" : \"<Plug>delimitMateCR\"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end YouCompleteMe
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" delimitMate
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"inoremap <S-Tab> <Plug>delimitMateS-Tab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enddelimitMate
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ultisnips
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<S-F12>" " mapped to shift-f10 or F21 is mapped to '\033 [24;2~' in iterm
let g:UltiSnipsListSnippets="<c-l>" " cannot be c-n and c-p because you could get a prompt while you are entering values of a snippet.
let g:UltiSnipsJumpForwardTrigger="<c-j>" " cannot be c-n and c-p because you could get a prompt while you are entering values of a snippet.
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"
"default mapping interferes with vim see  *UltiSnips-triggers*
inoremap <c-x><c-k> <c-x><c-k>
function! ExpandPossibleShorterSnippet()
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe "normal a" . curr_key
    exe "normal a "
    return 1
  endif
  return 0
endfunction
inoremap <silent> <C-L> <C-R>=(ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end ultisnips
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"http://learnvimscriptthehardway.stevelosh.com/chapters/10.html
inoremap jk <Esc>

nmap ,t :TagbarToggle<CR>


let g:rootmarkers = ['.projectroot','.git','.hg','.svn','.bzr','_darcs','build.xml', 'Gemfile' ]

let g:ctrlp_tjump_shortener= ['/Users/jmorales/.rbenv/.*/gems/', 'gems/' ]
let g:ctrlp_tjump_only_silent = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto commands
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" there are more in the neocomplete section
" Custom extenstions
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufReadPost *.hbs set ft=html
  au BufReadPost *.bats set ft=sh
  au BufReadPost *.md set ft=markdown
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
"" Use neocomplete.
"let g:neocomplete#enable_at_startup = 1
"" Use smartcase.
"let g:neocomplete#enable_smart_case = 1
"" Set minimum syntax keyword length.
"let g:neocomplete#sources#syntax#min_keyword_length = 3
"let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"
"" Define dictionary.
"let g:neocomplete#sources#dictionary#dictionaries = {
"    \ 'default' : '/usr/share/dict/words',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"        \ }
"
"" Define keyword.
"if !exists('g:neocomplete#keyword_patterns')
"    let g:neocomplete#keyword_patterns = {}
"endif
"let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"
"" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()
"
" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"
"function! s:Ulti_ExpandOrJump_and_getRes()
"  call UltiSnips#ExpandSnippetOrJump()
"  return g:ulti_expand_or_jump_res
"endfunction
"
"function! s:handle_cr_with_popup()
"  return <SID>Ulti_ExpandOrJump_and_getRes() > 0 ?  "" : neocomplete#close_popup()
"endfunction
"
"function! s:my_cr_function()
"  "return neocomplete#close_popup() . "\<CR>"
"  " For no inserting <CR> key.
"  return pumvisible() ? <SID>handle_cr_with_popup() : "\<CR>"
"endfunction
" <TAB>: completion.
"imap <expr><tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()
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
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"
" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
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
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)
"
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
" let g:neosnippet#snippets_directory= [ '~/.vim/bundle/neosnippet-snippets/neosnippets', '~/.vim/bundle/vim-bootstrap3-snippets/neosnippets' ]
"
" " For snippet_complete marker.
" if has('conceal')
"   set conceallevel=2 concealcursor=i
" endif
"
" nnoremap <leader>se :<C-U>NeoSnippetEdit -split<cr>
" let g:neosnippet#scope_aliases = {}
" let g:neosnippet#scope_aliases['ruby'] = 'eruby,ruby,ruby-rails'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end neosnippet
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Projectionist
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:projectionist_heuristics = {
      \ "recipes/&attributes/": {
      \   "recipes/*.rb": {"type": "chef.ruby"},
      \   "templates/*/*.erb": {"type": "erb.chef.ruby"}
      \ },
      \ "config/application.rb&bin/rails": {
      \   "app/*.js.coffee": {"type": "coffee.javascript"},
      \   "app/views/*.erb": {"type": "erb.html.ruby"},
      \   "spec/*.rb": {"type": "rails.rspec"},
      \   "spec/features/*_spec.rb": {"type": "capy.rspec.rails.ruby"},
      \   "spec/*/*_spec.rb": {"type": "rspec.rails.ruby"}
      \ }
      \ }
autocmd User ProjectionistActivate call s:activate()

function! s:activate()
  for [root, value] in projectionist#query('type')
    echom "Adding snippets " . value
    call UltiSnips#AddFiletypes(value)
    break
  endfor
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end Projectionist
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_javascript_checkers = [ 'jscs', 'jshint' ]
let g:syntastic_always_populate_loc_list = 1 "send errors to location list.
let g:syntastic_aggregate_errors = 1 "send errors to location list.
let g:syntastic_check_on_open = 1
let g:syntastic_cursor_column = 0 " 'this speeds of navigation significantly' |syntastic_cursor_columns|
let g:syntastic_auto_jump = 2  " setting to 2 will only autojump on error
let g:syntastic_auto_loc_list = 0 "open loc list when error
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", " proprietary attribute \"ui-"]
let g:syntastic_javascript_jshint_quiet_messages = { "regex": "'angular' is not defined" }
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", " proprietary attribute \"ui-"]
let g:syntastic_c_check_header = 1 " check headers
let g:syntastic_c_include_dirs = [ '/usr/local/include' ]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end syntastic
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! LoadAndDisplayRSpecQuickfix()
  let quickfix_filename = "./quickfix.out"
  if filereadable(quickfix_filename) && getfsize(quickfix_filename) != 0
    silent execute ":cfile " . quickfix_filename
    botright cwindow
    cc
  else
    redraw!
    echohl WarningMsg | echo "Quickfix file " . quickfix_filename . " is missing or empty." | echohl None
  endif
endfunction

noremap <silent> <Leader>q :call LoadAndDisplayRSpecQuickfix()<CR>

"""""
" yaml
"""""
function! s:fold_yaml_sections()
  "set foldmethod=marker
  "":w
endfunction
autocmd FileType yaml :call s:fold_yaml_sections()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ag
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:agprg="ag --ignore tags --column --smart-case"
let g:aghighlight=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End Ag
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NrrwRgn
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>sb V%\nr<c-w>_ " show block in new window

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" promptline
"
"
" add git info...
" other themes available in autoload/promptline/themes/*
" run `:PromptlineSnapshot [file] [theme]` e.g. `PromptlineSnapshot ~/.shell_prompt.sh airline` to create new theme
" powerline is customized with a hash of the following keys: a, b, c, x, y, z, warn
" let g:promptline_preset = {
"         \'a'    : [ promptline#slices#host() ],
"         \'b'    : [ promptline#slices#cwd() ],
"         \'c'    : [ promptline#slices#vcs_branch() ],
"         \'warn' : [ promptline#slices#last_exit_code() ] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmuxline
"
"
"" other presets available in `~/.vim/bundle/tmuxline.vim/autoload/tmuxline/themes/`
" change below and run `:Tmuxline`
"
" Vim autopastemode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
