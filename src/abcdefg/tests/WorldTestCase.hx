package abcdefg.tests;

class WorldTestCase extends zf.engine2.tests.WorldTestCase {
	public var world(get, never): World;

	public var profile(default, null): userdata.Profile;

	public function get_world(): World {
		return cast this.__world__;
	}

	public function new(testId: String, name: String) {
		super(testId, name);
	}

	override public function setup() {
		super.setup();
		// create world
		final p = Globals.savefile.userProfiles.getProfile('test-${testId}');
		this.profile = new userdata.Profile(p);
		final world = new World(W.rules, profile);
		this.initWorld(world);
	}
}
