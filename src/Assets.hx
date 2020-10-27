/**
    Assets is used to store loaded assets
**/

import common.Assets.Asset2D;

class Assets {
    public static var packed: {
        tile: h2d.Tile,
        assets: Map<String, Asset2D>,
    };
}
