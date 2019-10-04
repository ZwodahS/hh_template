
package gamescene;

class GameScene implements common.Scene {

    var assets: common.Assets;

    var scene: h2d.Scene;
    var backgroundLayer: h2d.Layers;
    var foregroundLayer: h2d.Layers;

    public function new(assets: common.Assets) {
        this.scene = new h2d.Scene();
        this.assets = assets;
        this.init();
    }

    function init() {}

    public function update(dt: Float) {
    }

    public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    public function onEvent(event: hxd.Event) {
    }

}
