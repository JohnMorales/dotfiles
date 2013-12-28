#!/bin/bash
set -e
[[ "$OSTYPE" == "darwin"* ]] && IS_MAC=true
SCRIPT_DIR=`pwd -P`
VIMPLUGINDIR=~/.vim/bundle
mkdir -p ~/.vim/autoload $VIMPLUGINDIR;\
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
mkdir -p $VIMPLUGINDIR
test -d $VIMPLUGINDIR/ctrlp.vim || git clone https://github.com/kien/ctrlp.vim.git $VIMPLUGINDIR/ctrlp.vim
test -d $VIMPLUGINDIR/jellybeans.vim || git clone https://github.com/nanotech/jellybeans.vim.git $VIMPLUGINDIR/jellybeans.vim
test -d $VIMPLUGINDIR/nerdtree.vim || git clone https://github.com/scrooloose/nerdtree.git $VIMPLUGINDIR/nerdtree.vim
test -d $VIMPLUGINDIR/nerdtree-ag.vim || git clone https://github.com/taiansu/nerdtree-ag.git $VIMPLUGINDIR/nerdtree-ag.vim

link_config_file() {
file=$1
if [ ! -L ~/.$file ]; then
  echo "creating backup of exiting file to .$file.bak"
  [ -f ~/.$file ] && mv ~/.$file ~/.$file.bak
  ln -s $SCRIPT_DIR/$file ~/.$file
fi
}

FILES=(vimrc bashrc gemrc gitconfig gitignore tmux.conf bash_profile)
for i in ${FILES[@]} 
  do 
    link_config_file $i; 
  done

#installing coreutils to get the latest gnu tools, lscolors, etc.
if [ ! -d /usr/local/opt/coreutils/ ] && $IS_MAC; then
  brew install coreutils
fi

# install dircolors themes
test -d ~/Development/dircolors-solarized || git clone https://github.com/seebi/dircolors-solarized.git ~/Development/dircolors-solarized
test -f ~/.dir_colors_dark || ln -s ~/Development/dircolors-solarized/dircolors.ansi-dark ~/.dir_colors_dark
test -f ~/.dir_colors_light || ln -s ~/Development/dircolors-solarized/dircolors.ansi-light ~/.dir_colors_light

#brew utils
test -d /usr/local/Cellar/tree || brew install tree
test -d /usr/local/Cellar/the_silver_searcher || brew install the_silver_searcher
