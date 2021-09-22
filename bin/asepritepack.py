#!/usr/bin/env python3

import json
import os
import sys
import rectpack

from PIL import Image

PADDING = 2
OFFSET_MARKER = (255, 0, 0, 255)

DOC="""
Each argument should be a png:json pair.

For example

{0} output.png:output.json tiles.png:tiles.json background.png:background.json

The first pair will always be the output file.
"""
# the sprite padding trim away the padding from the source sprite.
# for example, if the value is 2, 2 pixel is trim from top left bottom right
# this allow the sprite to contains non-usable pixel, allowing for size to specified in the image

def scanOffset(sourceRect, frameName, frameTag):
    dx = 0
    dy = 0
    img = frameTag["img"]
    pixel_data = frameTag["pixels"]

    y = sourceRect[1] - 1
    for x in range(sourceRect[0], sourceRect[2]+1):
        pos = y * (img.width) + x
        pixel = pixel_data[pos]
        if (pixel == OFFSET_MARKER):
            dx = x - sourceRect[0]
            break

    x = sourceRect[0] - 1
    for y in range(sourceRect[1], sourceRect[3]+1):
        pos = y * (img.width) + x
        pixel = pixel_data[pos]
        if (pixel == OFFSET_MARKER):
            dy = y - sourceRect[1]
            break

    return (dx, dy)

def parse_env():
    PADDING = 2
    if (os.environ.get("PADDING") != None):
        PADDING = os.environ.get("PADDING")

def main():
    if len(sys.argv) <= 2: # we need minimum 3 args to work
        print(DOC.format(sys.argv[0]))
        sys.exit(0)

    outputfile = sys.argv[1].split(":")
    if len(outputfile) != 2:
        print("Unable to process: {}".format(sys.argv[2]))
        sys.exit(1)

    loaded = []
    for inputfile in sys.argv[2:]:
        size = 1
        conf = {}
        try:
            config = inputfile.split(":")
            image_file = config[0]
            json_file = config[1]
            if len(config) > 2:
                size = int(config[2])

            with open(json_file) as f:
                json_data = json.loads(f.read())
                conf["conf"] = json_data

            img = Image.open(image_file)
            conf["img"] = img
            conf["pixels"] = list(img.getdata())
            conf["size"] = size
            loaded.append(conf)
        except:
            import traceback; traceback.print_exc()
            print("Fail to process: {}".format(inputfile))
            sys.exit(1)

    # for each of the files provided load all the frameTags
    loadedFrameTags = {}
    for v in loaded:
        conf = v["conf"]
        for frame in conf["meta"]["frameTags"]:
            # check for duplicate
            if frame["name"] in loadedFrameTags:
                print("duplicated: {}".format(frame["name"]))
                sys.exit(0)
            loadedFrameTags[frame["name"]] = {
                "conf": conf, "img": v["img"], "frame": frame, "pixels": v["pixels"], "size": v["size"],
            }

    # HACK: need to change once we need to pack into multiple images
    packed_size = (1024, 1024)
    packed_image = Image.new('RGBA', packed_size, 0x00000000)

    # prepare the packer
    packer = rectpack.newPacker(rotation=False)
    packer.add_bin(packed_size[0], packed_size[1])

    # for each of the loadedFrameTags, add each of the frame into the packer
    for name, frameTag in loadedFrameTags.items():
        conf = frameTag["conf"]
        size = frameTag["size"]
        for frame in range(frameTag["frame"]["from"], frameTag["frame"]["to"] + 1):
            f = conf["frames"][frame]
            # add a 1 pixel padding - (2 * the PADDING)
            w = (size * (f["spriteSourceSize"]["w"] - (2 * PADDING))) + 1
            h = (size * (f["spriteSourceSize"]["h"] - (2 * PADDING))) + 1
            packer.add_rect(w, h, (name, frame))
    # pack
    packer.pack()

    # unpack all the rect and store them in the original conf so we can pack them properly
    # We need all the frames to be together due to the "from" and "to" of frameTags
    for rect in packer.rect_list():
        rid = rect[5]
        name, frame_no = rid
        frameTag = loadedFrameTags[name]
        # set update the frames data for the rect to paste into
        frameTag["conf"]["frames"][frame_no]["rect"] = rect

    # prepare the final output frames and frameTags
    frames = []
    frameTags = []
    for frameName, frameTag in loadedFrameTags.items():
        oldFrameTag = frameTag["frame"]
        conf = frameTag["conf"]
        img = frameTag["img"]
        frameFrom = len(frames)

        # iterate each of the frame of the frameTag and paste the sub image to the right location
        for frameNo in range(frameTag["frame"]["from"], frameTag["frame"]["to"] + 1):
            f = conf["frames"][frameNo]
            r = f["frame"]
            sourceRect = (
                r["x"] + PADDING,
                r["y"] + PADDING,
                r["x"] + r["w"] - PADDING,
                r["y"] + r["h"] - PADDING,
            )
            targetRect = (f["rect"][0], f["rect"][1], f["rect"][2], f["rect"][3] - 1, f["rect"][4] - 1)

            dx, dy = scanOffset(sourceRect, frameName, frameTag)

            # once we have multiple bin, then we will need to not default to packed_image
            cropped = frameTag['img'].crop(sourceRect)
            if frameTag['size'] > 1:
                cropped = cropped.resize((targetRect[3], targetRect[4]), Image.NEAREST)
                dx = dx * frameTag['size']
                dy = dy * frameTag['size']

            packed_image.paste(
                cropped,
                (targetRect[1], targetRect[2], targetRect[1] + targetRect[3], targetRect[2] + targetRect[4])
            )
            frame =  {
                "filename": f["filename"],
                "frame": { "x": targetRect[1], "y": targetRect[2], "w": targetRect[3], "h": targetRect[4] },
                "rotated": f["rotated"],
                "trimmed": f["trimmed"],
                "spriteSourceSize": { "x": 0, "y": 0, "w": targetRect[3], "h": targetRect[4] },
                "sourceSize": { "w": packed_size[0], "h": packed_size[1] },
                "duration": f["duration"],
            }

            if dx != 0 or dy != 0:
                frame["center"] = { "x": dx, "y": dy }

            frames.append(frame)

        frameTo = len(frames) - 1

        # update the frametags
        frameTags.append({
            "name": frameName, "from": frameFrom, "to": frameTo, "direction": oldFrameTag["direction"]
        })

    # output the same format as aseprite
    outputjson = {
        "frames": frames,
        "meta": {
            "image": outputfile[0].split('/')[-1],
            "format": "RGBA8888",
            "size": {"w": packed_size[0], "h": packed_size[1]},
            "scale": "1",
            "frameTags": frameTags
        }
    }
    with open(outputfile[1], "w") as f:
        print(json.dumps(outputjson, indent=2), file=f)

    # output the new image
    packed_image.save(outputfile[0])

"""
This is currently a work in progress
"""
if __name__ == "__main__":
    parse_env()
    main()


