FROM alpine:3.12.0


ARG SEMVER="9.0.0"
LABEL runcommand="docker run --rm -ti -p 3000:3000 -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v $(dirname \$SSH_AUTH_SOCK):$(dirname \$SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace jslog/development-env:v$SEMVER"
LABEL version=v$SEMVER

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

# Proxy environment variables for use during build.
# If a proxy is present during the running of the container then
# ENV variables can be passed in to the `docker run ...` command
# as described in the `runcommand` label above.
ARG http_proxy=$http_proxy
ARG https_proxy=$https_proxy
ARG HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY=$HTTPS_PROXY

ENV TERM=xterm-256color

# Install 'normal stuff' in order to make alpine more 'friendly'
RUN apk update && apk upgrade && apk add --no-cache \
    bash bash-doc bash-completion \
    util-linux pciutils usbutils coreutils binutils findutils grep

# Install base developer packages
RUN apk add --no-cache \
    curl wget openssl openssh \
    mysql-client \
    git tmux npm

RUN npm install -g yarn expo-cli

# Add Yeoman & TDD generator to be called ad a global npm package
RUN npm install -g yo
COPY yeoman-generators /var/yeoman-generators
RUN cd /var/yeoman-generators/generator-tdd && npm link


# Install neovim provider dependencies
### Shared
RUN apk add --no-cache neovim neovim-doc g++ && npm install -g neovim
### Python2
RUN apk add --no-cache python2 python2-dev \
 && curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && python2 get-pip.py \
 && pip install pynvim \
 && pip install msgpack
### python3
RUN apk add --no-cache python3 python3-dev py-pip \
 && pip3 install pynvim \
 && pip3 install msgpack

# Install ripgrep for use by denite
RUN apk add --no-cache ripgrep

# Create developer user under which all development within the container
# will be performed
RUN addgroup -g 1000 developer \
 && adduser --home /home/developer --disabled-password --shell /bin/bash --uid 1000 --ingroup developer developer
USER developer

# Add users dotfiles to home directory
COPY --chown=developer:developer .bashrc /home/developer/.bashrc
COPY --chown=developer:developer dotfiles/.gitconfig /home/developer/.gitconfig
COPY --chown=developer:developer dotfiles/.bash_aliases /home/developer/.bash_aliases
COPY --chown=developer:developer dotfiles/.tmux.conf /home/developer/.tmux.conf

# Install user scoped neovim python provider dependencies

# Install users vim customisations. This requires that the init.vim
COPY --chown=developer:developer dotfiles/init.vim /home/developer/.config/nvim/init.vim
COPY --chown=developer:developer dotfiles/coc.vim /home/developer/.config/nvim/after/plugin/coc.vim
COPY --chown=developer:developer dotfiles/denite.vim /home/developer/.config/nvim/after/plugin/denite.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && nvim +PlugInstall +qall \
 && nvim +UpdateRemotePlugins +qall

CMD /bin/bash
