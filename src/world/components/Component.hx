package world.components;

class Component extends zf.engine2.Component implements StructSerialisable {
	public var entity(get, never): Entity;

	inline function get_entity(): Entity {
		return this.__entity__ == null ? null : cast this.__entity__;
	}

	public function toStruct(context: SerialiseContext, option: SerialiseOption): Dynamic {
		return null;
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, conf: Dynamic): Component {
		return this;
	}
}
