class Game extends hxd.App {
    var GameWidth: Int = 800;
    var GameHeight: Int = 600;

    var currentScene: common.Scene;

    var framerate: h2d.Text;
    var console: h2d.Console;

    override function init() {
#if debug
        this.setupConsole();
        this.setupFramerate();
#end
        this.s2d.scaleMode = Stretch(this.GameWidth, this.GameHeight);

        var assetsMap = common.Assets.parseAssets("assets.json");
        this.switchScene(new BasicScene(this.s2d));

        // add event handler
        this.s2d.addEventListener(this.onEvent);
    }

#if debug
    function setupFramerate() {
        var font: h2d.Font = hxd.res.DefaultFont.get().clone();
        font.resizeTo(24);

        this.framerate = new h2d.Text(font);
        framerate.textAlign = Right;
        framerate.x = hxd.Window.getInstance().width - 10;

        this.s2d.add(this.framerate, 0);
        framerate.visible = false;
    }

    function setupConsole() {
        var font = hxd.res.DefaultFont.get().clone();
        font.resizeTo(12);

        this.console = new h2d.Console(font);
        this.s2d.add(this.console, 10);

        this.console.addCommand("getWindowSize", "get the window size", [], function() {
            var window = hxd.Window.getInstance();
            this.console.log('${window.width}: ${window.height}');
        });

        this.console.addCommand("printString", "print a string",
            [{"name": "string", "t": h2d.Console.ConsoleArg.AString},], function(string) {
                this.console.log(string);
        });

        this.console.addCommand("framerate", "toggle framerate", [], function() {
            this.framerate.visible = !this.framerate.visible;
        });
        this.console.addAlias("fr", "framerate");
    }
#end

    override function update(dt: Float) {
        this.currentScene.update(dt);
#if debug
        this.framerate.text = '${common.MathUtils.round(1 / dt, 1)}';
#end
    }

    override function onResize() {
        // Do any resizing of the "world" if necessary
        if (this.currentScene != null) this.currentScene.resize(this.GameWidth, this.GameHeight);
    }

    override function render(engine: h3d.Engine) {
        this.currentScene.render(engine);
        this.s2d.render(engine);
    }

    function onEvent(event: hxd.Event) {
        this.currentScene.onEvent(event);
    }

    function switchScene(scene: common.Scene) {
        var oldScene = this.currentScene;
        this.currentScene = scene;
        if (oldScene != null) {
            oldScene.destroy();
        }
    }
}
