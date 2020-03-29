
package examples;

import common.h2d.Animation.Animator;

class AnimationScene extends common.Scene {

    var assets: common.Assets;

    var scene: h2d.Scene;
    var backgroundLayer: h2d.Layers;
    var foregroundLayer: h2d.Layers;

    var animator: common.h2d.Animation.Animator;

    var obj7: h2d.Drawable;

    public function new(assets: common.Assets, console: h2d.Console) {
        this.scene = new h2d.Scene();
        this.assets = assets;
        this.init();

        this.backgroundLayer = new h2d.Layers();
        this.foregroundLayer = new h2d.Layers();
        this.scene.add(backgroundLayer, 0);
        this.scene.add(foregroundLayer, 1);

        this.animator = new common.h2d.Animation.Animator();

        var obj1 = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, 32, 32));
        obj1.x = 32; obj1.y = 32;
        this.backgroundLayer.add(obj1, 0);
        this.animator.moveTo(obj1, [128, 32], 32, function() {obj1.visible = false;});

        var obj2 = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32));
        obj2.x = 32; obj2.y = 32;
        this.backgroundLayer.add(obj2, 0);
        this.animator.moveTo(obj2, [32, 128], 32);

        var obj3 = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, 32, 32));
        obj3.x = 64; obj3.y = 64;
        this.backgroundLayer.add(obj3, 0);
        this.animator.moveBy(obj3, [96, 0], 32, function() {
            this.animator.alphaTo(obj3, 0, 0.5);
        });

        var obj4 = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32));
        obj4.x = 64; obj4.y = 64;
        this.backgroundLayer.add(obj4, 0);
        this.animator.moveBy(obj4, [0, 96], 32, function() {obj4.y = 64;});

        var obj4 = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32));
        obj4.x = 128; obj4.y = 128;
        this.backgroundLayer.add(obj4, 0);
        this.animator.scaleTo(obj4, [2.0, 2.0], 0.25, function() {
            this.animator.moveBy(obj4, [64, 64], 32);
        });

        // allow us to scale while anchor to center
        var obj5 = new h2d.Layers();
        var obj6 = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32));
        obj6.x = -16;
        obj6.y = -16;
        obj5.add(obj6, 0);
        obj5.x = 160;
        obj5.y = 160;
        this.backgroundLayer.add(obj5, 0);
        this.animator.scaleTo(obj6, [2.0, 2.0], 0.25);

        this.obj7 = new h2d.Bitmap(h2d.Tile.fromColor(0xFF9999, 32, 32));
        obj7.y = 200;
        this.backgroundLayer.add(obj7, 0);
        this.animator.move(obj7, 3, [32, 0]);

    }

    function init() {}

    override public function update(dt: Float) {
        animator.update(dt);
    }

    override public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    override public function onEvent(event: hxd.Event) {
        if (event.kind == hxd.Event.EventKind.EKeyDown) {
            this.obj7.x -= 60;
        }
    }

}
