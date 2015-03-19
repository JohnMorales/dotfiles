#!/bin/bash
set -e
[ -d ~/home ] || git clone git@github.com:JohnMorales/dotfiles.git ~/home
cd ~/home
git pull
./makesetup.sh
