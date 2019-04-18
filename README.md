# development-env
The files to build a docker container with the applications I use for development

# Build
```
docker build --build-arg http_proxy --build-arg https_proxy --build-arg HTTP_PROXY --build-arg HTTPS_PROXY  .
```

# Run
```
docker run --rm -ti -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace <image_name>
```

# Add an alias
```
alias edit='docker run --rm -ti -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -v $(pwd):/home/developer/workspace -w /home/developer/workspace <image_name>'
```
