
package examples;

import common.Point2f;

class DragScene extends common.Scene {

    var scene: h2d.Scene;
    var camera: h2d.Camera;
    var layer: h2d.Layers;

    var entities: List<h2d.Drawable>;

    public function new(scene: h2d.Scene, console: h2d.Console) {
        this.scene = scene;
        this.camera = new h2d.Camera(this.scene);
        this.layer = new h2d.Layers(this.camera);

        this.entities = new List<h2d.Drawable>();

        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x0000FF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFFFF00, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x00FFFF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 32, 32)));

        for (i => obj in this.entities) {
            obj.x = (i * 64);
            obj.y = (i * 64);
            this.layer.add(obj, 0);
        }
    }

    var mouseDownEvent: hxd.Event = null;
    var startDrag: Bool = false;
    var mouseCurrent: Point2f = [0.0, 0.0];

    var currentObject: h2d.Object = null;
    function mouseDown(event: hxd.Event) {
        // find entity
        var worldCoord: Point2f = [event.relX, event.relY];
        for (obj in this.entities) {
            // simple collision test
            if (obj.x > worldCoord.x || obj.y > worldCoord.y || obj.x + 32 < worldCoord.x || obj.y + 32 < worldCoord.y) {
                continue;
            }
            this.currentObject = obj;
            break;
        }
    }

    function mouseMoved(event: hxd.Event) {
        var worldCoord: Point2f = [event.relX, event.relY];
        if (this.currentObject != null) {
            this.currentObject.x = worldCoord.x - 16;
            this.currentObject.y = worldCoord.y - 16;
        }
    }

    function mouseUp(event: hxd.Event) {
        this.currentObject = null;
    }

    override public function update(dt: Float) {
    }

    override public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }
    override public function onEvent(event: hxd.Event) {
        switch(event.kind) {
            case hxd.Event.EventKind.EPush:
                this.mouseDown(event);
            case hxd.Event.EventKind.ERelease:
                this.mouseUp(event);
            case hxd.Event.EventKind.EMove:
                this.mouseMoved(event);
            default:
        }
    }
    override public function destroy() {
        this.scene.removeChild(this.camera);
    }
}
