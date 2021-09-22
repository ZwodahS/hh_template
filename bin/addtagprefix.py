#!/usr/bin/env python3

import json
import os
import sys

"""
This mainly rename all the tags by putting a prefix in front.
This does not change the image
This will change the loadedfile
"""

DOC="""

{0} input.json [prefix]
"""

def parse_args():
    fn = sys.argv[1]
    prefix = sys.argv[2]
    return fn, prefix


def main():
    if len(sys.argv) < 3:
        print(DOC.format(sys.argv[0]))
        sys.exit(0)

    fn, prefix = parse_args()
    with open(fn) as f:
        json_data = json.loads(f.read())

    tags = json_data["meta"]["frameTags"]
    for tag in tags:
        tag["name"] = "{0}{1}".format(prefix, tag["name"])

    with open(fn, "w") as f:
        print(json.dumps(json_data, indent=2), file=f)


if __name__ == "__main__":
    main()
