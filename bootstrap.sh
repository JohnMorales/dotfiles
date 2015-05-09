#!/bin/bash
set -e
[ -d ~/home ] || git clone https://github.com/JohnMorales/dotfiles ~/home
cd ~/home
git pull
which chef >/dev/null || ./profile_init.sh
chef-apply setup.rb
