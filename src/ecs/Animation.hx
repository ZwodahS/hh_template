package ecs;

import common.Coord;
import ecs.Entity;
import ecs.Component;
import ecs.System;
import ecs.World;
import ecs.Mailbox;

/**
  Animation System does not care much about entity.

  Animation System provide 2 ways to animate

  1. Create an Animation class that extends Animation Object
  2. provide the 3 needed function for the animation, in particular the update function.
**/

/**
  Animation is root animation object
**/
class Animation {
    public var entered(default, set): Bool = false;
    /**
      main update function of animation.
      return true if this is the end of the animation, false otherwise.
    **/
    public function update(Float): Bool { return true; }
    public function onEnter(): Void {}
    public function onExit(): Void {}

    public function new() {
    }

    public function set_entered(b: Bool): Bool {
        // does not alow this to be set back to false once it has been set to true.
        if (!this.entered) {
            this.entered = b;
        }
        return this.entered;
    }
}

/**
  SimpleAnimation is the generic Animation object with the 3 function
**/
class SimpleAnimation extends Animation{

    var _update: (Float) -> Bool;
    var _onEnter: () -> Void;
    var _onExit: () -> Void;

    public function new(update: (Float) -> Bool, onEnter: () -> Void, onExit: () -> Void) {
        super();
        this._update = update;
        this._onEnter = onEnter;
        this._onExit = onExit;
    }

    override public function update(dt: Float): Bool {
        if (this._update != null) {
            return this._update(dt);
        }
        // if _update is not set, we will return true to end this animation
        return true;
    }

    override public function onEnter() {
        if (this._onEnter != null) {
            this._onEnter();
        }
    }

    override public function onExit() {
        if (this._onExit != null) {
            this._onExit();
        }
    }
}

class MoveAnimation extends Animation {

    var endCoord: Array<Float>;
    var updateCoord: Array<Float>;
    var timeLeft: Float;
    var spaceComponent: ecs.Space.SpaceComponent;

    public function new(spaceComponent: ecs.Space.SpaceComponent, start: Array<Float>, end: Array<Float>, delta: Float) {
        super();
        this.endCoord = end;
        this.spaceComponent = spaceComponent;
        this.updateCoord = [
            (end[0] - start[0]) / delta,
            (end[1] - start[1]) / delta,
            (end[2] - start[2]) / delta
        ];
        this.timeLeft = delta;
    }

    override public function update(dt: Float): Bool {
        this.timeLeft -= dt;
        if (this.timeLeft <= 0) {
            this.spaceComponent.xyz = this.endCoord;
            return true;
        } else {
            this.spaceComponent.add(this.updateCoord.map(function(v: Float) { return v * dt; }));
            return false;
        }
    }
}

class AnimationSystem extends System {

    var animations: List<Animation>;

    public function new() {
        super("ecs.Animation.AnimationSystem");
        this.animations = new List<Animation>();
    }

    override public function init(world: World, mailbox: Mailbox) {
        super.init(world, mailbox);

        this.mailbox.listen(AnimationMessage.TYPE_STRING, function(message: Message) {
            var animationMessage = cast(message, AnimationMessage);

            if (animationMessage.animation == null) {
                // if animation object is not provided, create the simple Animation object
                this.animations.add(new SimpleAnimation(
                    animationMessage.update,
                    animationMessage.onEnter,
                    animationMessage.onExit
                ));
            } else {
                // if the animation object is provided, then we will use the animation object
                this.animations.add(animationMessage.animation);
            }
        });
    }

    override public function update(dt: Float) {
        var toExit = new List<Animation>();
        for (anim in this.animations) {
            if (!anim.entered) {
                anim.onEnter();
                if (anim.update(dt)) {
                    toExit.add(anim);
                }
            }
        }
        for (e in toExit) {
            this.animations.remove(e);
            e.onExit();
        }
    }

}

class AnimationMessage extends Message {
    public static final TYPE_STRING = "ecs.Animation.AnimationMessage";

    public var animation: Animation;
    public var update: (Float) -> Bool;
    public var onEnter: () -> Void;
    public var onExit: () -> Void;

    public function new(
            animation: Animation = null,
            update: Float -> Bool = null,
            onEnter: () -> Void = null,
            onExit: () -> Void = null
    ) {
        super();
        this.animation = animation;
        this.update = update;
        this.onEnter = onEnter;
        this.onExit = onExit;
    }

    override public function get_type(): String {
        return AnimationMessage.TYPE_STRING;
    }
}
