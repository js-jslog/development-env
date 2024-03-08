#!/bin/bash

socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe'
