#!/bin/bash

# Start the listener and leave the console free to then also call the emitter as required
socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &
