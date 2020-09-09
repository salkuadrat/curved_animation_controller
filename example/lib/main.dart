import 'package:example/flip_drawer.dart';
import 'package:example/page.dart';
import 'package:example/shared.dart';
import 'package:example/slide_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {

  static _AppState of(BuildContext context) =>
    context.findAncestorStateOfType<_AppState>();
  
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  
  String _title = 'Curved Animation';
  Key _key = UniqueKey();

  restart() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _key,
      title: 'Curved Animation Controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: type == DrawerType.flip 
        ? FlipDrawer(title: _title, drawer: DrawerWidget(), child: HomePage()) 
        : SlideDrawer(drawer: DrawerWidget(), child: HomePage(title: _title)),
    );
  }
}