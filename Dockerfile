FROM ubuntu:focal

ARG http_proxy=$http_proxy
ARG https_proxy=$https_proxy
ARG HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY=$HTTPS_PROXY

ENV TERM=xterm-256color
ENV NODE_VERSION=12.16.2

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

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
        tmux \
        software-properties-common \
        ssh \
        mysql-client \
        python \
        postgresql postgresql-contrib \
        sudo \
        neovim \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

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

# Python2 neovim integration is optional for the deoplete plugin.
# I have only included it for completeness but this and the pip
# dependencies below can possibly be removed.
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
 && python2 get-pip.py

# Create developer user under which all development within the container
# will be performed
RUN groupadd --gid 1000 developer \
 && useradd --create-home --shell /bin/bash --uid 1000 --gid 1000 developer \
 && usermod --append --groups sudo developer && echo "developer:sudo" | chpasswd
USER developer

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
 && . /home/developer/.nvm/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && nvm use default
RUN source ~/.bashrc

# Have to manually include the node folder on the path to make
# the following installs possible.
# It gets set automatically by the time we start the container,
# but for some reason it's not ready at this point.
ENV PATH="/home/developer/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Install npm packages
# neovim required for nvim-typescript neovim plugin
# typescript optional for nvim-typescrip neovim plugin
RUN npm install -g yarn \
 && npm install -g neovim \
 && npm install -g typescript
## && npm install -g yo 
## #&& npm install -g expo-cli


# Install deoplete and nvm-typescript
# neovim plugin python dependencies
RUN pip install --user pynvim \
 && pip install --user neovim \
 && pip install msgpack \
 && pip3 install --user pynvim \
 && pip3 install --user neovim \
 && pip3 install msgpack

# Install users vim customisations. This requires that the .vimrc
# file is copied earlier than the other dotfiles
COPY --chown=developer:developer dotfiles/.vimrc /home/developer/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim +PlugInstall +qall
RUN nvim +UpdateRemotePlugins +qall

### Copy global dotfiles
##COPY --chown=developer:developer dotfiles/.gitconfig /home/developer/.gitconfig
##COPY --chown=developer:developer dotfiles/.bash_aliases /home/developer/.bash_aliases
##COPY --chown=developer:developer dotfiles/.tmux.conf /home/developer/.tmux.conf
##RUN source ~/.bashrc
##
### Prepare Yeoman Generators folders
##COPY --chown=developer:developer yeoman-generators /home/developer/yeoman-generators
##
### npm link the Yeoman Generators so that they can be used as though a global module
##RUN cd /home/developer/yeoman-generators/generator-dotfiles && npm link
##RUN cd /home/developer/yeoman-generators/generator-tdd && npm link
##RUN cd /home/developer/yeoman-generators/generator-webpack && npm link
##RUN cd /home/developer/yeoman-generators/generator-express && npm link

ARG SEMVER="5.0.0"
LABEL runcommand="docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v $(dirname \$SSH_AUTH_SOCK):$(dirname \$SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace jslog/development-env:$SEMVER"
LABEL version=$SEMVER
