# CurvedAnimationController

An easy way to use AnimationController with Curve.

![](demo.mp4)

## Getting Started

You should ensure that you add the controller as a dependency in your flutter project.

```yaml
dependencies:
  curved_animation_controller: ^0.0.4
```

You can also reference the git repo directly if you want:
```yaml
dependencies:
  curved_animation_controller:
    git: git://github.com/salkuadrat/curved_animation_controller.git
```

You should then run `flutter packages upgrade` or update your packages in IntelliJ.

## Example Project

There is a pretty sweet example project in the `example` folder. Check it out. Otherwise, keep reading to get up and running.

## Using

Here is a snippet of code we usually use when we want to do some animation with curve.

```
AnimationController _controller = AnimationController(
  vsync: this, 
  duration: Duration(milliseconds: 300),
);

Animation _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
  parent: _controller, curve: Curves.easeInOut,
));

_controller.addListener(() => setState(() {}));

...

// start animation
_animation.forward();

...

// apply animation
Opacity(
  opacity: _animation.value,
  child: child,
)
```

Using CurvedAnimationController, we can apply animation with a more straightforward code:

```
CurvedAnimationController _animation = CurvedAnimationController(
  vsync: this, duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);

_animation.addListener(() => setState(() {}));

...

// start animation
_animation.start();

...

// apply animation
Opacity(
  opacity: _animation.value,
  child: child,
)
```

We can also use custom Tween:

```
CurvedAnimationController<Color> _animation = CurvedAnimationController<Color>.tween(
  ColorTween(begin: Colors.pink, end: Colors.teal),
  Duration(milliseconds: 300),
  curve: Curves.easeInCubic,
  vsync: this,
);

_animation.addListener(() => setState(() {}));

...

// start animation
_animation.forward();

...

// apply animation
Container(
  color: _animation.value,
  child: child,
)
```

Don't forget to dispose the controller properly:

```
@override
void dispose() {
  _animation.dispose();
  super.dispose();
}
```

## Available Constructors

```
CurvedAnimationController(
  begin: begin,
  end: end,
  vsync: vsync,
  curve: curve,
  duration: duration,
  reverseCurve: reverseCurve,
  reverseDuration: reverseDuration,
  animationBehavior: animationBehavior,
  debugLabel: debugLabel,
);
```

```
CurvedAnimationController.tween(
  tween, // ex: ColorTween(begin: Colors.pink, end: Colors.teal)
  duration,
  vsync: vsync,
  curve: curve,
  reverseCurve: reverseCurve,
  reverseDuration: reverseDuration,
  animationBehavior: animationBehavior,
  debugLabel: debugLabel,
);
```

```
CurvedAnimationController.sequence(
  sequence, // list of sequence (List<SequenceItem>)
  duration,
  vsync: vsync,
  curve: curve,
  reverseCurve: reverseCurve,
  reverseDuration: reverseDuration,
  animationBehavior: animationBehavior,
  debugLabel: debugLabel,
);
```

```
CurvedAnimationController.tweenSequence(
  sequence, // TweenSequence
  duration,
  vsync: vsync,
  curve: curve,
  reverseCurve: reverseCurve,
  reverseDuration: reverseDuration,
  animationBehavior: animationBehavior,
  debugLabel: debugLabel,
);
```

## Available Methods

Start animation:
```
start()
```

or :
```
forward()
```

Start animation in reverse direction:
```
reverse()
```

Stop animation:
```
stop()
```

Start animation with fling effect:
```
fling()
```

Animate to specific target value:
```
animateTo()
```

Animate back to specific target value:
```
animateBack()
```

Reset animation:
```
reset()
```

Dispose animation controller:
```
dispose()
```

Add animation listener:
```
addListener()
```

Remove animation listener:
```
removeListener()
```

Add AnimationState listener:
```
addStateListener()
```

Remove AnimationState listener:
```
removeStateListener()
```

Notify all listeners:
```
notifyListeners()
```