#!/bin/bash
BASEDIR=$(dirname "$0")
cd "${BASEDIR}"
export DYLD_LIBRARY_PATH="../Frameworks:${DYLD_LIBRARY_PATH}"
./hl
