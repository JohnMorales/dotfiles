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
COPY profile_init.sh /
RUN /profile_init.sh
