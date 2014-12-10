syntax on
set runtimepath^=~/.nvim/bundle/ctrlp.vim
"~/.nvim/bundle/molokai
set runtimepath^=~/.nvim/bundle/nerdtree
set runtimepath^=~/.nvim/bundle/base16-vim

"colorscheme molokai
let base16colorspace=256 
set background=dark
colorscheme base16-default

" Nerdtree
map ,m :NERDTreeToggle<CR>
map ,n :NERDTreeFind<CR>

" Using alt-mac keys to provide window navigation..
nmap ˙ <C-w><Left>
nmap ¬ <C-w><Right>
nmap ˚ <C-w><Up>
nmap ∆ <C-w><Down>

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
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -oc --exclude-standard'],
    \ },
  \ 'fallback': '/usr/bin/find %s -maxdepth 4 -type d -depth +0 -name ".*" -prune -o -type f -print'
  \ }

