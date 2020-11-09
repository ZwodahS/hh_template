package world.systems;

import world.Entity;

class RenderSystem extends common.ecs.System<Entity> {
    public var drawLayer(default, null): h2d.Layers;

    public function new() {
        super();

        this.drawLayer = new h2d.Layers();
    }
}
