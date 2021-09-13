#!/usr/bin/env bash

if [ -e /Applications/MacVim.app ]; then
    for f in /Applications/MacVim.app/Contents/bin/*
    do
        ln -is $f /usr/local/bin/
    done
fi
