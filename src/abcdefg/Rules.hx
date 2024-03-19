package abcdefg;

class Rules implements Identifiable {
	public function identifier(): String {
		return "Rules";
	}

	/**
		Store all the entity factories
	**/
	public var entities: Map<String, EntityFactory>;

	public function new() {
		this.entities = new Map<String, EntityFactory>();
	}

	// ---- Loader ---- //
	public function loadConfig(path: String) {
		final configPath = haxe.io.Path.join([path, "config.hs"]);
		final config: RulesConf = executePath(configPath);

		/**
			Example:
			if (config.tags != null) {
				for (c in config.tags) loadTag(path, c);
			}
		**/
	}

	// ---- Entity ---- //
	inline function registerEntity(factory: EntityFactory) {
		this.entities.set(factory.typeId, factory);
	}

	// ---- Rule Object ---- //
	/**
		1. classRule
		2. rules.loadRule
	**/
	// ---- Dynamic Type ---- //

	/**
		1. classDynamicType
		2. rules.loadDynamicType
	**/
	// ---- HScript ---- //
	function executePath(path: String): Dynamic {
		try {
			final expr = A.res.getStringFromPath(path);
			return executeScript(expr);
		} catch (e) {
			Logger.exception(e);
			Logger.warn('Fail to parse: ${path}');
			return null;
		}
	}

	inline public function executeScript(str: String): Dynamic {
		final parser = getParser();
		final interp = getInterp();
		return interp.execute(parser.parseString(str));
	}

	inline public function getParser(): hscript.Parser {
		return new hscript.Parser();
	}

	inline public function getInterp(): hscript.Interp {
		final interp = new hscript.Interp();
		return interp;
	}

	// ---- Make / Save / Load ---- //
	public function newGame(): WorldState {
		final state = new WorldState(this, Random.int(0, zf.Constants.SeedMax));
		return state;
	}

	/**
		Load A WorldState from path
	**/
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

	/**
		Load a WorldState from a data struct
	**/
	public function load(data: Dynamic): WorldState {
		final context = new SerialiseContext();
		context.add(this);
		final state = new WorldState(this, Random.int(0, zf.Constants.SeedMax));
		state.loadStruct(context, data);
		return state;
	}

	/**
		Save a world state to path
	**/
	public function saveToPath(userdata: UserData, worldState: WorldState, path: String) {
		final context = new SerialiseContext();
		final worldStateSF = worldState.toStruct(context);
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
}
