#!/bin/bash
set -e
[ -d ~/home ] || git clone https://github.com/JohnMorales/dotfiles ~/home
cd ~/home
[ -f /etc/redhat-release ] && grep CentOS /etc/redhat-release >/dev/null && ./install_dependencies_redhat.sh
[ -f /etc/os-release ] && grep Debian /etc/os-release >/dev/null && ./install_dependencies_debian.sh
git pull
which chef >/dev/null || ./profile_init.sh
chef-client -z --config-option cookbook_path=$PWD/cookbooks -r profile::setup -l info
