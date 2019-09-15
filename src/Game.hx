
class Game extends hxd.App {

    var character: ecs.Entity;
    var world: ecs.World;

    override function init() {
        hxd.Res.initEmbed();

        var text = hxd.Res.load("font32.json").toText();
        var image = hxd.Res.load("font32.png").toTile();

        var assetsMap = common.Assets.parseAssets("assets.json");

        // add event handler
        hxd.Window.getInstance().addEventTarget(onEvent);

        this.world = new ecs.World();

        // adding render system
        var renderSystem = new ecs.Render2D.RenderSystem(this.s2d);
        this.world.addSystem(renderSystem);

        // add character to the world
        var comp = new ecs.Render2D.RenderComponent(assetsMap.getAsset("character").getBitmap(), 1);
        var ent = ecs.Entity.newEntity();
        ent.addComponent(comp);
        this.world.addEntity(ent);
        this.character = ent;

        for (i in 0...10) {
            var s = new ecs.Space.SpaceComponent(i*32, i*32);
            var c = new ecs.Render2D.RenderComponent(assetsMap.getAsset("wall").getBitmap());
            var e = ecs.Entity.newEntity();
            e.addComponent(s);
            e.addComponent(c);
            this.world.addEntity(e);
        }
    }

    override function update(dt:Float) {
    }

    override function render(engine: h3d.Engine) {
        this.s2d.render(engine);
    }

    function onEvent(event: hxd.Event) {
        switch(event.kind) {
            case EKeyDown:
                var space = Std.downcast(
                    this.character.getComponent(ecs.Space.SpaceComponent.TYPE_STRING),
                    ecs.Space.SpaceComponent
                );
                if (event.keyCode == hxd.Key.S) {
                    space.y += 32;
                } else if (event.keyCode == hxd.Key.A) {
                    space.x -= 32;
                } else if (event.keyCode == hxd.Key.W) {
                    space.y -= 32;
                } else if (event.keyCode == hxd.Key.D) {
                    space.x += 32;
                } else if (event.keyCode == hxd.Key.UP) {
                } else if (event.keyCode == hxd.Key.DOWN) {
                } else if (event.keyCode == hxd.Key.LEFT) {
                } else if (event.keyCode == hxd.Key.RIGHT) {
                }

            case _:
        }
    }

}
