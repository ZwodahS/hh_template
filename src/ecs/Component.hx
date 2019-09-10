
package ecs;

class Component {

    /**
      The type string of the component
      This is only set on constructor

      This is used by entity when adding component.
      If name of component is not provided, this will be used as the default name
      when adding the component.
    **/
    public var type(default, null): String;

    public function new(type: String) {
        this.type = type;
    }
}
