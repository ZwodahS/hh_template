package world.systems;

import echo.Body;
#if debug
import echo.util.Debug.HeapsDebug;
#end

class EchoSystem extends System {
	public static final WorldSize: Point2f = [200, 200];

	public var echoWorld: echo.World;

#if debug
	public var debugDraw: HeapsDebug;
#end

	public function new() {
		super();
		reset();
	}

	override public function init(world: zf.engine2.World) {
		super.init(world);
#if debug
		this.debugDraw = new HeapsDebug(this.world.renderSystem.worldDebugLayers);
#end

		// @:listen EchoSystem MOnWorldStateSet 0
		dispatcher.listen(MOnWorldStateSet.MessageType, (message: zf.Message) -> {
			for (entity in this.world.worldState.entities) {
				onEntityAdded(entity);
			}
		}, 0);
	}

	override public function onEntityAdded(e: zf.engine2.Entity) {
		final entity: Entity = cast e;
		if (shouldAdd(entity) == false) return;
		this.echoWorld.add(entity.echo.body);
		// force update the position of the entity to update echo.
		e.x = e.x;
		e.y = e.y;
	}

	override public function onEntityRemoved(e: zf.engine2.Entity) {
		final entity: Entity = cast e;
		if (shouldAdd(entity) == false) return;
		this.echoWorld.remove(entity.echo.body);
	}

	inline function shouldAdd(e: Entity): Bool {
		return e.echo != null && e.echo.simulate == true;
	}

	override public function reset() {
		super.reset();
		if (this.echoWorld != null) this.echoWorld.dispose();

		this.echoWorld = new echo.World({
			width: WorldSize.x + 1000,
			height: WorldSize.y + 1000,
			gravity_y: 0,
		});

		this.echoWorld.listen(null, null, {});
	}

	override public function update(dt: Float) {
		super.update(dt);

		dt = dt * this.world.worldSpeed;
		this.echoWorld.step(dt);

#if debug
		if (hxd.Key.isPressed(hxd.Key.QWERTY_TILDE)) this.debugDraw.canvas.visible = !this.debugDraw.canvas.visible;
		if (this.debugDraw.canvas.visible == true) {
			this.debugDraw.draw(this.echoWorld);
			for (e in this.world.worldState.entities) {
				// entities that are added to the simulation are already drawn.
				if (e.echo == null || e.echo.addToSimulation == true) continue;
				// draw the shapes that are not in the simulation
				for (shape in e.echo.body.shapes) debugDraw.draw_shape(shape);
			}
		}
#end
	}
}
