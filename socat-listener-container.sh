#!/bin/bash

apt update && apt -y install socat

socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:'/development-env/clip.sh'
