# development-env
The files to build a docker container with the applications I use for development

# Clone
```
git clone --recursive git@github.com:js-jslog/development-env.git
```

# Build
```
docker build -t jslog/development-env --build-arg http_proxy --build-arg https_proxy --build-arg HTTP_PROXY --build-arg HTTPS_PROXY  .
```

# Run
```
docker inspect jslog/development-env | grep runcommand
```
