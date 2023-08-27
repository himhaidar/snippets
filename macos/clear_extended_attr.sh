#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> <file2> ..."
    exit 1
fi

for arg in "$@"; do
    if [ -f "$arg" ]; then
        sudo xattr -cr "$arg"
    fi
done

qlmanage -r
qlmanage -r cache
