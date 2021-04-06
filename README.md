# development-env
The files to build a docker container with the applications I use for development

# Important
The running image defaults to a user named "developer" with a uid of 1000.

You will be running the container with the idea of having "developer" map directly to your user so that it can modify your files. If your user is not uid 1000 then you will need to make use of the docker `userns-remap` feature: https://docs.docker.com/engine/security/userns-remap/

Configuration here requires that you modify the `/etc/subuid` and `/etc/subgid` files to map 1000 in the container to whatever your user uid is in the host.

## eg uid 1010
If your uid is 1010 then you will need to make sure that the uid's in the container are staggard by 10 in relation to your host. One way to achieve this is to start your `/etc/subuid` mappings from 9:

```
youruser:10:1000     # 0 in the container will map to 10 in the host
```

But this will mean that the root user (0) in the container will map to uid 9 in the host. I have made the "developer" user part of the sudo group so that we have the freedom to do whatever we want with the container. It is better to have 2 mappings with a 10 digit gap built in:

```
youruser:0:1000     # 0 - 999 inclusive
youruser:1010:1000  # 1000 in the container will map to 1010 in the host
```

## gid
A similar process needs to be performed for the `/etc/subgid` file.

## Docker daemon config
See the instructions in the link above to configure the daemon to run with this subordinate config in mind.

## Motivation
The purpose of creating a non-root user is not for security reasons. This is why I encourage the mapping of `youruser:0:...`. The purpose is becuase many applications don't run properly under root.

# Fonts
Aspects of Neovim are configured to expect patched-fonts which include devicons. This image can't provide that for you, but you can simply install them for the terminal you are using to present the containers created from it:

```
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
```

https://www.nerdfonts.com/ in general will be a good resource here. The important thing to remember is that it's the responsiblity of the terminal to know what the fonts are, not the container.

This one has worked in WSL in windows for me: https://github.com/haasosaurus/nerd-fonts/blob/regen-mono-font-fix/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf

# Yeoman Generators
Several Yeoman Generators have been published within the image as global npm packages and can be used with the usual `yo ...` syntax. See the projects within `yeoman-generators` for details.

# Usage
## Clone
```
git clone --recursive git@github.com:js-jslog/development-env.git
```

## Build
```
docker build -t jslog/development-env --build-arg http_proxy --build-arg https_proxy --build-arg HTTP_PROXY --build-arg HTTPS_PROXY  .
```

## Run
```
docker inspect jslog/development-env | grep runcommand
```

