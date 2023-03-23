import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:repository/Home/Home.dart';

class setPage extends StatefulWidget {
  @override
  State<setPage> createState() => PaSetScreen();
}

class PaSetScreen extends State<setPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(
        'Mulungushi University Repository',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: Colors.blue,
    ));

    bottomNavigationBar:
    BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: ("home"),
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.folder,
              color: Colors.white,
            ),
            label: ("MyRepo"),
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.looks,
              color: Colors.white,
            ),
            label: ("Explore"),
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: ("Profile"),
            backgroundColor: Colors.blue),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
