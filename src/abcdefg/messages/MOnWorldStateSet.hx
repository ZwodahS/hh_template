package abcdefg.messages;

#if !macro
@:build(zf.macros.ObjectPool.addObjectPool())
#end
class MOnWorldStateSet extends zf.Message {
	public static final MessageType = "MOnWorldStateSet";

	function new() {
		super(MessageType);
	}

	public function reset() {}

	public static function alloc(): MOnWorldStateSet {
		final m = __alloc__();
		return m;
	}
}
/**
	# Dispatchers
	- ????
	# Listeners
	- [0] ???? - ????
**/
