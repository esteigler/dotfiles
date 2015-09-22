#!/usr/bin/env bash

if [ -e ~/Applications/MacVim.app ]; then
    ln -is $(pwd)/bin/mvim /usr/local/bin/vim
    ln -is $(pwd)/bin/mvim /usr/local/bin/vimdiff
    ln -is $(pwd)/bin/mvim /usr/local/bin/mvim
    ln -is $(pwd)/bin/mvim /usr/local/bin/mvimdiff
    ln -is $(pwd)/bin/mvim /usr/local/bin/gvim
    ln -is $(pwd)/bin/mvim /usr/local/bin/gvimdiff
fi
