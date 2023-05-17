import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:repository/Home/Home.dart';

import '../Auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, loginRoute);
  }

  loginRoute() {
    Navigator.pushReplacement(
        this.context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Separa();
  }

  Widget Separa() {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [(new Color(0x0458AB)), (new Color(0xE34D3E))],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
        Center(
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 100),
                padding: EdgeInsets.only(left: 20, right: 20, top: 100),
                child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                )))),
        Center(
          child: Container(
            child: Image.asset(
              'assets/images/MU_Logo.jpg',
              height: 120,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 100),
            padding: EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Text(
              "'Pursing the Frontiers Of Knowledge'",
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
          ),
        )
      ]),
    );
  }
}
