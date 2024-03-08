#!/bin/bash

echo "hello from container via socat" | socat - tcp:host.docker.internal:8121
