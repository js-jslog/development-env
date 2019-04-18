FROM ubuntu:xenial

ARG http_proxy=$http_proxy
ARG https_proxy=$http_proxy
ARG HTTP_PROXY=$http_proxy
ARG HTTPS_PROXY=$http_proxy
ENV TERM=xterm-256color

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
        git \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.15.1

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN source /root/.bashrc

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g eslint
RUN npm install -g eslint-config-airbnb-base
RUN npm install -g eslint-plugin-import

RUN add-apt-repository ppa:jonathonf/vim -y
RUN apt update
RUN apt install vim -y

COPY dotfiles/.vimrc /root/.vimrc
COPY dotfiles/.bash_aliases /root/.bash_aliases

RUN rm -r /root/.vim || true
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim +PlugInstall +qall
