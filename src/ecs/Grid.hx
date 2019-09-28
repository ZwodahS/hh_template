package ecs;

import ecs.Space.SpaceComponent;

/**
  GridComponent provide a simple grid / discrete position system that maps to a space component.

**/

class GridComponent extends Component {
    public static final TYPE_STRING = "GridComponent";

    public var x(default, set): Int;
    public var y(default, set): Int;
    public var z(default, set): Int;

    public var xy(get, set): Array<Int>;
    public var xyz(get, set): Array<Int>;

    public function new(x: Int = 0, y: Int = 0, z: Int = 0) {
        super();
        this.x = x;
        this.y = y;
        this.z = z;
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

    public function set_z(z: Int): Int {
        this.z = z;
        this.changed();
        return this.z;
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

    public function get_xyz(): Array<Int> {
        return [this.x, this.y, this.z];
    }

    public function set_xyz(xyz: Array<Int>): Array<Int> {
        this.x = xyz[0];
        this.y = xyz[1];
        this.z = xyz[2];
        this.changed();
        return [this.x, this.y, this.z];
    }

    override function get_type(): String {
        return GridComponent.TYPE_STRING;
    }
}
