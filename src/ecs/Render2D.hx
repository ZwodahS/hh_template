package ecs;

import ecs.Component;
import ecs.System;
import ecs.World;
import ecs.Entity;
import ecs.Mailbox;
import ecs.EntityAwareComponent;
import ecs.Space.SpaceComponent;

/**
  Due to how heaps works, this have to be structured to work slightly differently.

  The render system needs to be slightly more aware of a lot of things since the render is tied to h2d.Scene
**/

class RenderComponent extends Component implements EntityAwareComponent{

    public static final TYPE_STRING = "ecs.Render2D.RenderComponent";

    /**
      The layer to render this component to

      For layer setting to work, the render component will need to be aware of the RenderSystem
      For now, we don't need it yet.
    **/
    public var layer(default, null): Int;
    /**
      Allowing the setting of drawable afterwards is actually very tricky.
      It will required us to store the spacecComponent.
      Because of this, shall assume that the drawable will not be replace.
    **/
    public var drawable(default, null): h2d.Drawable;

    /**
      The internal listener id for removing space compnent
    **/
    var listenerId: Int;

    var offset: Array<Float>;

    public function new(drawable: h2d.Drawable, layer: Int = 0, offset: Array<Float> = null) {
        super();
        this.drawable = drawable;
        if (offset != null) {
            this.offset = [ offset[0], offset[1] ];
        } else {
            this.offset = [ 0, 0 ];
        }
    }

    /**
      override the component added function of EntityAwareComponent
    **/
    public function onComponentAdded(ent: Entity) {
        // The main idea here is to link up the space component to the render component
        // such that the changes is reflected in the position of the drawable

        var spaceComponent = ent.getComponent(SpaceComponent.TYPE_STRING);
        if (spaceComponent == null) {
            spaceComponent = new SpaceComponent();
            ent.addComponent(spaceComponent);
        } else {
            var s = cast(spaceComponent, SpaceComponent);
            this.drawable.x = s.x + this.offset[0];
            this.drawable.y = s.y + this.offset[1];
        }

        this.listenerId = spaceComponent.addListener(
            function(component: Component) {
                var casted = cast(component, SpaceComponent);
                this.drawable.x = casted.x + this.offset[0];
                this.drawable.y = casted.y + this.offset[1];
            }
        );
    }

    public function onComponentRemoved(ent: Entity) {
        var spaceComponent = ent.getComponent(SpaceComponent.TYPE_STRING);
        if (spaceComponent != null) {
            spaceComponent.removeListener(this.listenerId);
        }
    }

    override public function get_type(): String {
        return RenderComponent.TYPE_STRING;
    }
}

/**
  RenderSystem wraps around the rendering functionality of heaps.
**/
class RenderSystem extends System{

    // the main layers to render to
    var layers: h2d.Layers;
    // the camera layer
    public var camera: h2d.Camera;

    /**
      Note to self: this likely needs to be refactored later once the camera system in heaps changes.
      For now this should work.
    **/

    public function new(scene: h2d.Scene) {
        super("ecs.Render2D.RenderSystem");
        this.camera = new h2d.Camera(scene);
        this.layers = new h2d.Layers(camera);
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

        this.mailbox.listen(ComponentAddedEvent.TYPE_STRING, function(message: Message) {
            var compAddMessage = cast(message, ComponentAddedEvent);
            this.registerEntity(compAddMessage.entity, compAddMessage.component);
        });

        this.mailbox.listen(ComponentRemovedEvent.TYPE_STRING, function(message: Message) {
            var compAddMessage = cast(message, ComponentRemovedEvent);
            this.unregisterEntity(compAddMessage.entity, compAddMessage.component);
        });
    }

    function registerEntity(ent: Entity, comp: Component) {
        if (comp != null && comp.type == RenderComponent.TYPE_STRING) {
            var renderComp = cast(
                comp,
                ecs.Render2D.RenderComponent
            );
            this.layers.add(renderComp.drawable, renderComp.layer);
        }
    }

    function unregisterEntity(ent: Entity, comp: Component) {
        if (comp != null && comp.type == RenderComponent.TYPE_STRING) {
            var renderComp = cast(
                comp,
                ecs.Render2D.RenderComponent
            );
            this.layers.removeChild(renderComp.drawable);
        }
    }

    /**
      When entity is added to the render system
    **/
    override public function addEntity(ent: Entity) {
        this.registerEntity(ent, ent.getComponent(ecs.Render2D.RenderComponent.TYPE_STRING));
    }

}

enum MoveType {
    Incremental;
    Center;
}
/**
  Camera Event
**/
class CameraMoveMessage extends Message {
    public static final TYPE_STRING = "ecs.Render2D.CameraMoveMessage";

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
