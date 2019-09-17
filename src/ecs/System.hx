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
      a list of entities in this system
    **/
    var entities: Map<Int, Entity>;

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
        this.entities = new Map<Int, Entity>();
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
    public function addEntity(ent: Entity) {
        var existing = this.entities.get(ent.id);
        if (existing == null) {
            this.entities[ent.id] = ent;
            this.onEntityAdded(ent);
        }
    }

    /**
      removeEntity removes an entity into the system
    **/
    public function removeEntity(ent: Entity): Entity {
        return this.removeEntityById(ent.id);
    }

    /**
      getEntityById get a entity by id
    **/
    public function getEntityById(id: Int): Entity {
        var existing = this.entities.get(id);
        return existing;
    }

    /**
      removeEntityById remove entity by id
    **/
    public function removeEntityById(id: Int): Entity {
        var existing = this.entities.get(id);
        if (existing == null) {
            return existing;
        }
        this.entities.remove(id);
        this.onEntityRemoved(existing);
        return existing;
    }

    /**
      update is the main function called by the world.
    **/
    public function update(dt: Float) {
    }

    function onEntityAdded(ent: Entity) {}
    function onEntityRemoved(ent: Entity) {}
}
