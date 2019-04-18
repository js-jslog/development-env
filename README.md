# development-env
The files to build a docker container with the applications I use for development

# Build
```
docker build --build-arg http_proxy --build-arg https_proxy --build-arg HTTP_PROXY --build-arg HTTPS_PROXY  .
```

# Run
```
docker run -ti -e http_proxy -e https_proxy -e HTTP_PROXY -e HTTPS_PROXY --rm -v $(pwd):/home/developer/workspace
```
