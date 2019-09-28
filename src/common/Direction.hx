
package common;

enum Direction {
    Left;
    UpLeft;
    Up;
    UpRight;
    Right;
    DownRight;
    Down;
    DownLeft;
}

class Utils {
    public static function directionToCoord(direction: Direction): Coord {
        switch(direction) {
            case Left:
                return new Coord(-1, 0);
            case UpLeft:
                return new Coord(-1, -1);
            case Up:
                return new Coord(0, -1);
            case UpRight:
                return new Coord(1, -1);
            case Right:
                return new Coord(1, 0);
            case DownRight:
                return new Coord(1, 1);
            case Down:
                return new Coord(0, 1);
            case DownLeft:
                return new Coord(-1, 1);
            default:
                return new Coord();
        }
    }
}
