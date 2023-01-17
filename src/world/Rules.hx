package world;

import world.factories.EntityFactory;

class Rules {
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

	function exec(path: String): Dynamic {
		try {
			final expr = this.structLoader.loadFile(path);
			final ast = this.parser.parseString(expr);
			return this.interp.execute(ast);
		} catch (e) {
			Logger.exception(e);
			Logger.warn('Fail to parse: ${path}');
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
		final option: SerialiseOption = {};
		final state = new WorldState(this, Random.int(0, zf.Constants.SeedMax));
		state.loadStruct(context, option, data);
		return state;
	}

	/**
		Save a world state to path
	**/
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

	/**
		Call by worldState to loadStruct
	**/
	public function loadStruct(context: SerialiseContext, option: SerialiseOption, state: WorldState,
			data: Dynamic): WorldState {
		final stateSF: WorldStateSF = cast data;
		final entitiesSF: Array<EntitySF> = stateSF.entities;
		final entities: Entities<Entity> = new Entities<Entity>();
		context.add(entities);

		for (sf in entitiesSF) {
			final factory = this.entities[sf.typeId];
			if (factory == null) {
				Logger.warn('Fail to load entity, Type: ${sf.typeId}, Id: ${sf.id}');
				continue;
			}
			final entity = factory.load(context, option, sf);
			entities.add(entity);
		}

		// for each of the entities, now we can load the entity proper
		for (sf in entitiesSF) {
			final entity = entities.get(sf.id);
			if (entity == null) continue;
			entity.loadStruct(context, option, sf);
		}

		@:privateAccess state.intCounter.counter = stateSF.intCounter;
		return state;
	}

	/**
		Call by worldState to convert WorldState to struct
	**/
	public function toStruct(context: SerialiseContext, option: SerialiseOption, state: WorldState): WorldStateSF {
		final entities: Entities<Entity> = new Entities<Entity>();
		context.add(entities);

		final stateSF: WorldStateSF = {};

		// store the id generators
		@:privateAccess stateSF.intCounter = state.intCounter.counter;

		// collect all the entities before this is called
		final entitiesSF = [for (entity in entities) entity.toStruct(context, option)];
		stateSF.entities = entitiesSF;

		return stateSF;
	}
}
