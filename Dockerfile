FROM ubuntu:xenial

ARG http_proxy=$http_proxy
ARG https_proxy=$https_proxy
ARG HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY=$HTTPS_PROXY

ENV TERM=xterm-256color
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=10.15.1
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY dotfiles/.vimrc /root/.vimrc
COPY dotfiles/.gitconfig /root/.gitconfig
COPY dotfiles/.bash_aliases /root/.bash_aliases
COPY dotfiles/.eslintrc.json /root/.eslintrc.json

LABEL version="1.0"
LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"
LABEL runcommand="docker run --rm -ti -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v $(dirname \$SSH_AUTH_SOCK):$(dirname \$SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace jslog/development-env"

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
        ssh \
    && rm -rf /var/lib/apt/lists/*

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash \
 && . $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && nvm use default

RUN source /root/.bashrc

RUN npm install -g eslint \
 && npm install -g eslint-config-airbnb-base \
 && npm install -g eslint-plugin-import

RUN add-apt-repository ppa:jonathonf/vim -y \
 && apt update \
 && apt install vim -y

RUN rm -r /root/.vim || true \
 && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && vim +PlugInstall +qall
