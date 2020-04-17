
package examples;

@:uiComp("button")
class ButtonComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <button>
		<text public id="labelTxt" />
	</button>

	public var label(get, set): String;
	function get_label() return labelTxt.text;
	function set_label(s) {
		labelTxt.text = s;
		return s;
	}

	public function new( ?parent ) {
		super(parent);
		initComponent();
		enableInteractive = true;
		interactive.onClick = function(_) onClick();
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onPush = function(_) {
			dom.active = true;
		};
		interactive.onRelease = function(_) {
			dom.active = false;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
		};
	}

	public dynamic function onClick() {
        trace('hi');
	}
}

@:uiComp("container")
class ContainerComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <container>
		<button public id="btn"/>
		<button public id="btn1"/>
		<button public id="btn2"/>
	</container>;

	public function new(align:h2d.Flow.FlowAlign, ?parent) {
		super(parent);
		initComponent();
	}

}

class DomkitScene extends common.Scene {

    var scene: h2d.Scene;
    var camera: h2d.Camera;
    var layer: h2d.Layers;
    var uiLayer: h2d.Flow;

    var entities: List<h2d.Drawable>;

    var style = null;

    public function new(s2d: h2d.Scene, console: h2d.Console) {
        this.scene = s2d;

        this.camera = new h2d.Camera(this.scene);
        this.layer = new h2d.Layers(this.camera);

        this.entities = new List<h2d.Drawable>();

        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x0000FF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFFFF00, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0x00FFFF, 32, 32)));
        this.entities.add(new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 32, 32)));

        for (i => obj in this.entities) {
            obj.x = (i * 64);
            obj.y = (i * 64);
            this.layer.add(obj, 0);
        }

        this.uiLayer = new h2d.Flow(this.scene);
		this.uiLayer.horizontalAlign = this.uiLayer.verticalAlign = Middle;
		onResize();
		var root = new ContainerComp(Right, this.uiLayer);

		// Override
		root.btn.label = "Button";
		root.btn1.label = "Highlight ON";
		root.btn2.labelTxt.text = "Highlight OFF";

		root.btn1.onClick = function() {
			root.btn.dom.addClass("highlight");
		}
		root.btn2.onClick = function() {
			root.btn.dom.removeClass("highlight");
		}

		this.style = new h2d.domkit.Style();
		this.style.load(hxd.Res.style);
		this.style.addObject(root);
    }

	function onResize() {
		this.uiLayer.minWidth = uiLayer.maxWidth = this.scene.width;
		this.uiLayer.minHeight = uiLayer.maxHeight = this.scene.height;
	}

    override public function update(dt: Float) {
        this.style.sync();
    }

    override public function destroy() {
        trace('destroy');
        this.scene.removeChild(this.camera);
        this.scene.removeChild(this.uiLayer);
    }

}
