package ecs;

import ecs.Space.SpaceComponent;

/**
  GridComponent provide a simple grid / discrete position system that maps to a space component.

**/

/**
    note: it is possible that we can just set the position of the render component.
    However, if that is the case, the render component position will be quite rigid.
    The way we can think about this is that

    SpaceComponent
**/


class GridComponent extends Component {
    public static final TYPE_STRING = "GridComponent";

    public var x(default, set): Int;
    public var y(default, set): Int;

    var listenerId: Int;

    public function new(x: Int = 0, y: Int = 0) {
        super();
        this.x = x;
        this.y = y;
    }

    public function set_x(x: Int): Int {
        this.x = x;
        this.changed();
        return this.x;
    }

    public function set_y(y: Int): Int {
        this.y = y;
        this.changed();
        return this.y;
    }

    public function get_xy(): Array<Int> {
        return [this.x, this.y];
    }

    public function set_xy(xy: Array<Int>): Array<Int> {
        this.x = xy[0];
        this.y = xy[1];
        this.changed();
        return [this.x, this.y];
    }

    override function get_type(): String {
        return GridComponent.TYPE_STRING;
    }
}
