package world;

import world.systems.*;

class World extends zf.ecs.World {
    public var renderSystem: RenderSystem;

    public function new() {
        super();

        this.addSystem(this.renderSystem = new RenderSystem());
    }
}
