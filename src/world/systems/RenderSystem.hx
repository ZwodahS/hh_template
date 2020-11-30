package world.systems;

import world.Entity;

class RenderSystem extends zf.ecs.System {
    public var drawLayer(default, null): h2d.Layers;

    public function new() {
        super();

        this.drawLayer = new h2d.Layers();
    }
}
