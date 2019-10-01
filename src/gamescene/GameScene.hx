

class GameScene implements Scene {

    var assets: common.Assets;

    var world: ecs.World;

    var scene: h2d.Scene;
    var backgroundLayer: h2d.Layers;
    var foregroundLayer: h2d.Layers;

    public function new(assets: common.Assets) {
        this.scene = new h2d.Scene();
        this.assets = assets;
        this.init();
    }

    function init() {
        this.world = new ecs.World();

        // construct the draw layers in the correct order
        this.backgroundLayer = new h2d.Layers(this.scene);
        var cameraSystem = new ecs.Camera.CameraSystem(this.scene);
        this.foregroundLayer = new h2d.Layers(this.scene);

        // add camera system
        this.world.addSystem(cameraSystem);

        // add render system
        var renderSystem = new ecs.EntityRender2D.EntityRenderSystem(cameraSystem.camera);
        this.world.addSystem(renderSystem);

        // animation system
        this.world.addSystem(new ecs.Animation.AnimationSystem());

    }

    public function update(dt: Float) {
        world.update(dt);
    }

    public function render(engine: h3d.Engine) {
        this.scene.render(engine);
    }

    public function onEvent(event: hxd.Event) {
    }

}
