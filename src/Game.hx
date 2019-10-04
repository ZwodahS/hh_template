
import gamescene.GameScene;

class Game extends hxd.App {

    var currentScene: common.Scene;
    var framerate: h2d.Text;

    override function init() {
        // resize window if necessary
        var window = hxd.Window.getInstance();
        // window.resize(1600, 900);

        hxd.Res.initEmbed();

        var assetsMap = common.Assets.parseAssets("assets.json");
        this.currentScene = new GameScene(assetsMap);

        // add event handler
        hxd.Window.getInstance().addEventTarget(onEvent);

        // set up the framerate text and draw
        var font : h2d.Font = hxd.res.DefaultFont.get();
        font.resizeTo(24);
        this.framerate = new h2d.Text(font);
        framerate.textAlign = Right;
        framerate.x = hxd.Window.getInstance().width - 10;
        this.s2d.add(this.framerate, 0);

    }

    override function update(dt:Float) {
        this.currentScene.update(dt);
        this.framerate.text = '${common.MathUtils.round(1/dt, 1)}';
    }

    override function render(engine: h3d.Engine) {
        this.currentScene.render(engine);
        this.s2d.render(engine);
    }

    function onEvent(event: hxd.Event) {
        this.currentScene.onEvent(event);
    }

}
