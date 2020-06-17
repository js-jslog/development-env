FROM alpine:3.12


ARG SEMVER="6.0.0"
LABEL runcommand="docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v $(dirname \$SSH_AUTH_SOCK):$(dirname \$SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace jslog/development-env:v$SEMVER"
LABEL version=v$SEMVER

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

ARG http_proxy=$http_proxy
ARG https_proxy=$https_proxy
ARG HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY=$HTTPS_PROXY

ENV TERM=xterm-256color
ENV NODE_VERSION=12.16.2

RUN apk update
RUN apk upgrade
RUN apk add --no-cache \
    bash bash-doc bash-completion \
    util-linux pciutils usbutils coreutils binutils findutils grep


# Install base dependencies
RUN apk add --no-cache \
    curl \
    git \
    openssl \
    wget \
    tmux \
    openssh \
    mysql-client \
    python2 \
    python3 \
    neovim \
    py-pip


# Python2 neovim integration is optional for the neovim plugins.
# I have only included it for completeness but this and the pip
# dependencies below can possibly be removed.
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
 && python2 get-pip.py


RUN apk add --no-cache npm
RUN npm install -g yarn \
 && npm install -g yo \
 && npm install -g neovim


RUN apk add --no-cache gcc
RUN apk add -U curl bash ca-certificates openssl ncurses coreutils python2 make gcc g++ libgcc linux-headers grep util-linux binutils findutils
RUN apk add --no-cache python2-dev
RUN apk add --no-cache python3-dev

# Create developer user under which all development within the container
# will be performed
RUN addgroup -g 1000 developer \
 && adduser --home /home/developer --disabled-password --shell /bin/bash --uid 1000 --ingroup developer developer
USER developer

RUN pip install --user pynvim
RUN pip3 install --user pynvim


# Install users vim customisations. This requires that the init.vim
# file is copied earlier than the other dotfiles
COPY --chown=developer:developer dotfiles/init.vim /home/developer/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim +PlugInstall +qall
RUN nvim +UpdateRemotePlugins +qall

# Copy global dotfiles
COPY --chown=developer:developer dotfiles/.gitconfig /home/developer/.gitconfig
COPY --chown=developer:developer dotfiles/.bash_aliases /home/developer/.bash_aliases
COPY --chown=developer:developer dotfiles/.tmux.conf /home/developer/.tmux.conf
RUN source ~/.bashrc

# Prepare Yeoman Generators folders
COPY --chown=developer:developer yeoman-generators /home/developer/yeoman-generators

# npm link the Yeoman Generators so that they can be used as though a global module
RUN cd /home/developer/yeoman-generators/generator-tdd && npm link
