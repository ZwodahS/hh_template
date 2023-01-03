package world;

import world.factories.EntityFactory;

class Rules {
	public var entities: Map<String, EntityFactory>;

	public function new() {
		this.entities = new Map<String, EntityFactory>();
	}

	// ---- Make / Save / Load ---- //
	public function newGame(): WorldState {
		final state = new WorldState(this, Random.int(0, zf.Constants.SeedMax));
		return state;
	}

	public function loadFromPath(userdata: UserData, path: String): WorldState {
		// this is hard to do since we cannot read directory on web
		// we will need to construct the folder ourselves rather than recursively load it in WorldSaveFolder
		final fullPath = haxe.io.Path.join([path, "world.json"]);
		final result = userdata.loadFromPath(fullPath);
		var data: Dynamic = null;
		switch (result) {
			case SuccessContent(stringData):
				data = haxe.Json.parse(stringData);
			default:
				Logger.warn('Fail to load');
				return null;
		}
		return this.load(data);
	}

	public function load(data: Dynamic): WorldState {
		final context = new SerialiseContext();
		final option: SerialiseOption = {};
		final state = new WorldState(this, Random.int(0, zf.Constants.SeedMax));
		state.loadStruct(context, option, data);
		return state;
	}

	public function loadStruct(context: SerialiseContext, option: SerialiseOption, state: WorldState,
			data: Dynamic): WorldState {
		return state;
	}

	public function saveToPath(userdata: UserData, worldState: WorldState, path: String) {
		final context = new SerialiseContext();
		final worldStateSF = worldState.toStruct(context, {});
		final fullpath = haxe.io.Path.join([path, "world.json"]);
#if sys
		final jsonString = haxe.format.JsonPrinter.print(worldStateSF, "  ");
#else
		final jsonString = haxe.Json.stringify(worldStateSF);
#end
		final result = userdata.saveToPath(fullpath, jsonString);
		switch (result) {
			case Success:
			default:
				Logger.warn('Fail to save');
		}
	}

	public function toStruct(context: SerialiseContext, option: SerialiseOption,
			worldState: WorldState): WorldStateSF {
		return {};
	}
}
