#!/bin/bash
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
mkdir -p .vim/bundle
test -f .vim/bundle/ctrlp.vim || git clone https://github.com/kien/ctrlp.vim.git .vim/bundle/ctrlp.vim
