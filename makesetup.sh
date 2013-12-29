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
test -d $VIMPLUGINDIR/nnerdtree-ag.vim || git clone https://github.com/taiansu/nerdtree-ag.git $VIMPLUGINDIR/nnerdtree-ag.vim

link_config_file() {
file=$1
if [ ! -L ~/.$file ]; then
  if [ -f ~/.$file ]; then 
    echo "creating backup of existing file to .$file.bak"
    mv ~/.$file ~/.$file.bak
  fi
  ln -s $SCRIPT_DIR/$file ~/.$file
fi
}

FILES=(vimrc bashrc gemrc gitconfig gitignore tmux.conf bash_profile tigrc)
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
install_brew_package() {
package=$1
echo "checking for package $i"
test -d /usr/local/Cellar/$package || brew install $package
}
PACKAGES=(
  tree
  the_silver_searcher 
  tig
)
for i in ${PACKAGES[*]}; do
  install_brew_package $i
done;
