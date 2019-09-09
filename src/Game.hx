
class Game extends hxd.App {

    var bmp: h2d.Bitmap;

    override function init() {
        hxd.Res.initEmbed();

        var text = hxd.Res.load("font32.json").toText();
        var image = hxd.Res.load("font32.png").toTile();

        var assetsMap = common.Assets.parseAssets("assets.json");

        this.bmp = assetsMap.getAsset("character").getBitmap();
        this.s2d.addChild(this.bmp);

        // add event handler
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    // on each frame
    override function update(dt:Float) {
        bmp.x += dt * 100;
    }

    function onEvent(event: hxd.Event) {

        switch(event.kind) {
            case EKeyDown:
                if (event.keyCode == hxd.Key.S) {
                    bmp.y += 50;
                }
            case _:
        }
    }

}
