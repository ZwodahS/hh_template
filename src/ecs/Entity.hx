package ecs;

import ecs.Component;
import ecs.EntityAwareComponent;

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

    private function new(id: Int) {
        this.id = id;
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
        }

        this.components[name] = component;
        if (Std.is(component, EntityAwareComponent)) {
            cast(component, EntityAwareComponent).onComponentAdded(this);
        }

        // TODO: dispatch events
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
        }

        this.components.remove(name);
    }

    private static var counter:Int = 0;
    public static function newEntity(): Entity {
        return new Entity(counter++);
    }
}
