class Game extends zf.Game {
    override function init() {
        super.init();
#if debug
        Globals.console = this.console;
#end
        this.s2d.scaleMode = Stretch(Globals.gameWidth, Globals.gameHeight);

        Assets.packed = zf.Assets.loadAseSpritesheetConfig('packed.json');

        this.switchScreen(new examples.AnimationScene());
    }
}
