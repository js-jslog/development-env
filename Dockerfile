####################################################################################################
# Stage 1: Acquire and extract / build neovim, GCM & nvm
# This stage produces artifacts which are not required in the final image
####################################################################################################
FROM ubuntu:24.04 AS build

# Install necessary packages
#  - curl: Required for neovim download
RUN apt -y update && \
  apt -y upgrade && \
  apt -y install curl

# Download and extract neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage && \
  chmod u+x nvim.appimage && \
  ./nvim.appimage --appimage-extract

# Download and install GCM
RUN curl -LO https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb && \
  dpkg -i /gcm-linux_amd64.2.4.1.deb

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

####################################################################################################
# Stage 2: Create the final image
####################################################################################################
FROM ubuntu:24.04

# Necessary to allow `source` to be called later
SHELL ["/bin/bash", "-c"]

ARG SEMVER="11.0.0"
ARG WORKDIR="/app"
LABEL version=v$SEMVER
LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

# Install necessary packages
#  - curl: Required by nvm, apparently
#  - git: Required for the obvious reason
#  - build-essential: C compiler required for neovim LSP
#  - ripgrep: Required for some neovim telescope functions
#  - rpm: libicu package required for GCM (rpm is smallest apt available pacakage I could find which includes libicu)
#  - socat: required for the windows shared clipboard functionality
RUN apt -y update && \
  apt -y upgrade && \
  apt -y install curl git build-essential ripgrep rpm socat

# Copy neovim, GCM & nvm artifacts from the build stage
COPY --from=build /squashfs-root/ /squashfs-root/
COPY --from=build /usr/local/bin/git-credential-manager /usr/local/bin/git-credential-manager
COPY --from=build /root/.nvm/ /root/.bashrc /root/.nvm/
# .bashrc: Required to benefit from the update made by nvm
COPY --from=build /root/.bashrc /root/.bashrc

# Set build args and environment variables
ARG NODE_VERSION=20
ARG DEVELOPMENTENV_DIR="/development-env"
ENV DEVCON_RESOURCESDIR="/usr/local/bin/devcon-resources"
ENV HOST_CLIPLISTENPORT="8121"
ARG DEVCON_CLIPLISTENPORT="8122"
ENV ISDEVCONTAINER=true
ENV CLIPBOARDPATH="/dev/clipboard"
ENV CLIPEMITTERPATH="${DEVCON_RESOURCESDIR}/outbound-clip-emitter.sh"
ARG CLIPHANDLERPATH="${DEVCON_RESOURCESDIR}/inbound-clip-handler.sh"

# Link up neovim
RUN ln -s /squashfs-root/AppRun /usr/bin/nvim && \
# Link up and configure git-credentials-manager (GCM)
  /usr/local/bin/git-credential-manager configure && \
  git config --global credential.credentialStore cache && \
# Install node & npm using nvm
  source /root/.nvm/nvm.sh && nvm install $NODE_VERSION
RUN source /root/.nvm/nvm.sh

# Copy neovim config
COPY neovim-config/. /root/.config/nvim/
# Copy entire development-env project locally to
# image in case changes need to be made
COPY . $DEVELOPMENTENV_DIR
# Copy the devcom-resources to the image
# to provide some key container functionality
COPY ./devcon-resources $DEVCON_RESOURCESDIR

WORKDIR $WORKDIR

CMD socat tcp-listen:${DEVCON_CLIPLISTENPORT},fork,bind=0.0.0.0 EXEC:"${CLIPHANDLERPATH}"
