package abcdefg;

class Rules implements Identifiable {
	public function identifier(): String {
		return "Rules";
	}

	/**
		Store all the entity factories
	**/
	public var entities: Map<String, EntityFactory>;

	public var structLoader: zf.StructLoader;

	public var interp: hscript.Interp;
	public var parser: hscript.Parser;

	public function new() {
		this.entities = new Map<String, EntityFactory>();

		// ---- Set up struct loader ---- //
		this.structLoader = new zf.StructLoader();

		// ---- Set up hscript ---- //
		this.parser = new hscript.Parser();
		this.interp = new hscript.Interp();
	}

	// ---- Loader ---- //
	public function loadConfig(path: String) {
		final configPath = new haxe.io.Path(path);
		final expr = this.structLoader.loadFile(path);
		final ast = this.parser.parseString(expr);
		final defaultConf: RulesConf = this.interp.execute(ast);
	}

	// ---- HScript ---- //
	function exec(path: String): Dynamic {
		try {
			final expr = this.structLoader.loadFile(path);
			return executeScript(expr);
		} catch (e) {
			Logger.exception(e);
			Logger.warn('Fail to parse: ${path}');
			return null;
		}
	}

	inline public function executeScript(str: String): Dynamic {
		try {
			return this.interp.execute(this.parser.parseString(str));
		} catch (e) {
			return null;
		}
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
