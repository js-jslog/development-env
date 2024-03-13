# development-env

A dev container based on Neovim.

The expectation is that an container app under development will shared it's code through a volume.

The dev container can then also be mounted to that volume. This then means the dev container can edit the application code, and make use of any dev dependencies which are available in the node_modules folder for example.

The use case is currently limited to nodejs projects, hence the reference to node_modules above, but I will not prematurely optimise for other usecases at this point.

# Usage

## For container app development

The primary usage comes from running a container from the image, with the appropriate docker volume specified, then `exec`ing in to the container and running neovim.

Prior to this step you will need to have mounted the application code from the actual container app under development on to a docker volume.

```powershell
# Powershell
docker pull jslog/development-env:v<SEMVER-ID>
git clone --config core.autocrlf=input --recursive https://github.com/js-jslog/development-env.git
cd development-env && .\runcontainer.ps1
# Follow the instructions
# During the first entry to the container you will want to run the Post-container-creation actions described below
```

..or..

```bash
# Bash
docker run -dit -v <NAME-OF-DOCKER-VOLUME>:/app --name <NAME-OF-CONTAINER> jslog/development-env:v<SEMVER-ID>
docker exec -it <NAME_OF_CONTAINER> /bin/bash
# During the first entry to the container you will want to run the Post-container-creation actions described below
```
It is suggested that you maintain a dedicated container for the project you are working on, and the volume which it's attached to.

The benefit of this is that you don't have to worry about switching between volumes which can be a bit cumbersome, and you only have to do the Post-container-creation actions once per container.

If the container has been stopped for any reason, you can simply start it again and as long as the original volume is still in place you can carry on where you left off.

```bash
docker start <NAME_OF_CONTAINER>
docker exec -it <NAME_OF_CONTAINER> /bin/bash
```

## Clipboard management between windows and container

Clipboard management is handled automatically for the most part. Some initial setup is required.

Ports 8121 & 8122 are required for operation here. If these need to be update then I've tried to make that as simple as possible with Docker environment variables with the following names:

- HOSTCLIPLISTENPORT
- DEVCONCLIPLISTENPORT

Unfortunately the same isn't so simple for the Powershell and WSL contexts. If you need to change these values then you'll have to search for the port numbers and change them across the whole project.

If you follow these steps then your workflow will be as follows:

- Copy from neovim to windows: Yank using <space>y, <space>Y etc (ie any yank command with a space before it)
- Copy from windows to neovim: Copy as usual, then press `Ctrl + Shift + C` as a windows hot key (and wait a moment for a powershell window to open and close)

### In Windows

```powershell
wsl --update
```

### In WSL

```bash
git clone --config core.autocrlf=input --recursive https://github.com/js-jslog/development-env.git ~/development-env
cd ~/development-env/wsl-resources && ./setup-socat-docker-clip-service.sh
# If the service doesn't install successfully then make sure that systemd is enabled in your wsl
```

### In Windows again

1. Create a file in your user directory called `paste-to-container.ps1` with the following content:

```powershell
wsl.exe --exec bash /home/<username>/development-env/wsl-resources/wsl-clip-emitter.sh # Replace <username> with your username
```

2. Right click on the file and select "Send to" > "Desktop (create shortcut)"
3. Find the shortcut file and right click on it, then select "Properties"
4. Under the "Shortcut" tab, click in the "Shortcut key" field and press `Ctrl + Shift + C`
5. Under the "Shortcut" tab, click in the "Target" field and update the file path to be prefixed with `C:\WINDOWS\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Bypass -File ` (check that the path to Powershell.exe is correct for your system)

## For development of the development-env project itself

Updating the development environment project itself doesn't require mounting docker volumes since the application code and dev tools are already in the same place.

```bash
docker run -dit --name <NAME-OF-CONTAINER> jslog/development-env:v<SEMVER-ID>
docker exec -it <NAME_OF_CONTAINER> /bin/bash
# During the first entry to the container you will want to run the Post-container-creation actions described below
cd /development-env
# Now make whatever modifications you want to the project, and push.
# To test the changes you will need to:
#  - pull the changes on to the project on the host system
#  - run the usual build process described below
#  - create a new container with a new name and test what you find inside
```

## Build process

### Clone

```bash
git clone --config core.autocrlf=input --recursive https://github.com/js-jslog/development-env.git
# NOTE: the flags in this command are very important
#  - autocrlf=input will ensure that the files intended for linux and windows contexts will have their intended line endings before being run / copied in to the container. We don't want linux files being cloned on to a Windows machine, having their line endings updated and then being copied as is in to the linux Docker image.
#  - recursive will mean that the neovim-config submodule is cloned successfully
```

## Build

### For local development and testing

```bash
docker build -t <ANY-NAME-YOU-WANT> .
```

### For pushing to docker hub

```bash
docker build -t jslog/development-env:v<SEMVER-ID>  .
docker push jslog/development-env:v<SEMVER-ID>
```

## Post-container-creation actions

- Set the relevant git credentials for the project you are working on. Either:
  - `/usr/local/bin/devcon-resources/setup-git-config-sinfiej.sh` (and follow the instructions for github login)
  - or
  - `/usr/local/bin/devcon-resources/setup-git-config-js-jslog.sh`
- Setup nvim:
  - Run `nvim` from the commandline - you will see the plugins installing
  - Run `Copilot setup` from the nvim terminal & follow the instructions
- Set up the git credentials manager:
  - For github.com:
    - NOTE: if you ran the `/usr/local/bin/devcon-resources/setup-git-config-sinfiej.sh` then this will already have been done for you.
    - `/usr/local/bin/git-credential-manager github login`
    - Follow the authentication instructions, using "Device code" (suggested)
  - For gitlab.com:
    - Create a personal access token for the given project
    - The first time you push to the repository, you will be prompted to enter the token
    - (CANNOT USE USERNAME/PASSWORD WHILE 2FA IS ENABLED)

## Altering volumes

If you forget to mount the volume when you create the container, or you are moving on to another project, it's probably just better to create another container (discarding the former if you're completely finished with it).

However, if you really want to reuse the container and just change the volume, you can do so by committing the container to an image and then creating a new container from that image:

```bash
docker commit <NAME_OF_CONTAINER> <NAME_OF_NEW_IMAGE> && docker run -dti -v <NAME_OF_DOCKER_VOLUME>:<WORKDIR_OF_THE_CONTAINER> --name <NAME_OF_NEW_CONTAINER> <NAME_OF_NEW_IMAGE>"
```
