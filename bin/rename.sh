#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
    echo "$(basename $0) [old name] [new name]";
    exit 1
fi

find . -name '*.hx' -exec sed -i '.bak' "s/$1/$2/g" {} \;
find . -name '*.hx.bak' -exec rm {} \;
