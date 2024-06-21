#!/bin/bash
#

##install vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    h~/.config/fontconfig/conf.d/ttps://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## Powerline fonts
(
	mkdir fonts
	cd fonts
	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.local/share/fonts/ 
	mv PowerlineSymbols.otf ~/.local/share/fonts/
	fc-cache -vf ~/.local/share/fonts/
	mkdir -p ~/.config/fontconfig/conf.d/
	mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
)

##create link
ln -s $(readlink -f vimrc) ~/.vimrc
