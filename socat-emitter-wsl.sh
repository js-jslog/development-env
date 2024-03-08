#!/bin/bash

apt update && apt -y install socat

echo "hello from wsl via socat" | socat - tcp:localhost:8122
