#!/bin/bash

echo "hello from wsl via socat" | socat - tcp:localhost:8122
