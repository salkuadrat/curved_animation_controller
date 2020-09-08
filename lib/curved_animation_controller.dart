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
  
  final T begin;
  final T end;
  final double lowerBound;
  final double upperBound;
  final String debugLabel;
  AnimationBehavior animationBehavior;
  Duration reverseDuration;
  Duration duration;
  Curve curve;

  TickerProvider _vsync;
  double _controllerValue;

  AnimationController _controller;
  Animation _animation;
  
  AnimationController get controller => _controller;
  Animation get animation => _animation;

  T get value => _animation?.value ?? (lowerBound is T ? lowerBound : null);
  double get velocity => _controller?.velocity ?? 0;
  bool get isAnimating => _controller?.isAnimating ?? false;
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

  TickerFuture forward({double from}) {
    return _controller?.forward(from: from);
  }

  TickerFuture reverse({double from}) {
    return _controller?.reverse(from: from);
  }

  TickerFuture animateTo(double target, { Duration duration, Curve curve = Curves.linear }) {
    return _controller?.animateTo(target, duration: duration, curve: curve);
  }

  TickerFuture animateBack(double target, { Duration duration, Curve curve = Curves.linear }) {
    return _controller?.animateBack(target, duration: duration, curve: curve);
  }

  TickerFuture repeat({ double min, double max, bool reverse = false, Duration period }) {
    return _controller.repeat(min: min, max: max, reverse: reverse, period: period);
  }

  TickerFuture fling({ double velocity = 1.0, AnimationBehavior animationBehavior }) {
    return _controller?.fling(velocity: velocity, animationBehavior: animationBehavior);
  }

  TickerFuture animateWith(Simulation simulation) {
    return _controller?.animateWith(simulation);
  }

  void reset() {
    _controller?.reset();
  }

  void stop({ bool canceled = true }) {
    _controller?.stop(canceled: canceled);
  }

  void dispose() {
    _controller?.dispose();
  }

  void addListener(VoidCallback listener) {
    _controller?.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _controller?.removeListener(listener);
  }

  void notifyListeners() {
    _controller?.notifyListeners();
  }
}