package world.components;

/**
	The main render component for all entities
**/
class RenderComponent extends Component {
	public var object: h2d.Object;

	public function new(object: h2d.Object = null) {
		this.object = object == null ? new h2d.Object() : object;
	}

	inline public function sync() {
		if (this.entity.x != this.object.x) this.object.x = this.entity.x;
		if (this.entity.y != this.object.y) this.object.y = this.entity.y;
		if (this.entity.rotation != this.object.rotation) this.object.rotation = this.entity.rotation;
	}

	override public function dispose() {
		this.object.remove();
		this.object = null;
	}
}
