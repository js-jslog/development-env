#!/bin/bash

apt update && apt -y install socat

echo "hello from container via socat" | socat - tcp:host.docker.internal:8121
