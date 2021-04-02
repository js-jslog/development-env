FROM ubuntu:20.04


ARG SEMVER="10.0.0"
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

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install git

RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
RUN chmod 777 nvim.appimage

# Create developer user under which all development within the container
# will be performed
RUN groupadd --gid 1000 developer
RUN useradd --create-home --shell /bin/bash --uid 1000 --gid 1000 developer
RUN usermod --append --groups sudo developer && echo "developer:sudo" | chpasswd
RUN mv ./nvim.appimage /home/developer/.
RUN ln -s /home/developer/nvim.appimage /usr/bin/nvim
USER developer

# Add users dotfiles to home directory
COPY --chown=developer:developer .bashrc /home/developer/.bashrc
COPY --chown=developer:developer dotfiles/.gitconfig /home/developer/.gitconfig
COPY --chown=developer:developer dotfiles/.bash_aliases /home/developer/.bash_aliases
COPY --chown=developer:developer dotfiles/.tmux.conf /home/developer/.tmux.conf

ENV APPIMAGE_EXTRACT_AND_RUN=1

COPY --chown=developer:developer dotfiles/init.vim /home/developer/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && nvim +PlugInstall +qall

CMD /bin/bash
