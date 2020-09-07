library curved_animation_controller;

import 'package:flutter/material.dart';

class CurvedAnimationController {
  CurvedAnimationController({this.vsync, this.duration, this.curve}) {
    init();
  }

  final TickerProvider vsync;
  final Duration duration;
  final Curve curve;
  
  AnimationController _controller;
  Animation _animation;

  AnimationController get controller => _controller;
  Animation get animation => _animation;
  double get value => _animation?.value ?? 0.0;

  void init() {
    _controller = AnimationController(vsync: vsync, duration: duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: curve));
  }

  void dispose() {
    _controller?.dispose();
  }

  void addListener(listener) {
    _controller.addListener(listener);
  }

  void forward() {
    _controller?.forward();
  }

  void reverse() {
    _controller?.reverse();
  }
}