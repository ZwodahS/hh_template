package abcdefg.tests;

/**
	A template for test cases without World object
**/
class TestTemplate extends TestCase {
	public static final Name = "g.template";

	public function new(testId: String) {
		super(testId, Name);
	}

	override function setup() {
		initSteps();
	}

	function initSteps() {
		wait(2);
		run(() -> {
			Assert.assertEqual(1, 1);
		});
	}
}
