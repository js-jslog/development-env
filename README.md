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

After initially entering the container you can run `nvim .` and see the plugins installing.

When they are complete you will also want to log in to Copilot with `Copilot setup`.

At this point you can keep relying on this container for the project you are working on.

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
