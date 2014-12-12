syntax on
set runtimepath^=~/.nvim/bundle/ctrlp.vim
"~/.nvim/bundle/molokai
set runtimepath^=~/.nvim/bundle/nerdtree
set runtimepath^=~/.nvim/bundle/base16-vim
set runtimepath^=~/.nvim/bundle/YouCompleteMe
set runtimepath^=~/.nvim/bundle/vim-airline

"colorscheme molokai
let base16colorspace=256
set background=dark
colorscheme base16-default

" Nerdtree
map ,m :NERDTreeToggle<CR>
map ,n :NERDTreeFind<CR>

" Short messages (defaults to: filnxtToO) see |shortmess|
" I = Don't show startup intro message
set shortmess+=I 

" Delete trailing whitespaces.
nmap <leader>tr :%s/\s\+$//g<CR>:w<CR>:e<CR>

" Using alt-mac keys to provide window navigation..
nmap ˙ <C-w><Left>
nmap ¬ <C-w><Right>
nmap ˚ <C-w><Up>
nmap ∆ <C-w><Down>

"tab and spaces (always use 2 spaces)
set tabstop=2 " defaults to 8, vim recommends keeping this and shiftwidth as the preferred value.
set softtabstop=2 "number of spaces that a tab is
" set smarttab " delete a 'shiftwidth' worth of spaces (commented out since not sure it's needed)
set shiftwidth=2 " the number of spaces autoindent will use (defaults to 8!?!)
set shiftround "ctrl-t and ctrl-d will round to the shiftwidth
set expandtab " use spaces to insert tab in insert mode

" insert mode bindings
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-k> <C-r>=<SID>kill_line()<CR>
function! s:home()
  let start_col = col('.')
  normal! ^
  if col('.') == start_col
    normal! 0
  endif
  return ''
endfunction

function! s:kill_line()
  let [text_before_cursor, text_after_cursor] = s:split_line_text_at_cursor()
  if len(text_after_cursor) == 0
    normal! J
  else
    call setline(line('.'), text_before_cursor)
  endif
  return ''
endfunction
" end insert mode


nmap <C-t> :CtrlPBuffer<CR>

" CtrlP
let g:ctrlp_regexp = 0 " disabled by default, leaving here to remind me to try this config
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_reuse_window = 'NERDTree' not sure if this is needed
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -oc --exclude-standard'],
    \ },
  \ 'fallback': '/usr/bin/find %s -maxdepth 4 -type d -depth +0 -name ".*" -prune -o -type f -print'
  \ }


"YCM
autocmd FileType c nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 " always show airline
let g:airline_enable_branch = 1
"let g:airline_enable_syntastic = 1
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" end airline
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

