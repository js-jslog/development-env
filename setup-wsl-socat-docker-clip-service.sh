#!/bin/bash

sudo apt update && sudo apt install socat

# sudo cp ./socat-docker-clip.init /etc/init.d/socat-docker-clip
# sudo chmod u+x /etc/init.d/socat-docker-clip

# sudo update-rc.d socat-docker-clip defaults
# sudo service socat-docker-clip start

sudo cp ./socat-docker-clip.service /etc/systemd/system/socat-docker-clip.service
sudo chmod 644 /etc/systemd/system/socat-docker-clip.service

sudo systemctl enable socat-docker-clip.service
sudo systemctl start socat-docker-clip.service
