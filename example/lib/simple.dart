import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:example/shared.dart';
import 'package:flutter/material.dart';

class SimpleAnimationPage extends StatefulWidget {
  @override
  _SimpleAnimationPageState createState() => _SimpleAnimationPageState();
}

class _SimpleAnimationPageState extends State<SimpleAnimationPage> with 
  TickerProviderStateMixin {

  CurvedAnimationController _animation;
  CurvedColorAnimationController _colorAnimation;

  @override
  void initState() {
    _initAnimation();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _animate();
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  _initAnimation() {
    _animation = CurvedAnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 750), 
      curve: curve,
      begin: 0.0,
      end: 1.0,
    );

    _colorAnimation = CurvedColorAnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750), 
      curve: curve,
      begin: Colors.orangeAccent,
      end: Colors.teal,
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

  Widget get _menuBtn => Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () { Scaffold.of(context).openDrawer(); },
      );
    },
  );

  Widget get _drawer => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [

      ],
    ),
  );

   DropdownMenuItem<Curve> _dropdownItem(NamedCurve c) => DropdownMenuItem(
    child: Text('${c.name}'),
    value: c.curve,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _menuBtn,
        title: Text('Simple Animation'),
      ),
      drawer: _drawer,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              DropdownButton<Curve>(
                value: curve,
                items: curves.map(_dropdownItem).toList(), 
                onChanged: (newCurve) {
                  setState(() {
                    curve = newCurve;
                    _initAnimation();
                    _animate();
                  });
                },
              ),
              SizedBox(height: 20),
              Opacity(
                opacity: 0.8 + (_animation.value * 0.2),
                child: Transform(
                  child: Container(
                    color: _colorAnimation.value,
                    width: 200 - (_animation.value * 50),
                    height: 100 + (_animation.value * 100),
                  ),
                  transform: Matrix4.identity()
                    ..translate(0.0, _animation.value * 30.0, 0.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}