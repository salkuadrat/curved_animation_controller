import 'dart:math';

import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:example/shared.dart';
import 'package:flutter/material.dart';

class FlipDrawer extends StatefulWidget {

  final String title;
  final Widget drawer;
  final Widget child;

  const FlipDrawer({Key key, this.title, this.drawer, this.child}) : super(key: key);

  static _FlipDrawerState of(BuildContext context) =>
    context.findAncestorStateOfType<_FlipDrawerState>();
  
  @override
  _FlipDrawerState createState() => _FlipDrawerState();
}

class _FlipDrawerState extends State<FlipDrawer> 
  with TickerProviderStateMixin {

  final double _offsetFromRight = 60.0;
  bool _canBeDragged = false;

  CurvedAnimationController _animation;
  CurvedAnimationController _menuAnimation;

  double get _maxSlide => MediaQuery.of(context).size.width - _offsetFromRight;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    _menuAnimation.dispose();
    super.dispose();
  }

  _initAnimation() {
    _animation = CurvedAnimationController(
      vsync: this, duration: Duration(milliseconds: 250),
      curve: curve, // curve value from shared.dart
    );

    _menuAnimation = CurvedAnimationController(
      vsync: this, duration: Duration(milliseconds: 250),
      curve: curve,
    );
    
    _animation.addListener(() => setState(() {}));
    _menuAnimation.addListener(() => setState(() {}));
  }

  reset() {
    _initAnimation();
  }

  open() {
    _animation?.start();
    _menuAnimation?.start();
  }
  close() {
    _animation?.reverse();
    _menuAnimation?.reverse();
  }

  toggle() => _animation.isDismissed ? open() : close();

  _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animation.isDismissed;
    bool isDragCloseFromRight = _animation.isCompleted;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if(_canBeDragged) {
      double delta = details.primaryDelta / _maxSlide;
      _animation.progress += delta;
      _menuAnimation.progress += delta;
    }
  }

  _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (_animation.isDismissed || _animation.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = 
        details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      _animation?.fling(velocity: visualVelocity);
      _menuAnimation?.fling(velocity: visualVelocity);

    } else if (_animation.progress < 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animation.isCompleted) {
          close();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        onTap: toggle,
        child: Material(
          color: Colors.teal[500],
          child: Stack(
            children: <Widget>[
              Transform(
                transform: Matrix4.identity()
                  ..translate(_maxSlide * (_animation.value - 1), 0.0),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(pi / 2 * (1 - _animation.value)),
                  alignment: Alignment.centerRight,
                  child: widget.drawer,
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(_maxSlide * _animation.value, 0.0),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(-pi * _animation.value / 2),
                  alignment: Alignment.centerLeft,
                  child: widget.child,
                ),
              ),
              Positioned(
                top: 16.0 + MediaQuery.of(context).padding.top,
                left: _animation.value * MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.title,
                  style: Theme.of(context).primaryTextTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 4.0 + MediaQuery.of(context).padding.top,
                left: 4.0 + _animation.value * _maxSlide,
                child: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    color: Colors.white, 
                    progress: _menuAnimation.controller,
                  ),
                  onPressed: toggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}