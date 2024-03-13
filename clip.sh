#!/bin/bash

############################################
# Take the contents coming from the container's
# socat command & write it to the clipboard file.
#
# Requires:
#  - An environment variable CLIPBOARDPATH
#  defining the clipboard file path
############################################

content=$(cat)

echo -n "$content" > "$CLIPBOARDPATH"
