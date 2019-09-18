package ecs;

import ecs.Message;
import ecs.Component;
import ecs.EntityAwareComponent;

class ComponentAddedEvent extends Message {

    public static final TYPE_STRING = "ecs.Entity.ComponentAddedEvent";

    public var entity(default, null): Entity;
    public var component(default, null): Component;

    public function new(entity: Entity, component: ecs.Component) {
        super();
        this.entity = entity;
        this.component = component;
    }

    override public function get_type(): String {
        return ComponentAddedEvent.TYPE_STRING;
    }

}

class ComponentRemovedEvent extends Message {

    public static final TYPE_STRING = "ecs.Entity.ComponentRemovedEvent";

    public var entity(default, null): Entity;
    public var component(default, null): Component;

    public function new(entity: Entity, component: ecs.Component) {
        super();
        this.entity = entity;
        this.component = component;
    }

    override public function get_type(): String {
        return ComponentRemovedEvent.TYPE_STRING;
    }

}

/**
  An entity of the world.
**/
class Entity {
    /**
      The id of the entity. This is only set on creation.
    **/
    public var id(default, null): Int;
    /**
      Store the list of components of the entity
    **/
    var components: Map<String, Component>;

    /**
      The mailbox used to communicate between systems
    **/
    public var mailbox(default, set): Mailbox;

    private function new(id: Int) {
        this.id = id;
        this.components = new Map<String, Component>();
    }
    /**
      setter for mailbox
    **/
    public function set_mailbox(mailbox: Mailbox): Mailbox {
        this.mailbox = mailbox;
        return this.mailbox;
    }

    /**
      hasComponent check if the entity has a component of this name
    **/
    public function hasComponent(name: String): Bool {
        return this.components.exists(name);
    }
    /**
      getComponent returns the component given a name
    **/
    public function getComponent(name: String): Component {
        return this.components.get(name);
    }
    /**
      addComponent adds a component to the entity.
    **/
    public function addComponent(component: Component, name: String = null) {
        if (name == null) {
            name = component.type;
        }

        var existing = this.getComponent(name);
        if (existing != null) {
            if (Std.is(existing, EntityAwareComponent)) {
                cast(existing, EntityAwareComponent).onComponentRemoved(this);
            }
            if (this.mailbox != null) {
                this.mailbox.dispatch(new ComponentRemovedEvent(this, existing));
            }
        }

        this.components[name] = component;
        if (Std.is(component, EntityAwareComponent)) {
            cast(component, EntityAwareComponent).onComponentAdded(this);
            if (this.mailbox != null) {
                this.mailbox.dispatch(new ComponentAddedEvent(this, component));
            }
        }

        // TODO: dispatch events
    }

    public function addComponents(components: Array<Component>) {
        for (component in components) {
            this.addComponent(component, component.type);
        }
    }
    /**
      removeComponent remove a component with the given name from the entity
    **/
    public function removeComponent(name: String) {
        var existing = this.getComponent(name);
        if (existing == null) {
            return;
        }

        if (Std.is(existing, EntityAwareComponent)) {
            cast(existing, EntityAwareComponent).onComponentRemoved(this);
            if (this.mailbox != null) {
                this.mailbox.dispatch(new ComponentRemovedEvent(this, existing));
            }
        }

        this.components.remove(name);
    }

    private static var counter:Int = 0;
    public static function newEntity(): Entity {
        return new Entity(counter++);
    }
}
