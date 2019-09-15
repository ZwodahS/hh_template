package ecs;

import ecs.*;

/**
**/
class SpaceComponent extends Component {

    public static final TYPE_STRING = "ecs.Space.SpaceComponent";

    public var x(default, set): Float;
    public var y(default, set): Float;
    public var z(default, set): Float;
    public var xy(get, set): Array<Float>;
    public var xyz(get, set): Array<Float>;

    public function new(x: Float = 0, y: Float = 0, z: Float = 0) {
        super();
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function set_x(x: Float): Float {
        this.x = x;
        this.changed();
        return this.x;
    }

    public function set_y(y: Float): Float {
        this.y = y;
        this.changed();
        return this.y;
    }

    public function set_z(z: Float): Float {
        this.z = z;
        this.changed();
        return this.z;
    }

    public function get_xy(): Array<Float> {
        return [this.x, this.y];
    }

    public function get_xyz(): Array<Float> {
        return [this.x, this.y, this.z];
    }

    public function set_xy(xy: Array<Float>): Array<Float> {
        this.x = xy[0];
        this.y = xy[1];
        this.changed();
        return [this.x, this.y];
    }

    public function set_xyz(xyz: Array<Float>): Array<Float> {
        this.x = xyz[0];
        this.y = xyz[1];
        this.z = xyz[2];
        this.changed();
        return [this.x, this.y, this.z];
    }

    public function add(rhs: Array<Float>): SpaceComponent{
        this.x += rhs[0];
        this.y += rhs[1];
        // if rhs contains only 2 items (using x and y only) then we don't update z
        if (rhs.length > 2) {
            this.z += rhs[2];
        }
        this.changed();
        return this;
    }

    override public function get_type(): String {
        return SpaceComponent.TYPE_STRING;
    }
}
