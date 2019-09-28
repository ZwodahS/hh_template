
class Game extends hxd.App {

    var currentScene: Scene;

    override function init() {
        hxd.Res.initEmbed();

        var assetsMap = common.Assets.parseAssets("assets.json");
        this.currentScene = new GameScene(assetsMap);

        // add event handler
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    override function update(dt:Float) {
        this.currentScene.update(dt);
    }

    override function render(engine: h3d.Engine) {
        this.currentScene.render(engine);
    }

    function onEvent(event: hxd.Event) {
        this.currentScene.onEvent(event);
    }

}
