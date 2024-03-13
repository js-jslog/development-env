FROM ubuntu:24.04

# Necessary to allow `source` to be called later
SHELL ["/bin/bash", "-c"]

ARG SEMVER="11.0.0"
ARG WORKDIR="/app"
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

# Allow development-env to be updated from within the container
ARG DEVELOPMENTENVDIR="/development-env"
ENV DEVCON_RESOURCESDIR="/usr/local/bin/devcon-resources"
COPY . $DEVELOPMENTENVDIR
COPY ./devcon-resources $DEVCON_RESOURCESDIR

WORKDIR $WORKDIR

RUN apt -y install socat # required for the windows shared clipboard functionality
ENV HOSTCLIPLISTENPORT="8121"
ENV DEVCONCLIPLISTENPORT="8122"
ENV ISDEVCONTAINER=true
ENV CLIPBOARDPATH="/dev/clipboard"
ENV CLIPEMITTERPATH="${DEVCON_RESOURCESDIR}/socat-emitter-container.sh"
ENV CLIPHANDLERPATH="${DEVCON_RESOURCESDIR}/clip.sh"

CMD socat tcp-listen:${DEVCONCLIPLISTENPORT},fork,bind=0.0.0.0 EXEC:"${CLIPHANDLERPATH}"
