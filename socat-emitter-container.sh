#!/bin/bash

cat /dev/clipboard | socat - tcp:host.docker.internal:8121
