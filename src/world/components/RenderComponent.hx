package zf.engine2.components;

/**
	The main render component for all entities
**/
class RenderComponent extends Component {
	public var object: h2d.Object;

	public function new(object: h2d.Object = null) {
		this.object = object == null ? new h2d.Object() : object;
	}
}
