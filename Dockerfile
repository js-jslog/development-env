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

# Create a developer folder in the home directory
# TODO: actually create a user with a home folder
# - need to investigate how to change UID and GID
#   at container creation time
RUN mkdir -p /home/developer/

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"
LABEL runcommand="docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v $(dirname \$SSH_AUTH_SOCK):$(dirname \$SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace jslog/development-env"

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
        mysql-client \
        python \
        postgresql postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Install vim and customise
COPY dotfiles/.vimrc /root/.vimrc
RUN add-apt-repository ppa:jonathonf/vim -y \
 && apt update \
 && apt install vim -y

RUN rm -r /root/.vim || true \
 && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && vim +PlugInstall +qall

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash \
 && . $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && nvm use default

# Install npm packages
RUN source /root/.bashrc
RUN npm install -g eslint \
 && npm install -g eslint-config-airbnb-base \
 && npm install -g eslint-plugin-import \
 && npm install -g jest \
 && npm install -g rxjs \
 && npm install -g typescript \
 && npm install -g http-server

# Copy global dotfiles
COPY dotfiles/.gitconfig /root/.gitconfig
COPY dotfiles/.bash_aliases /root/.bash_aliases
COPY dotfiles/.eslintrc.json /root/.eslintrc.json
COPY dotfiles/jest.config.js /home/developer/jest.config.js
RUN source /root/.bashrc

# Install docker ce so that host docker instances can be manipulated from this env
RUN apt-get update && apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Copy project templates with local dotfiles
COPY templates/tdd/ /home/developer/templates/tdd/
COPY dotfiles/jest.config.js /home/developer/templates/tdd/.
COPY dotfiles/.gitignore /home/developer/templates/tdd/.
COPY dotfiles/.eslintrc.json /home/developer/templates/tdd/.

COPY templates/express-app/ /home/developer/templates/express-app/
COPY dotfiles/.gitignore /home/developer/templates/express-app/.
COPY dotfiles/.eslintrc.json /home/developer/templates/express-app/.

COPY templates/webpack-es6/ /home/developer/templates/webpack-es6/
COPY dotfiles/.gitignore /home/developer/templates/webpack-es6/.
COPY dotfiles/.eslintrc.json /home/developer/templates/webpack-es6/.

LABEL version="1.1.5"
