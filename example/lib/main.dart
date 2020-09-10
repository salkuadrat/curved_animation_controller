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
      home: isFlipDrawer 
        ? FlipDrawer(title: _title, drawer: MenuDrawer(), child: HomePage()) 
        : SlideDrawer(drawer: MenuDrawer(), child: HomePage(title: _title)),
    );
  }
}

class MenuDrawer extends StatelessWidget {

  BoxDecoration get _gradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0], 
      colors: [
        Color(0xFF43CEA2),
        Color(0xFF1D6DBD),
      ],
    ),
  );

  BoxDecoration get _color => BoxDecoration(
    color: Colors.teal[500],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.transparent,
      borderOnForeground: false,
      child: Container(
        decoration: isSlideDrawer ? _gradient : _color,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if(!isSlideDrawer) ListTile(
                  leading: Icon(Icons.adjust),
                  title: Text('Slide Drawer'),
                  onTap: () {
                    type = DrawerType.slide;
                    App.of(context).restart();
                  },
                ),
                if(!isFlipDrawer) ListTile(
                  leading: Icon(Icons.adjust),
                  title: Text('Flip Drawer'),
                  onTap: () {
                    type = DrawerType.flip;
                    App.of(context).restart();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rss_feed),
                  title: Text('News'),
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('Favourites'),
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Map'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}