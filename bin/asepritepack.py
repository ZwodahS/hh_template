#!/usr/bin/env python3

import json
import sys
from PIL import Image
import rectpack

"""
This is currently a work in progress
"""

def ensure_no_dupe(loaded):
    keys = set()
    for k, v in loaded.items():
        conf = v["conf"]
        for frame in conf["meta"]["frameTags"]:
            if frame["name"] in keys:
                print("duplicated: {}".format(frame["name"]))
                sys.exit(0)
            keys.add(frame["name"])

if __name__ == "__main__":
    doc="""
    Each argument should be a png:json pair.

    For example

    {0} output.png:output.json tiles.png:tiles.json background.png:background.json

    The first pair will always be the output file.
    """

    if len(sys.argv) <= 2: # we need minimum 3 args to work
        print(doc.format(sys.argv[0]))
        sys.exit(0)

    outputfile = sys.argv[1].split(":")
    if len(outputfile) != 2:
        print("Unable to process: {}".format(sys.argv[2]))
        sys.exit(1)

    mappings = {}
    for inputfile in sys.argv[2:]:
        try:
            p, j = inputfile.split(":")
        except:
            print("Fail to process: {}".format(inputfile))
            sys.exit(1)
        mappings[j] = p

    loaded = {}
    for k, v in mappings.items():
        loaded[k] = {}

        with open(k) as f:
            json_data = json.loads(f.read())
            loaded[k]["conf"] = json_data;

        loaded[k]['img'] = Image.open(v)

    ensure_no_dupe(loaded)

    size = (1024, 1024)
    packed_image = Image.new('RGBA', size, 0x00000000)


    packer = rectpack.newPacker(rotation=False)
    packer.add_bin(size[0], size[1])
    # for now we put them together, rather than splitting each individual sprite
    for k, v in loaded.items():
        img = v['img']
        packer.add_rect(img.size[0], img.size[1], k)

    packer.pack()
    frames = []
    frameTags = []
    curr = 0
    for rect in packer.rect_list():
        k = rect[5]
        v = loaded[k]
        img = v['img']
        packed_image.paste(v['img'], (rect[1], rect[2], rect[1] + rect[3], rect[2] + rect[4]))
        offset = [rect[1], rect[2]]
        v["offset"] = offset
        for frame in v["conf"]["frames"]:
            frame["frame"]["x"] += offset[0]
            frame["frame"]["y"] += offset[1]
            frames.append(frame)

        for frameTag in v["conf"]["meta"]["frameTags"]:
            frameTag["from"] += curr
            frameTag["to"] += curr
            frameTags.append(frameTag)

        curr += len(v["conf"]["frames"])

    outputjson = {
        "frames": frames,
        "meta": {
            "image": outputfile[0].split('/')[-1],
            "format": "RGBA8888",
            "size": {"w": size[0], "h": size[1]},
            "scale": "1",
            "frameTags": frameTags
        }
    }

    packed_image.save(outputfile[0])
    with open(outputfile[1], "w") as f:
        print(json.dumps(outputjson, indent=2), file=f)
