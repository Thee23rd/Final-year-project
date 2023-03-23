import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/iewe.dart';
import 'package:repository/view/viewed.dart';
import 'package:repository/view/viewer.dart';
import 'package:repository/view_download/try.dart';
import '../Upload/lib.dart';
import 'package:repository/Auth/login.dart';
import 'package:repository/Upload/scieTech.dart';

class BottomNavigationBar1 extends StatelessWidget {
  const BottomNavigationBar1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [(new Color(0x0458AB)), (new Color(0xE34D3E))],
        ),
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconBottomBar(
                    text: "Home",
                    icon: Icons.home,
                    selected: true,
                    onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  const IconBottomBar(
      {required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon,
              size: 22, color: selected ? Colors.white : Color(0xE34D3E)),
        ),
        Text(text,
            style: TextStyle(
                fontSize: 12,
                height: 0.1,
                color: selected ? Colors.white : Color(0xE34D3E)))
      ],
    );
  }
}

class repoHome extends StatefulWidget {
  const repoHome({Key? key}) : super(key: key);

  @override
  State<repoHome> createState() => _repoHomeBig();
}

class _repoHomeBig extends State<repoHome> {
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by Topic or Field',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                ]),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/all.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CarouselSlider(
                      items: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/MU_Logo.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/fc.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/grr.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/matero.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/nyon.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/et.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                        height: 120.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ),
                  Text(
                    ' Repository '
                    'for '
                    'Projects Reports and Research Reports ',
                    style: TextStyle(
                      backgroundColor: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show  By School',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Veiw all',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                primary: false,
                crossAxisCount: 3,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MyHomePage())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/et.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Engineering and Technology',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => UploadPDFz())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/agric.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Agriculture',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ss.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Social Science',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizaPdf())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/BS.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Business Studies',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizadPdf())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ED.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Education',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizakoPdf())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Med.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Medicine & Health Science',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/NS.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'School of Natural & Applied Science ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())));
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/chuwi.png',
                            height: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Directorate of Research & Post Graduate Studies ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => MyHomePage())));
                }),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
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
      ),
    );

    // ignore: dead_code
  }
}
