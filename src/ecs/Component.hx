
package ecs;

class Component {

    /**
      The type string of the component
      This is only set on constructor

      This is used by entity when adding component.
      If name of component is not provided, this will be used as the default name
      when adding the component.
    **/
    public var type(get, null): String;

    // this only initialise when it is being used.
    var listeners: Map<Int, (String, Component) -> Void>;
    var listenerCounter: Int = 0;

    public function new() {
    }

    public function addListener(func: (String, Component) -> Void): Int {
        if (this.listenerCounter == 0) {
            this.listeners = new Map<Int, (String, Component) -> Void>();
        }
        var counter = this.listenerCounter++;
        this.listeners[counter] = func;
        return counter;
    }

    public function removeListener(id: Int) {
        this.listeners.remove(id);
    }

    function changed() {
        if (this.listeners != null) {
            for (k => v in this.listeners) {
                v(this.type, this);
            }
        }
    }

    public function get_type(): String {
        return "undefined";
    }

}
