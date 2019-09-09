
package common;

/**
    TileConf is the format for loading tiles.

    the json is a dictionary.
    each key is the name of the tile
    each data contains the following the structure
    {
        "size": {
            "width": int,
            "height": int,
        },
        "rect": {
            "x1": int,
            "y1": int,
            "x2": int,
            "y2": int,
        }
    }

    The h2d.Tile is also stored here, but is not loaded via the jsonloader
**/
typedef TileConf = {
    var size: {
        var width: Int;
        var height: Int;
    }
    var rect: {
        var x1: Int;
        var y1: Int;
        var x2: Int;
        var y2: Int;
    };
    var image: h2d.Tile;
}

/**
    Tile is a combination of Tile:h2d.Tile + color:h3d.Vector
**/
class Tile {

    public var tile: h2d.Tile;
    public var color: h3d.Vector;

    public function new(t: h2d.Tile, color: h3d.Vector) {
        this.tile = t;
        this.color = color;
    }

    public function getBitmap(): h2d.Bitmap {
        var bm = new h2d.Bitmap(this.tile);
        bm.color = this.color;
        return bm;
    }
}

/**
  Asset2D is a single asset
  It contains a list of tile to create animation if needed.
**/
class Asset2D {

    public var key: String;
    public var tiles: Array<Tile>;

    public function new(key, tiles) {
        this.key = key;
        this.tiles = tiles;
    }

    public function getBitmap(): h2d.Bitmap{
        return this.tiles[0].getBitmap();
    }
}


/**
  Assets is the main loader and assets container.
**/
class Assets {

    var assetsMap: Map<String, Map<String, TileConf>>;

    var assets2D: Map<String, Asset2D>;

    public function new() {
        assetsMap = new Map<String, Map<String, TileConf>>();
        assets2D = new Map<String, Asset2D>();
    }

    public function getAssetsMap(filename: String): Map<String, TileConf> {
        if (this.assetsMap[filename] != null) {
            return this.assetsMap[filename];
        }

        // open the json file
        var jsonText = hxd.Res.load(filename+".json").toText();
        var parsed = haxe.Json.parse(jsonText);

        var data = new Map<String, TileConf>();

        for (key in Reflect.fields(parsed)) {
            data[key] = Reflect.field(parsed, key);
        }

        // open the image file
        var image = hxd.Res.load(filename+".png").toTile();
        for (k => v in data) {
            v.image = image.sub(v.rect.x1, v.rect.y1, v.size.width, v.size.height);
        }

        return data;
    }

    private function getTile(src: String, key: String): h2d.Tile {
        var map = this.getAssetsMap(src);
        return map[key].image;
    }

    public static function parseAssets(assetPath: String): Assets {
        var _assets = new Assets();
        var jsonText = hxd.Res.load(assetPath).toText();
        var parsed = haxe.Json.parse(jsonText);
        var data = new Map<String, {
            var frames: Array<{
                var src: String;
                var key: String;
                var color: Array<Int>;
            }>;
        }>();

        for (key in Reflect.fields(parsed)) {
            data[key] = Reflect.field(parsed, key);
        }

        for (key => conf in data) {
            var tiles = new Array<Tile>();
            for (frame in conf.frames) {
                var color = new h3d.Vector(
                        frame.color[0]/255, frame.color[1]/255, frame.color[2]/255, frame.color[3]/255
                );
                tiles.push(new Tile(_assets.getTile(frame.src, frame.key), color));
            }
            _assets.assets2D[key] = new Asset2D(key, tiles);
        }

        return _assets;
    }

    public function getAsset(name: String): Asset2D {
        return this.assets2D[name];
    }
}
