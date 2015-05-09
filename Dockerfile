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
RUN ~/.rbenv/bin/rbenv install 2.2.2
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN ~/.rbenv/bin/rbenv global 2.2.2
RUN ~/.rbenv/shims/gem install chef
