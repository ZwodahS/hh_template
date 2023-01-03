package world.components;

class InteractiveComponent extends Component {
	public static final ComponentType = "InteractiveComponent";

	public var interactive: Interactive;

	public function new(width: Int, height: Int) {
		this.interactive = new Interactive(width, height);
		this.interactive.enableRightButton = true;

		this.interactive.dyOnRemove = function() {
			_dyOnRemove();
		}
		this.interactive.onOver = function(e: hxd.Event) {
			_onOver();
		}
		this.interactive.onOut = function(e: hxd.Event) {
			_onOut();
		}
		this.interactive.onClick = function(e: hxd.Event) {
			if (e.button == 0) {
				_onLeftClick();
			} else if (e.button == 1) {
				_onRightClick();
			}
			_onClick(e.button);
		}
		this.interactive.onPush = function(e: hxd.Event) {
			_onPush();
		}
		this.interactive.onRelease = function(e: hxd.Event) {
			_onRelease();
		}
	}

	// ---- On out ---- //
	var onOutListeners: Array<Pair<String, Void->Void>> = [];

	public function _onOut() {
		for (p in this.onOutListeners) p.second();
	}

	public function addOnOutListener(id: String, func: Void->Void): Bool {
		for (o in this.onOutListeners) {
			if (o.first == id) return false;
		}
		this.onOutListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnOutListener(id: String): Bool {
		for (o in this.onOutListeners) {
			if (o.first == id) {
				this.onOutListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Over ---- //
	var onOverListeners: Array<Pair<String, Void->Void>> = [];

	public function _onOver() {
		for (p in this.onOverListeners) p.second();
	}

	public function addOnOverListener(id: String, func: Void->Void): Bool {
		for (o in this.onOverListeners) {
			if (o.first == id) return false;
		}
		this.onOverListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnOverListener(id: String): Bool {
		for (o in this.onOverListeners) {
			if (o.first == id) {
				this.onOverListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Click ---- //
	var onClickListeners: Array<Pair<String, Int->Void>> = [];

	public function _onClick(button: Int) {
		for (p in this.onClickListeners) p.second(button);
	}

	public function addOnClickListener(id: String, func: Int->Void): Bool {
		for (o in this.onClickListeners) {
			if (o.first == id) return false;
		}
		this.onClickListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnClickListener(id: String): Bool {
		for (o in this.onClickListeners) {
			if (o.first == id) {
				this.onClickListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Left Click ---- //
	var onLeftClickListeners: Array<Pair<String, Void->Void>> = [];

	public function _onLeftClick() {
		for (p in this.onLeftClickListeners) p.second();
	}

	public function addOnLeftClickListener(id: String, func: Void->Void): Bool {
		for (o in this.onLeftClickListeners) {
			if (o.first == id) return false;
		}
		this.onLeftClickListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnLeftClickListener(id: String): Bool {
		for (o in this.onLeftClickListeners) {
			if (o.first == id) {
				this.onLeftClickListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Right Click ---- //
	var onRightClickListeners: Array<Pair<String, Void->Void>> = [];

	public function _onRightClick() {
		for (p in this.onRightClickListeners) p.second();
	}

	public function addOnRightClickListener(id: String, func: Void->Void): Bool {
		for (o in this.onRightClickListeners) {
			if (o.first == id) return false;
		}
		this.onRightClickListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnRightClickListener(id: String): Bool {
		for (o in this.onRightClickListeners) {
			if (o.first == id) {
				this.onRightClickListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Push ---- //
	var onPushListeners: Array<Pair<String, Void->Void>> = [];

	public function _onPush() {
		for (p in this.onPushListeners) p.second();
	}

	public function addOnPushListener(id: String, func: Void->Void): Bool {
		for (o in this.onPushListeners) {
			if (o.first == id) return false;
		}
		this.onPushListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnPushListener(id: String): Bool {
		for (o in this.onPushListeners) {
			if (o.first == id) {
				this.onPushListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Release ---- //
	var onReleaseListeners: Array<Pair<String, Void->Void>> = [];

	public function _onRelease() {
		for (p in this.onReleaseListeners) p.second();
	}

	public function addOnReleaseListener(id: String, func: Void->Void): Bool {
		for (o in this.onReleaseListeners) {
			if (o.first == id) return false;
		}
		this.onReleaseListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnReleaseListener(id: String): Bool {
		for (o in this.onReleaseListeners) {
			if (o.first == id) {
				this.onReleaseListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- On Removed ---- //
	var onRemoveListeners: Array<Pair<String, Void->Void>> = [];

	public function _dyOnRemove() {
		for (p in this.onRemoveListeners) p.second();
	}

	public function addOnRemoveListener(id: String, func: Void->Void): Bool {
		for (o in this.onRemoveListeners) {
			if (o.first == id) return false;
		}
		this.onRemoveListeners.push(new Pair(id, func));
		return true;
	}

	public function removeOnRemoveListener(id: String): Bool {
		for (o in this.onRemoveListeners) {
			if (o.first == id) {
				this.onRemoveListeners.remove(o);
				return true;
			}
		}
		return false;
	}

	// ---- others ---- //
	public function removeAllListeners(id: String) {
		removeOnOutListener(id);
		removeOnOverListener(id);
		removeOnLeftClickListener(id);
		removeOnRightClickListener(id);
		removeOnPushListener(id);
		removeOnReleaseListener(id);
		removeOnRemoveListener(id);
	}
}
