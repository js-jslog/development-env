#!/bin/bash

socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:'/development-env/clip.sh'
