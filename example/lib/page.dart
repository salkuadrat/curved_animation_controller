import 'dart:math';

import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:example/flip_drawer.dart';
import 'package:example/shared.dart';
import 'package:example/slide_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title=''}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with 
  TickerProviderStateMixin {

  late CurvedAnimationController _animation;
  late CurvedAnimationController<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    WidgetsBinding.instance!.addPostFrameCallback((_) { 
      _animate();
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _colorAnimation.dispose();
    super.dispose();
  }

  _initAnimation() {
    _animation = CurvedAnimationController(
      duration: Duration(milliseconds: 500), 
      curve: curve!,
      vsync: this,
    );

    _colorAnimation = CurvedAnimationController<Color>.tween(
      ColorTween(begin: Colors.pink, end: Colors.teal),
      Duration(milliseconds: 750),
      curve: curve!,
      vsync: this,
    );

    _animation.addListener(() { 
      setState(() {});
    });

    _colorAnimation.addListener(() { 
      setState(() {});
    });
  }

  _animate() {
    _animation.repeat(reverse: true);
    _colorAnimation.repeat(reverse: true);
  }

  Widget get _animatedOpacity => Opacity(
    opacity: _animation.value,
    child: Container(width: 100, height: 100, color: Colors.teal),
  );

  Widget get _animatedColor => Container(
    width: 100, height: 100, 
    decoration: BoxDecoration(
      color: _colorAnimation.value,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  Widget get _animatedContainer => Container(
    width: 200 - (_animation.value * 50) as double?,
    height: 100 + (_animation.value * 100) as double?,
    decoration: BoxDecoration(
      color: Colors.teal,
      borderRadius: BorderRadius.all(
        Radius.circular(_animation.value * 24)
      ),
    ),
  );

  Widget get _animatedTransform => Opacity(
    opacity: 0.8 + (_animation.value * 0.2),
    child: Transform(
      alignment: Alignment.topCenter,
      child: Container(
        width: 200 - (_animation.value * 50) as double?,
        height: 100 + (_animation.value * 20) as double?,
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: BorderRadius.all(
            Radius.circular(_animation.value * 24)
          ),
        ),
      ),
      transform: Matrix4.identity()
        // translate animation vertically from 0 to 30.0
        ..translate(0.0, _animation.value * 30.0, 0.0)
        // set z value for depth perception when rotating
        ..setEntry(3, 2, 0.001) 
        // rotate animation along X axis
        ..rotateX(_animation.value * -pi / 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFlipDrawer ? AppBar() : AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => SlideDrawer.of(context)?.toggle(),
            );
          },
        ),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              DropdownCurve(
                value: curve,
                onChanged: (newCurve) {
                  setState(() {
                    curve = newCurve;
                    _initAnimation();
                    _animate();

                    if(isSlideDrawer) 
                      SlideDrawer.of(context)?.reset();

                    if(isFlipDrawer) 
                      FlipDrawer.of(context)?.reset();
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _animatedOpacity,
                  SizedBox(width: 40),
                  _animatedColor,
                ],
              ),
              SizedBox(height: 20),
              _animatedContainer,
              SizedBox(height: 20),
              _animatedTransform,
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}