#!/bin/bash
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
~/.rbenv/bin/rbenv install 2.2.2
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
~/.rbenv/bin/rbenv global 2.2.2
~/.rbenv/shims/gem install chef
