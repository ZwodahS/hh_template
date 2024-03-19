#!/bin/bash

if [ -z "$1" ]; then
    echo "$(basename $0) [modulename] ";
    exit 1
fi

find_and_rename hx abcdefg $1
mv src/abcdefg src/$1
mv res/abcdefg res/$1
