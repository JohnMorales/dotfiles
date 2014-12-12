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
for d in swap backup undo; do                # make vim dirs
  test -d ~/.vim/$d || mkdir ~/.vim/$d
done
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

FILES=(
vimrc
nvimrc
bashrc
gemrc
gitconfig
gitignore
tmux.conf
bash_profile
tigrc
my.cnf
pryrc
editrc
inputrc
rspec
jshintrc
)
for i in ${FILES[@]}
  do
    link_config_file $i;
  done

# installing irssi customizations
test -d ~/.irssi || mkdir ~/.irssi
link_config_file "irssirc" "irssi/config"
link_config_file "sshconfig" "ssh/config"
test -d ~/.irssi/irssi-colors-solarized || git clone git://github.com/huyz/irssi-colors-solarized.git ~/.irssi/irssi-colors-solarized
mkdir -p ~/.irssi/scripts
if [ ! -L ~/.irssi/scripts/autorun ]; then
  ln -s `pwd`/irssi ~/.irssi/scripts/autorun
fi
if [ -f ~/.gitignore_global ] && ! [ -L ~/.gitignore_global ]
then
  if ! [ -f ~/.gitignore ]; then
    mv ~/.gitignore_global ~/.gitignore
  else
    mv ~/.gitignore_global ~/.gitignore_global.bak
  fi
fi
[ -L ~/.gitignore_global ] || ln -s $(readlink -f ~/.gitignore) ~/.gitignore_global
if [ -f ~/.gitignore_global.bak ]; then
  echo "move gitignore_globals and delete bak."
  diff -u ~/.gitignore_global ~/.gitignore_global.bak
fi
if [ -f ~/.gitignore.bak ]; then
  echo "move gitignores and delete bak."
  diff -u ~/.gitignore ~/.gitignore.bak
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
  reattach-to-user-namespace
  node
  bash-completion
  jq
)
for i in ${PACKAGES[*]}; do
  install_brew_package $i
done;
# install neovim
brew tap neovim/homebrew-neovim
brew install --HEAD neovim
node_packages=(
 jscs
 jshint
 js-yaml
)
for i in ${node_packages[*]}; do
  npm install -g $i
done;


if [ ! -d $DEVELOPMENT/base-16/shell ]; then
  git clone https://github.com/chriskempson/base16-shell.git $DEVELOPMENT/base-16/shell
fi

if [ ! -d $DEVELOPMENT/base-16/iterm ]; then
  git clone https://github.com/chriskempson/base16-iterm2 $DEVELOPMENT/base-16/iterm
fi

# link in jsc
if [ -x /System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc ] && ! [ -L /usr/local/bin/jsc ]; then
 ln -s /System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc /usr/local/bin/jsc
fi
