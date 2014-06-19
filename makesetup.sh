#!/bin/bash
set -e
[[ "$OSTYPE" == "darwin"* ]] && IS_MAC=true
SCRIPT_DIR=`pwd -P`
VIMPLUGINDIR=~/.vim/bundle
DEVELOPMENT=~/Development
#mkdir -p ~/.vim/autoload $VIMPLUGINDIR;\
#curl -Sso ~/.vim/autoload/pathogen.vim \
#    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
mkdir -p $VIMPLUGINDIR
test -d ~/.backup || mkdir ~/.backup
#mkdir -p ~/.vim/indent
#test -f ~/.vim/indent/html.vim ||  curl http://www.vim.org/scripts/download_script.php?src_id=21389 -o ~/.vim/indent/html.vim
#test -d $VIMPLUGINDIR/ctrlp.vim || git clone https://github.com/kien/ctrlp.vim.git $VIMPLUGINDIR/ctrlp.vim
#test -d $VIMPLUGINDIR/jellybeans.vim || git clone https://github.com/nanotech/jellybeans.vim.git $VIMPLUGINDIR/jellybeans.vim
#test -d $VIMPLUGINDIR/nerdtree.vim || git clone https://github.com/scrooloose/nerdtree.git $VIMPLUGINDIR/nerdtree.vim
#test -d $VIMPLUGINDIR/nnerdtree-ag.vim || git clone https://github.com/taiansu/nerdtree-ag.git $VIMPLUGINDIR/nnerdtree-ag.vim
#test -d $VIMPLUGINDIR/vim-colors-solarized.vim || git clone git://github.com/altercation/vim-colors-solarized.git $VIMPLUGINDIR/vim-colors-solarized.vim
#test -d $VIMPLUGINDIR/vim-fugitive.vim || git clone https://github.com/tpope/vim-fugitive.git $VIMPLUGINDIR/vim-fugitive.vim
#test -d $VIMPLUGINDIR/tlib_vim.vim || git clone https://github.com/tomtom/tlib_vim.git $VIMPLUGINDIR/tlib_vim.vim
#test -d $VIMPLUGINDIR/vim-addon-mw-utils.vim || git clone https://github.com/MarcWeber/vim-addon-mw-utils.git $VIMPLUGINDIR/vim-addon-mw-utils.vim
##test -d $VIMPLUGINDIR/vim-snipmate.vim || git clone https://github.com/garbas/vim-snipmate.git $VIMPLUGINDIR/vim-snipmate.vim
#test -d $VIMPLUGINDIR/vim-bracketed-paste.vim || git clone https://github.com/ConradIrwin/vim-bracketed-paste.git $VIMPLUGINDIR/vim-bracketed-paste.vim
#test -d $VIMPLUGINDIR/vim-surround.vim || git clone https://github.com/tpope/vim-surround.git $VIMPLUGINDIR/vim-surround.vim
#test -d $VIMPLUGINDIR/molokai.vim || git clone https://github.com/tomasr/molokai.git $VIMPLUGINDIR/molokai.vim
#test -d $VIMPLUGINDIR/html5.vim || git clone https://github.com/othree/html5.vim.git $VIMPLUGINDIR/html5.vim
#test -d $VIMPLUGINDIR/vim-airline.vim || git clone https://github.com/bling/vim-airline.git $VIMPLUGINDIR/vim-airline.vim
#test -d $VIMPLUGINDIR/vim-commentary.vim || git clone https://github.com/tpope/vim-commentary.git $VIMPLUGINDIR/vim-commentary.vim
#test -d $VIMPLUGINDIR/syntastic.vim || git clone https://github.com/scrooloose/syntastic.git $VIMPLUGINDIR/syntastic.vim
#test -d $VIMPLUGINDIR/vim-repeat.vim || git clone https://github.com/tpope/vim-repeat.git $VIMPLUGINDIR/vim-repeat.vim
#test -d $VIMPLUGINDIR/vim-multiple-cursors.vim || git clone https://github.com/terryma/vim-multiple-cursors.git $VIMPLUGINDIR/vim-multiple-cursors.vim
#test -d $VIMPLUGINDIR/vim-textobj-rubyblock.vim || git clone https://github.com/nelstrom/vim-textobj-rubyblock.git $VIMPLUGINDIR/vim-textobj-rubyblock.vim
#test -d $VIMPLUGINDIR/_vim-textobj-user.vim || git clone https://github.com/kana/vim-textobj-user.git $VIMPLUGINDIR/_vim-textobj-user.vim
#test -d $VIMPLUGINDIR/delimitMate.vim || git clone https://github.com/Raimondi/delimitMate.git      $VIMPLUGINDIR/delimitMate.vim
#test -d $VIMPLUGINDIR/YouCompleteMe.vim || (git clone https://github.com/Valloric/YouCompleteMe.git $VIMPLUGINDIR/YouCompleteMe.vim;cd $VIMPLUGINDIR/YouCompleteMe.vim; git submodule update --init --recursive)
#test -d $VIMPLUGINDIR/ultisnips.vim || git clone https://github.com/SirVer/ultisnips.git $VIMPLUGINDIR/ultisnips.vim
#test -d $VIMPLUGINDIR/_snip_vim-snippets.vim || git clone https://github.com/honza/vim-snippets.git $VIMPLUGINDIR/_snip_vim-snippets.vim
#test -d $VIMPLUGINDIR/_snip_bootstrap-snippets.vim || git clone https://github.com/JohnMorales/bootstrap-snippets.git $VIMPLUGINDIR/_snip_bootstrap-snippets.vim
#test -d $VIMPLUGINDIR/tagbar.vim || git clone https://github.com/majutsushi/tagbar.git $VIMPLUGINDIR/tagbar.vim
test -d $VIMPLUGINDIR/vundle.vim || git clone https://github.com/gmarik/Vundle.vim.git $VIMPLUGINDIR/vundle.vim

