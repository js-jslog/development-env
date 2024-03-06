FROM ubuntu:24.04

# Necessary to allow `source` to be called later
SHELL ["/bin/bash", "-c"]

ARG SEMVER="11.0.0"
ARG IMAGE_NAME="jslog/development-env"
ARG WORKDIR="/app"

LABEL runcommand="docker run -dti -v <NAME_OF_DOCKER_VOLUME>:$WORKDIR --name <NAME_OF_CONTAINER> $IMAGE_NAME:v$SEMVER"
LABEL version=v$SEMVER

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

# Install necessary packages
RUN apt -y update
RUN apt -y upgrade
RUN apt -y install curl # Required for neovim and nvm download
RUN apt -y install git # Required for the obvious reason
RUN apt -y install build-essential # C compiler required for neovim LSP
RUN apt -y install ripgrep # Required for some neovim telescope functions
RUN apt -y install rpm # libicu package required for GCM (rpm is smallest apt available pacakage I could find which includes libicu)

# Install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ln -s /squashfs-root/AppRun /usr/bin/nvim

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NODE_VERSION=20
RUN source /root/.nvm/nvm.sh && nvm install $NODE_VERSION
COPY neovim-config/. /root/.config/nvim/

# Installl git-credentials-manager (GCM)
RUN curl -LO https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb
RUN dpkg -i /gcm-linux_amd64.2.4.1.deb
RUN /usr/local/bin/git-credential-manager configure
RUN git config --global credential.credentialStore cache

WORKDIR $WORKDIR
RUN touch thisisatestfile

CMD /bin/bash
