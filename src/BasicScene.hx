
class BasicScene implements common.Scene {

    var scene: h2d.Scene;

    public function new() {
        this.scene = new h2d.Scene();
    }

    public function update(dt: Float) {
    }

    public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    public function onEvent(event: hxd.Event) {
    }
}
