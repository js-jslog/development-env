#!/bin/bash

############################################
# Send the contents of the clipboard to the
# socat listener running on the host machine.
#
# Requires:
#  - An environment variable CLIPBOARDPATH
#  defining the clipboard file path
############################################

cat "$CLIPBOARDPATH" | socat - tcp:host.docker.internal:${HOST_CLIPLISTENPORT}
