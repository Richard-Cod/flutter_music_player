import 'package:flutter/material.dart';
import 'deezerApp/ui/myplaylist.dart';

import 'deezerApp/ui/songplaying.dart';
import 'deezerApp/ui/search.dart';

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    MyPlaylist(),
    Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kBgColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Ma playlist'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Recherche'),
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
