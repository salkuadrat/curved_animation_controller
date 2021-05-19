# CurvedAnimationController

An easy way to use AnimationController with Curve.

![](example.gif)

## Getting Started

Add dependency in your flutter project.

```
$ flutter pub add curved_animation_controller
```

or

```yaml
dependencies:
  curved_animation_controller: ^1.1.0+1
```

or

```yaml
dependencies:
  curved_animation_controller:
    git: https://github.com/salkuadrat/curved_animation_controller.git
```

Then run `flutter pub get`.

## Example

There is a nice example project in the [example folder](example). 
Check it out to learn how to use Curved Animation Controller.

## Usage

Here is a snippet of code we usually use when we want to do some animation with curve.

```dart
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

```dart
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

```dart
@override
void dispose() {
  _animation.dispose();
  super.dispose();
}
```

## Available Constructors

```dart
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

```dart
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

```dart
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

```dart
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

```dart
start()
```

or :

```dart
forward()
```

Start animation in reverse direction:

```dart
reverse()
```

Stop animation:

```dart
stop()
```

Start animation with fling effect:

```dart
fling()
```

Animate to specific target value:

```dart
animateTo()
```

Animate back to specific target value:

```dart
animateBack()
```

Reset animation:

```dart
reset()
```

Dispose animation controller:

```dart
dispose()
```

Add animation listener:

```dart
addListener()
```

Remove animation listener:

```dart
removeListener()
```

Add AnimationState listener:

```dart
addStateListener()
```

Remove AnimationState listener:

```dart
removeStateListener()
```

Notify all listeners:

```dart
notifyListeners()
```