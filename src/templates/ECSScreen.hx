import zf.ecs.World;
import zf.ecs.System;
import zf.ecs.Entity;
import zf.ecs.Component;

class ECSScreen extends zf.Screen {
    var world: World;

    public function new() {
        this.world = new World();
    }

    override public function update(dt: Float) {
        this.world.update(dt);
    }

    override public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    override public function onEvent(event: hxd.Event) {}
}