if [ -d $VIMPLUGINDIR/ultisnips/ftdetect ] && ! [ -d ~/.vim/ftdetect ]; then
  mkdir ~/.vim/ftdetect
  ln -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/
fi;


link_config_file() {
file=$1
destination=${2-$file}
if [ ! -L ~/.$destination -a ! -f ~/.$destination.keep ]; then
  if [ -f ~/.$destination ]; then
    echo "creating backup of existing file to .$destination.bak"
    mv ~/.$destination ~/.$destination.bak
  fi
  echo "ln -s $SCRIPT_DIR/$file ~/.$destination"
  ln -s $SCRIPT_DIR/$file ~/.$destination
fi
}

FILES=(vimrc bashrc gemrc gitconfig gitignore tmux.conf bash_profile tigrc my.cnf pryrc editrc)
for i in ${FILES[@]}
  do
    link_config_file $i;
  done

# installing irssi customizations
test -d ~/.irssi || mkdir ~/.irssi
link_config_file "irssirc" "irssi/config"
test -d ~/.irssi/irssi-colors-solarized || git clone git://github.com/huyz/irssi-colors-solarized.git ~/.irssi/irssi-colors-solarized
mkdir -p ~/.irssi/scripts
if [ ! -L ~/.irssi/scripts/autorun ]; then
  ln -s `pwd`/irssi ~/.irssi/scripts/autorun
fi

#installing coreutils to get the latest gnu tools, lscolors, etc.
if [ ! -d /usr/local/opt/coreutils/ ] && $IS_MAC; then
  brew install coreutils
fi

#install tmux themes
test -d $DEVELOPMENT/tmux-colors-solarized || git clone https://github.com/seebi/tmux-colors-solarized.git $DEVELOPMENT/tmux-colors-solarized

# install dircolors themes
test -d $DEVELOPMENT/dircolors-solarized || git clone https://github.com/seebi/dircolors-solarized.git $DEVELOPMENT/dircolors-solarized
test -f ~/.dir_colors_dark || ln -s $DEVELOPMENT/dircolors-solarized/dircolors.ansi-dark ~/.dir_colors_dark
test -f ~/.dir_colors_light || ln -s $DEVELOPMENT/dircolors-solarized/dircolors.ansi-light ~/.dir_colors_light

#Install dupes
test -d /usr/local/Library/Taps/homebrew-dupes || brew tap homebrew/dupes

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
  pstree
  tmux
  wget
  grep
  pv
  meld
)
for i in ${PACKAGES[*]}; do
  install_brew_package $i
done;


# install tmux-pastboard hack fix.
if [ ! -d $DEVELOPMENT/tmux-MacOSX-pasteboard ]; then
  git clone https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git $DEVELOPMENT/tmux-MacOSX-pasteboard
  cd $DEVELOPMENT/tmux-MacOSX-pasteboard
  make
  ln -s `pwd`/reattach-to-user-namespace /usr/local/bin/reattach-to-user-namespace
fi


