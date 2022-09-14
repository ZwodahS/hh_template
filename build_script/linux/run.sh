#!/usr/bin/env bash

# Sadly hashlink has some issue with loading .so files from current directory, fix this later.
LD_LIBRARY_PATH=. ./hl
