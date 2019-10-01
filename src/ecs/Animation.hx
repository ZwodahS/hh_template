package ecs;

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

interface Animation {
    public function update(dt: Float): Bool;
}

private class WrappedAnimation implements Animation{

    var _update: (Float) -> Bool;
    public function new(update: (Float) -> Bool) {
        this._update = update;
    }

    public function update(dt: Float): Bool {
        return this._update(dt);
    }
}

private class InternalAnimation {

    public var entered: Bool = false;
    var animation: Animation;
    var _onStart: () -> Void;
    var _onDone: () -> Void;

    public function new(animation: Animation, onStart: () -> Void = null, onDone: () -> Void = null) {
        this.animation = animation;
        this._onStart = onStart;
        this._onDone = onDone;
    }

    public function update(dt: Float): Bool {
        return this.animation.update(dt);
    }

    public function onStart() {
        if (this._onStart != null) {
            this._onStart();
        }
    }

    public function onDone() {
        if (this._onDone != null) {
            this._onDone();
        }
    }
}

class DelayAnimation implements Animation {

    var timeLeft: Float = 0;

    public function new(delay: Float) {
        this.timeLeft = delay;
    }

    public function update(dt: Float): Bool {
        return (timeLeft -= dt) <= 0;
    }
}

class MoveAnimation implements Animation {

    var endCoord: Array<Float>;
    var updateCoord: Array<Float>;
    var timeLeft: Float;
    var spaceComponent: ecs.Space.SpaceComponent;

    public function new(spaceComponent: ecs.Space.SpaceComponent, start: Array<Float>, end: Array<Float>, delta: Float) {
        this.endCoord = end;
        this.spaceComponent = spaceComponent;
        this.updateCoord = [
            (end[0] - start[0]) / delta,
            (end[1] - start[1]) / delta,
            (end[2] - start[2]) / delta
        ];
        this.timeLeft = delta;
    }

    public function update(dt: Float): Bool {
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

    var animations: List<InternalAnimation>;

    public function new() {
        super("ecs.Animation.AnimationSystem");
        this.animations = new List<InternalAnimation>();
    }

    override public function init(world: World, mailbox: Mailbox) {
        super.init(world, mailbox);

        this.mailbox.listen(AnimationMessage.TYPE_STRING, function(message: Message) {
            var animationMessage = cast(message, AnimationMessage);
            var animation = animationMessage.animation;
            if (animation == null) {
                animation = new WrappedAnimation(animationMessage.update);
            }

            this.animations.add(new InternalAnimation(animation, animationMessage.onStart, animationMessage.onDone));
        });
    }

    override public function update(dt: Float) {
        var toExit = new List<InternalAnimation>();
        for (anim in this.animations) {
            if (!anim.entered) {
                anim.onStart();
                if (anim.update(dt)) {
                    toExit.add(anim);
                }
            }
        }
        for (e in toExit) {
            this.animations.remove(e);
            e.onDone();
        }
    }

}

class AnimationMessage extends Message {
    public static final TYPE_STRING = "ecs.Animation.AnimationMessage";

    public var animation: Animation;
    public var update: (Float) -> Bool;
    public var onStart: () -> Void;
    public var onDone: () -> Void;

    public function new(
            animation: Animation = null,
            update: Float -> Bool = null,
            onStart: () -> Void = null,
            onDone: () -> Void = null
    ) {
        super();
        this.animation = animation;
        this.update = update;
        this.onStart = onStart;
        this.onDone = onDone;
    }

    public static function fromFunction(
                update: Float -> Bool, onStart: () -> Void = null, onDone: () -> Void = null) {
        return new AnimationMessage(null, update, onStart, onDone);
    }

    public static function fromAnimation(
                animation: Animation, onStart: () -> Void = null, onDone: () -> Void = null) {
        return new AnimationMessage(animation, null, onStart, onDone);
    }

    override public function get_type(): String {
        return AnimationMessage.TYPE_STRING;
    }
}
