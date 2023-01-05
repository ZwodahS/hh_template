package tests;

class WorldTestCase extends zf.engine2.tests.WorldTestCase {
	public var world(get, never): World;

	public var profile(default, null): userdata.Profile;

	public function get_world(): World {
		return cast super.__world__;
	}

	public function new(testId: String, name: String) {
		final p = Globals.savefile.userProfiles.getProfile('test-${testId}');
		this.profile = new userdata.Profile(p);
		final world = new World(Globals.rules, profile);
		// we will create our world here.
		super(testId, name, world);
	}
}
