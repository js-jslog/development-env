#!/bin/bash

sudo apt update && sudo apt install socat

sudo cp ./socat-docker-clip.init /etc/init.d/socat-docker-clip
sudo chmod u+x /etc/init.d/socat-docker-clip

sudo update-rc.d socat-docker-clip defaults
sudo service socat-docker-clip start
