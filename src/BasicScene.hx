class BasicScene extends common.Scene {
    var scene: h2d.Scene;

    var wall: h2d.Object;

    public function new(scene: h2d.Scene) {
        this.scene = scene;

        // this.wall = Globals.assets.get("wall").getBitmap();
        // this.scene.add(this.wall, 0);
    }

    override public function update(dt: Float) {}

    override public function render(engine: h3d.Engine) {}

    override public function onEvent(event: hxd.Event) {}

    override public function destroy() {}
}
