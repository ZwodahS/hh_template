package ecs;

import ecs.*;

interface EntityAwareComponent {

    /**
      Notify the component that it has been added to an entity.
    **/
    public function onComponentAdded(ent: Entity): Void;
    /**
      Notify the component that it has been removed from an entity.
    **/
    public function onComponentRemoved(ent: Entity): Void;
}
