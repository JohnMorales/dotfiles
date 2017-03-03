#!/bin/bash
[ -d ~/.rbenv ] || git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc
[ -d ~/.rbenv/plugins/ruby-build ] || git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
eval "$(rbenv init -)"
ruby_install_version=$(rbenv install -l | sed 's/^ *//' | grep ^[[:digit:]] | grep '\.[[:digit:]]$')
echo "Latest matz ruby: $ruby_install_version"
~/.rbenv/bin/rbenv install $ruby_install_version
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
~/.rbenv/bin/rbenv global $ruby_install_version
~/.rbenv/shims/gem install chef
