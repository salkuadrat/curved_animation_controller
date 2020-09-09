import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:example/shared.dart';
import 'package:flutter/material.dart';

class SlideDrawer extends StatefulWidget {
  final Widget drawer;
  final Widget child;

  const SlideDrawer({Key key, this.drawer, this.child}) : super(key: key);

  static _SlideDrawerState of(BuildContext context) =>
    context.findAncestorStateOfType<_SlideDrawerState>();
  
  @override
  _SlideDrawerState createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> 
  with SingleTickerProviderStateMixin {

  static const double _maxSlide = 220;
  static const double _minDragStartEdge = 60;
  static const double _maxDragStartEdge = _maxSlide - 16;
  bool _canBeDragged = false;

  CurvedAnimationController _animation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
  
  _initAnimation() {
    _animation = CurvedAnimationController(
      vsync: this, duration: Duration(milliseconds: 300),
      curve: curve, // curve value from shared.dart
    );

    _animation.addListener(() => setState(() {}));
  }

  reset() => _initAnimation();
  open() => _animation.start();
  close() => _animation.reverse();
  toggle() => _animation.isCompleted ? close() : open();

  _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = 
      _animation.isDismissed && 
      details.globalPosition.dx < _minDragStartEdge;
    
    bool isDragCloseFromRight = 
      _animation.isCompleted && 
      details.globalPosition.dx > _maxDragStartEdge;
    
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / _maxSlide;
      _animation.progress += delta;
    }
  }

  _onDragEnd(DragEndDetails details) {
    // I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animation.isDismissed || _animation.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = 
        details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      _animation.fling(velocity: visualVelocity);

    } else if (_animation.value < 0.5) {
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
        child: Stack(
          children: [
            widget.drawer,
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(_maxSlide * _animation.value)
                ..scale(1.0 - (0.25 * _animation.value)),
              child: GestureDetector(
                onTap: _animation.isCompleted ? close : null,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}