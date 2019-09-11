package ecs;

class Message {

    public var type(default, null): String;

    public function new(type: String) {
        this.type = type;
    }
}
