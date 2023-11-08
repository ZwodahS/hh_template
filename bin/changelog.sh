#!/bin/bash

HASH=$(git rev-parse --short HEAD)
VERSION=$1

echo "Bug Fix [BUILD_NUMBER] [$VERSION-$HASH]"
echo "-----"

python3 bin/extract_changelog.py res/changelogs/$VERSION.json
