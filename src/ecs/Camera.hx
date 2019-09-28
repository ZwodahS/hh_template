
package ecs;

enum MoveType {
    Incremental;
    Center;
}
/**
  Camera Event
**/
class CameraMoveMessage extends Message {
    public static final TYPE_STRING = "ecs.Camera.CameraMoveMessage";

    public var x(default, null): Float;
    public var y(default, null): Float;
    public var moveType(default, null): MoveType;

    public function new(x: Float = 0, y: Float = 0, moveType: MoveType = Incremental) {
        super();
        this.x = x;
        this.y = y;
        this.moveType = moveType;
    }

    override public function get_type(): String {
        return CameraMoveMessage.TYPE_STRING;
    }
}

class CameraSystem extends System {

    public var camera(default, null): h2d.Camera;

    public function new(parent: h2d.Object) {
        super("ecs.Camera.CameraSystem");
        this.camera = new h2d.Camera(parent);

    }

    override public function init(world: World, mailbox: Mailbox) {
        super.init(world, mailbox);

        // set up camera event
        this.mailbox.listen(CameraMoveMessage.TYPE_STRING, function(message: Message) {
            var camMoveMessage: CameraMoveMessage = cast(message, CameraMoveMessage);

            if (camMoveMessage.moveType == MoveType.Incremental) {
                this.camera.viewX += camMoveMessage.x;
                this.camera.viewY += camMoveMessage.y;
            } else if (camMoveMessage.moveType == MoveType.Center) {
                this.camera.viewX = camMoveMessage.x;
                this.camera.viewY = camMoveMessage.y;
            }
        });

    }
}
