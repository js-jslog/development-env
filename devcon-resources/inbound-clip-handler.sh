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
content_dos_to_unix_line_endings=$(echo "$content" | sed 's/\r$//')

echo -n "$content_dos_to_unix_line_endings" > "$CLIPBOARDPATH"
