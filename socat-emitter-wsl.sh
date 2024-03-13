#!/bin/bash

powershell.exe -c Get-Clipboard | socat - tcp:localhost:8122
