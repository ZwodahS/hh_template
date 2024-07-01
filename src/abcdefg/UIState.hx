package abcdefg;

/**
	This can be used to store ui state, like selected object, menu position etc.
**/
class UIState implements Identifiable {
	public function new() {}

	public function identifier() {
		return "UIState";
	}
}
