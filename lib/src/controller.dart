import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CurvedAnimationController<T> extends Listenable 
  implements ValueListenable<T> {

  /// The value this variable has at the beginning of the animation.
  T begin;
  
  /// The value this variable has at the end of the animation.
  T end;

  /// The length of time this animation should last.
  ///
  /// If [reverseDuration] is specified, then [duration] is only used when going
  /// [forward]. Otherwise, it specifies the duration going in both directions.
  final Duration duration;

  /// The length of time this animation should last when going in [reverse].
  ///
  /// The value of [duration] us used if [reverseDuration] is not specified or
  /// set to null.
  final Duration reverseDuration;
  
  /// Curve for when the animation goes ahead
  final Curve curve;

  /// Curve when the animation goes back
  final Curve reverseCurve;

  final TickerProvider vsync;

  /// A label that is used in the [toString] output. Intended to aid with
  /// identifying animation controller instances in debug output.
  final String debugLabel;

  /// The behavior of the controller when [AccessibilityFeatures.disableAnimations]
  /// is true.
  ///
  /// Defaults to [AnimationBehavior.normal].
  AnimationBehavior animationBehavior;

  Tween _tween;
  TweenSequence _tweenSequence;

  AnimationController _controller;
  Animation _animation;

  CurvedAnimationController({
    this.begin,
    this.end,
    this.curve, 
    this.duration,
    this.reverseCurve,
    this.reverseDuration,
    this.debugLabel,
    this.animationBehavior,
    this.vsync,
  }) {
    _tween = Tween(begin: begin ?? 0.0, end: end ?? 1.0);
    _controller = AnimationController(
      vsync: vsync, 
      animationBehavior: animationBehavior,
      debugLabel: debugLabel,
      reverseDuration: reverseDuration,
      duration: duration,
    );
    
    _animation = _tween.animate(CurvedAnimation(
      parent: _controller, 
      curve: curve,
      reverseCurve: reverseCurve,
    ));
  }

  CurvedAnimationController.sequence(List<SequenceItem> sequence, this.duration, {
    this.curve = Curves.linear, 
    this.reverseCurve = Curves.linear, 
    this.reverseDuration,
    this.debugLabel,
    this.animationBehavior,
    this.vsync,
  }) {
    _tweenSequence = TweenSequence(sequence.map((item) => TweenSequenceItem(
        tween: Tween(begin: item.begin, end: item.end), 
        weight: item.weight,
      )
    ).toList());

    _controller = AnimationController(
      vsync: vsync, 
      animationBehavior: animationBehavior,
      debugLabel: debugLabel,
      reverseDuration: reverseDuration,
      duration: duration,
    );
    
    _animation = _tweenSequence.animate(CurvedAnimation(
      parent: _controller, 
      curve: curve, 
      reverseCurve: reverseCurve,
    ));
  }

  CurvedAnimationController.tween(Tween tween, this.duration, {
    this.curve, 
    this.reverseCurve, 
    this.reverseDuration,
    this.debugLabel,
    this.animationBehavior,
    this.vsync,
  }) {
    _tween = tween;

    _controller = AnimationController(
      vsync: vsync, 
      debugLabel: debugLabel,
      animationBehavior: animationBehavior,
      reverseDuration: reverseDuration,
      duration: duration,
    );

    _animation = _tween.animate(CurvedAnimation(
      parent: _controller, 
      curve: curve, 
      reverseCurve: reverseCurve,
    ));
  }

  CurvedAnimationController.tweenSequence(TweenSequence sequence, this.duration, {
    this.curve, 
    this.reverseCurve, 
    this.debugLabel,
    this.animationBehavior,
    this.reverseDuration,
    this.vsync,
  }) {
    _tweenSequence = sequence;

    _controller = AnimationController(
      vsync: vsync, 
      debugLabel: debugLabel,
      animationBehavior: animationBehavior,
      reverseDuration: reverseDuration,
      duration: duration,
    );

    _animation = _tweenSequence.animate(CurvedAnimation(
      parent: _controller, 
      curve: curve, 
      reverseCurve: reverseCurve,
    ));
  }

  /// AnimationController for this animation
  AnimationController get controller => _controller;

  /// Animation that hold value for this animation
  Animation get animation => _animation;

  /// The current value of the animation.
  @override
  T get value => _animation?.value;

  /// The current progress of the animation.
  double get progress => _controller?.value ?? 0.0;

  set progress(double value) {
    _controller.value = value;
  }

  /// The rate of change of [value] per second.
  ///
  /// If [isAnimating] is false, then [value] is not changing and the rate of
  /// change is zero.
  double get velocity => _controller?.velocity ?? 0;

  /// Whether this animation is currently animating in either the forward or reverse direction.
  ///
  /// This is separate from whether it is actively ticking. An animation
  /// controller's ticker might get muted, in which case the animation
  /// controller's callbacks will no longer fire even though time is continuing
  /// to pass. See [Ticker.muted] and [TickerMode].
  bool get isAnimating => _controller?.isAnimating ?? false;

  /// Whether this animation is stopped at the end.
  bool get isCompleted => _controller?.isCompleted ?? false;

  /// Whether this animation is stopped at the beginning.
  bool get isDismissed => _controller?.isDismissed ?? false;

  /// The amount of time that has passed between the time the animation started
  /// and the most recent tick of the animation.
  ///
  /// If the controller is not animating, the last elapsed duration is null.
  Duration get lastElapsedDuration => _controller?.lastElapsedDuration;

  AnimationStatus get status => _controller?.status;

  /// Starts running this animation forwards (towards the end).
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// During the animation, [status] is reported as [AnimationStatus.forward],
  /// which switches to [AnimationStatus.completed] when [upperBound] is
  /// reached at the end of the animation.
  TickerFuture forward({double from}) {
    return _controller.forward(from: from);
  }

  /// alias of [forward]
  TickerFuture start({double from}) {
    return forward(from: from);
  }

  /// Starts running this animation in reverse (towards the beginning).
  ///
  /// Returns a [TickerFuture] that completes when the animation is dismissed.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// During the animation, [status] is reported as [AnimationStatus.reverse],
  /// which switches to [AnimationStatus.dismissed] when [lowerBound] is
  /// reached at the end of the animation.
  TickerFuture reverse({double from}) {
    return _controller?.reverse(from: from);
  }

  /// Drives the animation from its current value to target.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// During the animation, [status] is reported as [AnimationStatus.forward]
  /// regardless of whether `target` > [value] or not. At the end of the
  /// animation, when `target` is reached, [status] is reported as
  /// [AnimationStatus.completed].
  TickerFuture animateTo(double target, { Duration duration, Curve curve = Curves.linear }) {
    return _controller?.animateTo(target, duration: duration, curve: curve);
  }

  /// Drives the animation from its current value to target.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// During the animation, [status] is reported as [AnimationStatus.reverse]
  /// regardless of whether `target` < [value] or not. At the end of the
  /// animation, when `target` is reached, [status] is reported as
  /// [AnimationStatus.dismissed].
  TickerFuture animateBack(double target, { Duration duration, Curve curve = Curves.linear }) {
    return _controller?.animateBack(target, duration: duration, curve: curve);
  }

  /// Starts running this animation in the forward direction, and
  /// restarts the animation when it completes.
  ///
  /// Defaults to repeating between the [lowerBound] and [upperBound] of the
  /// [AnimationController] when no explicit value is set for [min] and [max].
  ///
  /// With [reverse] set to true, instead of always starting over at [min]
  /// the starting value will alternate between [min] and [max] values on each
  /// repeat. The [status] will be reported as [AnimationStatus.reverse] when
  /// the animation runs from [max] to [min].
  ///
  /// Each run of the animation will have a duration of `period`. If `period` is not
  /// provided, [duration] will be used instead, which has to be set before [repeat] is
  /// called either in the constructor or later by using the [duration] setter.
  ///
  /// Returns a [TickerFuture] that never completes. The [TickerFuture.orCancel] future
  /// completes with an error when the animation is stopped (e.g. with [stop]).
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture repeat({ double min, double max, bool reverse = false, Duration period }) {
    return _controller.repeat(min: min, max: max, reverse: reverse, period: period);
  }

  /// Drives the animation with a critically damped spring (within [lowerBound]
  /// and [upperBound]) and initial velocity.
  ///
  /// If velocity is positive, the animation will complete, otherwise it will
  /// dismiss.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture fling({ double velocity = 1.0, AnimationBehavior animationBehavior }) {
    return _controller?.fling(velocity: velocity, animationBehavior: animationBehavior);
  }

  /// Drives the animation according to the given simulation.
  ///
  /// The values from the simulation are clamped to the [lowerBound] and
  /// [upperBound]. To avoid this, consider creating the [AnimationController]
  /// using the [new AnimationController.unbounded] constructor.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// The [status] is always [AnimationStatus.forward] for the entire duration
  /// of the simulation.
  TickerFuture animateWith(Simulation simulation) {
    return _controller?.animateWith(simulation);
  }

  /// Sets the controller's value to [begin], stopping the animation (if
  /// in progress), and resetting to its beginning point, or dismissed state.
  /// 
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// See also:
  ///
  ///  * [value], which can be explicitly set to a specific value as desired.
  ///  * [forward], [start], which starts the animation in the forward direction.
  ///  * [stop], which aborts the animation without changing its value or status
  ///    and without dispatching any notifications other than completing or
  ///    canceling the [TickerFuture].
  void reset() {
    _controller?.reset();
  }

  /// Stops running this animation.
  ///
  /// This does not trigger any notifications. The animation stops in its
  /// current state.
  ///
  /// By default, the most recently returned [TickerFuture] is marked as having
  /// been canceled, meaning the future never completes and its
  /// [TickerFuture.orCancel] derivative future completes with a [TickerCanceled]
  /// error. By passing the `canceled` argument with the value false, this is
  /// reversed, and the futures complete successfully.
  ///
  /// See also:
  ///
  ///  * [reset], which stops the animation and resets it to the [lowerBound],
  ///    and which does send notifications.
  ///  * [start], [forward], [reverse], [animateTo], [animateWith], [fling], and [repeat],
  ///    which restart the animation controller.
  void stop({ bool canceled = true }) {
    _controller?.stop(canceled: canceled);
  }

  /// Calls listener every time the status of the animation changes.
  ///
  /// Listeners can be removed with [removeStatusListener].
  void addStatusListener(AnimationStatusListener listener) {
    _controller?.addStatusListener(listener);
  }

  /// Stops calling the listener every time the status of the animation changes.
  ///
  /// Listeners can be added with [addStatusListener].
  void removeStatusListener(AnimationStatusListener listener) {
    _controller?.removeStatusListener(listener);
  }

  /// Calls the listener every time the value of the animation changes.
  ///
  /// Listeners can be removed with [removeListener].
  @override
  void addListener(Function listener) {
    _controller?.addListener(listener);
  }
  
  /// Stop calling the listener every time the value of the animation changes.
  ///
  /// Listeners can be added with [addListener].
  @override
  void removeListener(Function listener) {
    _controller?.removeListener(listener);
  }

  /// Calls all the listeners.
  ///
  /// If listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void notifyListeners() {
    _controller?.notifyListeners();
  }

  /// Release the resources used by this object. The object is no longer usable
  /// after this method is called.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  void dispose() {
    _controller?.dispose();
  }
}

class SequenceItem {
  final begin;
  final end;
  final weight;

  SequenceItem(this.begin, this.end, {this.weight = 1.0});
}