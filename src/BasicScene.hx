
class BasicScene extends common.Scene {

    var scene: h2d.Scene;

    public function new() {
        this.scene = new h2d.Scene();
    }

    override public function update(dt: Float) {
    }

    override public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    override public function onEvent(event: hxd.Event) {
    }
}
