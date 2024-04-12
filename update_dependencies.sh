#!/bin/bash
ZF=$(haxelib libpath zf)
HEAPS=$(haxelib libpath heaps)
COMPILETIME=$(haxelib libpath compiletime)
HXRANDOM=$(haxelib libpath hxrandom)
HSCRIPT=$(haxelib libpath hscript)

function update() {
    pushd $ZF > /dev/null
    echo -n "zf: "
    git rev-parse HEAD
    popd > /dev/null

    pushd $HEAPS > /dev/null
    echo -n "heaps: "
    git rev-parse heaps
    popd > /dev/null

    pushd $ECHO > /dev/null
    echo -n "echo: "
    git rev-parse HEAD
    popd > /dev/null

    pushd $COMPILETIME > /dev/null
    echo -n "compiletime: "
    git rev-parse HEAD
    popd > /dev/null

    pushd $HXRANDOM > /dev/null
    echo -n "hxrandom: "
    git rev-parse HEAD
    popd > /dev/null

    pushd $HSCRIPT > /dev/null
    echo -n "hscript: "
    git rev-parse HEAD
    popd > /dev/null
}

update > DEPENDENCIES.md
