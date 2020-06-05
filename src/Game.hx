
class Game extends hxd.App {

    var screenWidth: Int = 800;
    var screenHeight: Int = 600;

    var currentScene: common.Scene;

    var framerate: h2d.Text;
    var console: h2d.Console;

    var assetsMap: common.Assets;

    override function init() {
#if debug
        this.setupConsole();
        this.setupFramerate();
#end
        this.s2d.scaleMode = Stretch(this.screenWidth, this.screenHeight);

        this.assetsMap = common.Assets.parseAssets("assets.json");
        this.switchScene(new examples.AnimationScene(this.s2d, assetsMap, this.console));
        this.switchScene(new examples.DomkitScene(this.s2d, this.console));

        // add event handler
        hxd.Window.getInstance().addEventTarget(this.onEvent);
    }

#if debug
    function setupFramerate() {
        var font : h2d.Font = hxd.res.DefaultFont.get().clone();
        font.resizeTo(24);

        this.framerate = new h2d.Text(font);
        framerate.textAlign = Right;
        framerate.x = this.GameWidth - 10;

        this.s2d.add(this.framerate, 0);
        framerate.visible = false;
    }

    function setupConsole() {
        var font = hxd.res.DefaultFont.get().clone();
        font.resizeTo(12);

        this.console = new h2d.Console(font, this.s2d);

        this.console.addCommand("getWindowSize", "get the window size", [], function() {
            var window = hxd.Window.getInstance();
            this.console.log('${window.width}: ${window.height}');
        });

        this.console.addCommand("printString", "print a string",
            [
                { "name": "string", "t": h2d.Console.ConsoleArg.AString },
            ],
            function(string) {
                this.console.log(string);
            }
        );

        this.console.addCommand("framerate", "toggle framerate", [], function() {
            this.framerate.visible = !this.framerate.visible;
        });
        this.console.addAlias("fr", "framerate");

        this.console.addCommand("animationScene", "Change to animation scene", [], function() {
            this.switchScene(new examples.AnimationScene(this.s2d, this.assetsMap, this.console));
        });

        this.console.addCommand("dragScene", "Change to drag scene", [], function() {
            this.switchScene(new examples.DragScene(this.s2d, this.console));
        });

        this.console.addCommand("domScene", "Change to dom scene", [], function() {
            this.switchScene(new examples.DomkitScene(this.s2d, this.console));
        });

    }
#end

    override function update(dt:Float) {
        this.currentScene.update(dt);
#if debug
        this.framerate.text = '${common.MathUtils.round(1/dt, 1)}';
#end

    }

    override function render(engine: h3d.Engine) {
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
