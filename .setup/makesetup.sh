#!/bin/bash
VIMPLUGINDIR=~/.vim/bundle
mkdir -p ~/.vim/autoload $VIMPLUGINDIR;\
curl -Sso ~/.vim/autoload/pathogen.vik \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
mkdir -p $VIMPLUGINDIR
test -d $VIMPLUGINDIR/ctrlp.vim || git clone https://github.com/kien/ctrlp.vim.git $VIMPLUGINDIR/ctrlp.vim
test -d $VIMPLUGINDIR/jellybeans.vim || git clone https://github.com/nanotech/jellybeans.vim.git $VIMPLUGINDIR/jellybeans.vim
