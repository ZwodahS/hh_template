#!/bin/bash
ZF=$(haxelib libpath zf)
HEAPS=$(haxelib libpath heaps-dev)

function update() {
    pushd $ZF > /dev/null
    echo -n "zf: "
    git rev-parse HEAD
    popd > /dev/null

    pushd $HEAPS > /dev/null
    echo -n "heaps: "
    git rev-parse heaps-stable
    popd > /dev/null
}

update > DEPENDENCIES.md
