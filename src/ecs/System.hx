package ecs;

import ecs.Entity;
import ecs.Mailbox;
import ecs.World;

/**
  Abstract System class
**/
class System {

    /**
      type represent the string type of the system
    **/
    public var type(default, null): String;

    /**
      The mailbox used to communicate between systems
    **/
    public var mailbox(default, set): Mailbox;

    var world: World;

    /**
      setter for mailbox
    **/
    public function set_mailbox(mailbox: Mailbox): Mailbox {
        this.mailbox = mailbox;
        if (this.mailbox != null) {
            onMailboxSet();
        } else {
            onMailboxRemoved();
        }
        return this.mailbox;
    }

    /**
      2 function to be called when mailbox is set or removed
    **/
    function onMailboxSet() {}
    function onMailboxRemoved() {}

    public function new(type: String) {
        this.type = type;
        this.mailbox = null;
    }

    /**
      init function is called when the system is added to the system
    **/
    public function init(world: World, mailbox: Mailbox) {
        this.world = world;
        this.mailbox = mailbox;
    }

    /**
      addEntity adds an entity into the system
    **/
    public function addEntity(ent: Entity) {}

    /**
      removeEntity removes an entity into the system
    **/
    public function removeEntity(ent: Entity): Entity {
        return ent;
    }

    /**
      update is the main function called by the world.
    **/
    public function update(dt: Float) {
    }
}
