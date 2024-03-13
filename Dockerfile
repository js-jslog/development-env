FROM ubuntu:24.04

# Necessary to allow `source` to be called later
SHELL ["/bin/bash", "-c"]

ARG SEMVER="11.0.0"
ARG WORKDIR="/app"
LABEL version=v$SEMVER
LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

# Install necessary packages
#  - curl: Required for neovim and nvm download
#  - git: Required for the obvious reason
#  - build-essential: C compiler required for neovim LSP
#  - ripgrep: Required for some neovim telescope functions
#  - rpm: libicu package required for GCM (rpm is smallest apt available pacakage I could find which includes libicu)
#  - socat: required for the windows shared clipboard functionality
RUN apt -y update && \
  apt -y upgrade && \
  apt -y install curl git build-essential ripgrep rpm socat

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

# Allow development-env to be updated from within the container
ARG DEVELOPMENTENV_DIR="/development-env"
ENV DEVCON_RESOURCESDIR="/usr/local/bin/devcon-resources"
COPY . $DEVELOPMENTENV_DIR
COPY ./devcon-resources $DEVCON_RESOURCESDIR

WORKDIR $WORKDIR

ENV HOST_CLIPLISTENPORT="8121"
ENV DEVCON_CLIPLISTENPORT="8122"
ENV ISDEVCONTAINER=true
ENV CLIPBOARDPATH="/dev/clipboard"
ENV CLIPEMITTERPATH="${DEVCON_RESOURCESDIR}/outbound-clip-emitter.sh"
ENV CLIPHANDLERPATH="${DEVCON_RESOURCESDIR}/inbound-clip-handler.sh"

CMD socat tcp-listen:${DEVCON_CLIPLISTENPORT},fork,bind=0.0.0.0 EXEC:"${CLIPHANDLERPATH}"
