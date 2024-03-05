FROM ubuntu:24.04

# Necessary to allow `source` to be called later
SHELL ["/bin/bash", "-c"]

ARG SEMVER="11.0.0"
ARG IMAGE_NAME="jslog/development-env"
LABEL buildcommand="docker build -t $IMAGE_NAME:v$SEMVER"
LABEL runcommand="docker run -dti -v <NAME_OF_DOCKER_VOLUME>:/app --name <NAME_OF_CONTAINER> $IMAGE_NAME:v$SEMVER"
LABEL devcommand="docker exec -it <NAME_OF_CONTAINER> /bin/bash"
LABEL revolumecommand="docker commit <NAME_OF_CONTAINER> <NAME_OF_NEW_IMAGE> && docker run -dti -v <NAME_OF_DOCKER_VOLUME>:/app <NAME_OF_NEW_IMAGE>"
LABEL version=v$SEMVER

LABEL maintainer="Joseph Sinfield <jhs4jbs@hotmail.co.uk>"

# Install necessary packages
RUN apt -y update
RUN apt -y upgrade
RUN apt -y install curl # Required for neovim and nvm download
RUN apt -y install git # Required for the obvious reason
RUN apt -y install build-essential # C compiler required for neovim LSP
RUN apt -y install ripgrep # Required for some neovim telescope functions

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

WORKDIR /app

CMD /bin/bash
