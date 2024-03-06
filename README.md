# development-env

Create a dev container based on neovim.

The intention is that the container will acquire it's project files from a preexisting docker volume.

The expectation is that during development, the application will be run in a docker container, with the code under development shared through a volume.

The dev container can then also be mounted to that volume, making the dependencies pertinent to the development of that application in particular available. For example via the node_modules folder. This reduces the number of dependencies which need to be included in the dev container itself.

The use case is currently limited to nodejs projects, hense the reference to node_modules above, but I will not prematurely optimise for other usecases at this point.


# Usage

## Clone

```bash
git clone --recursive git@github.com:js-jslog/development-env.git
```

## Build

```bash
docker build -t jslog/development-env:v<semver-id>  .
docker push jslog/development-env:v<semver-id>
```

## Run

```bash
docker inspect jslog/development-env:v<semver-id> | grep runcommand # start the container
docker exec -it <NAME_OF_CONTAINER> /bin/bash
```

It is suggested that you maintain a dedicated container for the project you are working on, and the volume which it's attached to.

The benefit of this is that you don't have to worry about switching between volumes which can be a bit cumbersome, and you only have to do the following post-container-creation actions once per container.

### Post-container-creation actions

- Set the relevant git credentials for the project you are working on:
  - `git config --global user.email "..."`
  - `git config --global user.name "..."`
- Setup nvim:
  - Run `nvim` from the commandline - you will see the plugins installing
  - Run `Copilot setup` from the nvim terminal & follow the instructions
- Set up the git credentials manager:
  - For github.com:
    - `/usr/local/bin/git-credential-manager github login`
    - Follow the authentication instructions, using "Device code" (suggested)
  - For gitlab.com:
    - Create a personal access token for the given project
    - The first time you push to the repository, you will be prompted to enter the token
    - (CANNOT USE USERNAME/PASSWORD WHILE 2FA IS ENABLED)

## Return to the container

If the container has been stopped for any reason, you can simply start it again and as long as the original volume is still in place you can carry on where you left off.

```bash
docker start <NAME_OF_CONTAINER>
docker exec -it <NAME_OF_CONTAINER> /bin/bash
```

## Altering volumes

If you forget to mount the volume when you create the container, or you are moving on to another project, it's probably just better to create another container (discarding the former if you're completely finished with it).

However, if you really want to reuse the container and just change the volume, you can do so by committing the container to an image and then creating a new container from that image:

```bash
docker commit <NAME_OF_CONTAINER> <NAME_OF_NEW_IMAGE> && docker run -dti -v <NAME_OF_DOCKER_VOLUME>:<WORKDIR_OF_THE_CONTAINER> --name <NAME_OF_NEW_CONTAINER> <NAME_OF_NEW_IMAGE>"
```

# Modification of dev container

1. Start a dev container
2. Exec in
3. `cd /development-env/`
4. Make the changes you need to
5. Back in the host, checkout the branch and run the usual build process
