library curved_animation_controller;

import 'package:flutter/material.dart';

class CurvedAnimationController<T extends dynamic> {  
  CurvedAnimationController({
    @required TickerProvider vsync,
    double value,
    this.duration,
    this.reverseDuration,
    this.debugLabel,
    this.begin,
    this.end,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.animationBehavior = AnimationBehavior.normal,
    this.curve=Curves.linear,
  }) {
    this._vsync = vsync;
    this._controllerValue = value;
    init();
  }

  TickerProvider _vsync;
  double _controllerValue;

  AnimationController _controller;
  Animation _animation;
  
  /// AnimationController for this animation
  AnimationController get controller => _controller;

  /// Animation that hold value for this animation
  Animation get animation => _animation;
  
  /// The value this variable has at the beginning of the animation.
  ///
  /// See the constructor for details about whether this property may be null
  /// (it varies from subclass to subclass).
  final T begin;

  /// The value this variable has at the end of the animation.
  ///
  /// See the constructor for details about whether this property may be null
  /// (it varies from subclass to subclass).
  final T end;

  /// The value at which this animation is deemed to be dismissed.
  final double lowerBound;

  /// The value at which this animation is deemed to be completed.
  final double upperBound;

  /// A label that is used in the [toString] output. Intended to aid with
  /// identifying animation controller instances in debug output.
  final String debugLabel;

  /// The behavior of the controller when [AccessibilityFeatures.disableAnimations]
  /// is true.
  ///
  /// Defaults to [AnimationBehavior.normal] for the [new AnimationController]
  /// constructor, and [AnimationBehavior.preserve] for the
  /// [new AnimationController.unbounded] constructor.
  AnimationBehavior animationBehavior;

  /// The length of time this animation should last.
  ///
  /// If [reverseDuration] is specified, then [duration] is only used when going
  /// [forward]. Otherwise, it specifies the duration going in both directions.
  Duration duration;

  /// The length of time this animation should last when going in [reverse].
  ///
  /// The value of [duration] us used if [reverseDuration] is not specified or
  /// set to null.
  Duration reverseDuration;
  
  /// The curve to use in the forward direction.
  Curve curve;

  /// The current value of the animation.
  ///
  /// Setting this value notifies all the listeners that the value
  /// changed.
  ///
  /// Setting this value also stops the controller if it is currently
  /// running; if this happens, it also notifies all the status
  /// listeners.
  T get value => _animation?.value ?? (lowerBound is T ? lowerBound : null);

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

  /// The amount of time that has passed between the time the animation started
  /// and the most recent tick of the animation.
  ///
  /// If the controller is not animating, the last elapsed duration is null.
  Duration get lastElapsedDuration => _controller?.lastElapsedDuration;

  AnimationStatus get status => _controller?.status;

  void init() {
    _controller = AnimationController(
      vsync: _vsync, 
      duration: duration,
      reverseDuration: reverseDuration,
      animationBehavior: animationBehavior,
      debugLabel: debugLabel,
      upperBound: upperBound,
      lowerBound: lowerBound,
      value: _controllerValue,
    );

    _animation = Tween<T>(
      begin: begin ?? (lowerBound is T ? lowerBound : null), 
      end: end ?? (upperBound is T ? upperBound : null),
    ).animate(
      CurvedAnimation(parent: _controller, curve: curve)
    );
  }

  void setCurve(Curve newCurve) {
    this.curve = newCurve;
    init();
  }

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
    return _controller?.forward(from: from);
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

  /// Sets the controller's value to [lowerBound], stopping the animation (if
  /// in progress), and resetting to its beginning point, or dismissed state.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  ///
  /// See also:
  ///
  ///  * [value], which can be explicitly set to a specific value as desired.
  ///  * [forward], which starts the animation in the forward direction.
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
  ///  * [forward], [reverse], [animateTo], [animateWith], [fling], and [repeat],
  ///    which restart the animation controller.
  void stop({ bool canceled = true }) {
    _controller?.stop(canceled: canceled);
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

  /// Calls the listener every time the value of the animation changes.
  ///
  /// Listeners can be removed with [removeListener].
  void addListener(VoidCallback listener) {
    _controller?.addListener(listener);
  }

  /// Stop calling the listener every time the value of the animation changes.
  ///
  /// Listeners can be added with [addListener].
  void removeListener(VoidCallback listener) {
    _controller?.removeListener(listener);
  }

  /// Calls all the listeners.
  ///
  /// If listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void notifyListeners() {
    _controller?.notifyListeners();
  }
}