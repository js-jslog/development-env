#!/bin/bash

sudo apt update && sudo apt install socat

sudo cp ./socat-docker-clip.service /etc/systemd/system/socat-docker-clip.service

sudo systemctl enable socat-docker-clip.service
sudo systemctl start socat-docker-clip.service
