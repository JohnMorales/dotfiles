FROM ubuntu:14.10
RUN apt-get update && apt-get install -y \
    autoconf \
    bison \
    build-essential \
    curl \
    git \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    libncurses5-dev \
    libgdbm3 \
    libgdbm-dev \
    vim \
    zlib1g-dev
RUN useradd -m jmorales && (echo "jmorales:yagni" | chpasswd ) && usermod -aG sudo jmorales
USER jmorales
WORKDIR /home/jmorales
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN curl -O https://gist.githubusercontent.com/liamdawson/5b20f45ae59755dcbc9d/raw/13a15ad98ef4cf4b2e2bc685dbc80c2aa846c683/2.2.1-typo.patch
RUN cat 2.2.1-typo.patch | ~/.rbenv/bin/rbenv install --patch 2.2.1
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN ~/.rbenv/bin/rbenv global 2.2.1
RUN ~/.rbenv/shims/gem install chef
