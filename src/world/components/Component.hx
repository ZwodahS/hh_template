package world.components;

class Component extends zf.engine2.Component {
	public var entity(get, never): Entity;

	inline function get_entity(): Entity {
		return this.__entity__ == null ? null : cast this.__entity__;
	}
}
