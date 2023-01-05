import zf.tests.TestCase;
import zf.tests.TestScreen;

class TestSetup {
	public static function makeTestScreen() {
		final screen = new TestScreen();
		screen.fonts = Assets.debugFonts;
		final tests = getAllTests();
		for (name => test in tests) {
			screen.addTestCase(name, test);
		}
		screen.game = Globals.game;
		screen.finalise();
		return screen;
	}

	public static function getTestNames(): Array<String> {
		return [for (k in getAllTests().keys()) k];
	}

	public static function getAllTests(): Map<String, Class<TestCase>> {
		final tests = new Map<String, Class<TestCase>>();

		// we will still load all the test cases
		CompileTime.importPackage("tests");
		final classes = CompileTime.getAllClasses('tests', true, TestCase);
		for (c in classes) {
			if (Reflect.field(c, "Name") == null) {
				continue;
			}
			tests[Reflect.field(c, "Name")] = c;
		}
		return tests;
	}
}
