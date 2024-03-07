# Plan

## 2-way socat

## Copy from container to windows

Use socat in the way described in https://stuartleeks.com/posts/vscode-devcontainer-clipboard-forwarding

This project defines a powershell script to get socat running on port 8121.

There will need to be a custom vim.g.clipboard config set up something like this (in the neovim-config project):

```
vim.g.clipboard = {
    name = 'myClipboard',
    copy = {
        ["+"] = function()
            // call a function designed to send the pasted content on to host.docker.internal:8121
        end,
        ["*"] = 'echo "test"',
    },
    paste = {
        ["+"] = 'echo "test"',
        ["*"] = 'echo "test"',
    },
    cache_enabled = true,
}
```

That config needs to be dependant on an environment variable being set, because we don't want to override clipboard functionality where it might already work.

The docker image will set that environment variable.

## Copy from windows to the container

Use socat again.

This project defines a clip.sh file with the following contents:

```
#!/bin/bash

content=$(cat)

echo "$content" > /dev/clipboard
```

.. and a symlink is created for /usr/local/bin/clip.sh

This project defines a bash script to get socat running on port 8122:

```
socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:'/usr/local/bin/clip.sh'
```

The docker run command needs to specify a port mapping from the host to the container for port 8122

Then, whenever there's some content in windows which I want to copy to the container there is a script which can at least be run in wsl which does the following (or something like this):

```
powershell.exe -c Get-Clipboard | socat - tcp:localhost:8122
```

Then the neovim config needs to have the paste section updated to do something like this:

 ```
    paste = {
        ["+"] = function ()
            // a function to read /dev/clipboard to the vim buffer
        end,
        ["*"] = 'echo "test"',
    },
```

It would be good if socat could run detatched in the container, so that it can be started as part of the image in fact.
