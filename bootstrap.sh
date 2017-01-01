#!/bin/bash
set -e
[ -d ~/home ] || git clone https://github.com/JohnMorales/dotfiles ~/home
cd ~/home
[ -f /etc/redhat-release ] && grep CentOS /etc/redhat-release && ./install_dependencies_redhat.sh
git pull
which chef >/dev/null || ./profile_init.sh
chef-client -z --config-option cookbook_path=$PWD/cookbooks -r profile::setup -l info
