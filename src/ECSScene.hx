
import common.ecs.World;
import common.ecs.System;
import common.ecs.Entity;
import common.ecs.Component;

class ECSScene extends common.Scene {

    var scene: h2d.Scene;

    var world: World;

    public function new() {
        this.scene = new h2d.Scene();
        this.world = new World();
    }

    override public function update(dt: Float) {
        this.world.update(dt);
    }

    override public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    override public function onEvent(event: hxd.Event) {
    }
}
