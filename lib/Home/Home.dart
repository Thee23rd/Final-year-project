import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:repository/Schools/DRPGS.dart';
import 'package:repository/Schools/SNAR.dart';
import 'package:repository/Schools/SOE.dart';
import 'package:repository/Schools/SOMHS.dart';
import 'package:repository/Schools/SS.dart';
import 'package:repository/Schools/SoA.dart';
import 'package:repository/Schools/SoBS.dart';
import 'package:repository/Schools/set.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/iewe.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:repository/view/viewed.dart';
import 'package:repository/Auth/login.dart';

class repoHome extends StatefulWidget {
  const repoHome({Key? key}) : super(key: key);

  @override
  State<repoHome> createState() => _repoHomeBig();
}

class _repoHomeBig extends State<repoHome> {
  int fileCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<int> _countFilesInFolder(String folderPath) async {
    try {
      // Get a reference to the Firebase Storage folder
      Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);

      // Use the listAll() method to get a list of all items in the folder
      ListResult result = await folderRef.listAll();

      // Return the file count based on the number of items in the folder
      return result.items.length;
    } catch (error) {
      print('Error counting files: $error');
      return 0;
    }
  }

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
                  GestureDetector(
                    child: Text(
                      'Veiw all',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizakoPdf())))
                    },
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
                              builder: ((context) => LangizakoPdfSet())));
                    },
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: _countFilesInFolder(
                                    'pdfs/School of Engineering and Technology'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData && snapshot.data != 0) {
                                    return Positioned(
                                        right: null,
                                        top: null,
                                        child: Transform.translate(
                                            offset: Offset(10.0, -10.0),
                                            child: FractionalTranslation(
                                              translation: Offset(1.9, 0.051),
                                              child: badges.Badge(
                                                badgeContent: Text(
                                                    '${snapshot.data}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )));
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Image.asset(
                                'assets/images/et.png',
                                height: 35,
                              ),
                              Text(
                                'School of Engineering and Technology',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizakoPdfSoA())));
                    },
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: _countFilesInFolder(
                                    'pdfs/School of Agriculture'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData && snapshot.data != 0) {
                                    return Positioned(
                                        right: null,
                                        top: null,
                                        child: Transform.translate(
                                            offset: Offset(10.0, -10.0),
                                            child: FractionalTranslation(
                                              translation: Offset(1.9, 0.051),
                                              child: badges.Badge(
                                                badgeContent: Text(
                                                    '${snapshot.data}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )));
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Image.asset(
                                'assets/images/agric.png',
                                height: 41,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'School of Agriculture',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LangizakoPdfSS())));
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
                          FutureBuilder(
                            future: _countFilesInFolder(
                                'pdfs/School of Social Science'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/ss.png',
                            height: 41,
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
                              builder: ((context) => LangizakoPdfBS())));
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
                          FutureBuilder(
                            future: _countFilesInFolder(
                                'pdfs/School of Business Studies'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/BS.png',
                            height: 41,
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
                              builder: ((context) => LangizakoPdfSOE())));
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
                          FutureBuilder(
                            future:
                                _countFilesInFolder('pdfs/School of Education'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/ED.png',
                            height: 41,
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
                              builder: ((context) => LangizakoPdfSOMHS())));
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
                          FutureBuilder(
                            future: _countFilesInFolder(
                                'pdfs/School of Medicine and Health Science'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/Med.png',
                            height: 25,
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
                              builder: ((context) => LangizakoPdfSNAR())));
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
                          FutureBuilder(
                            future: _countFilesInFolder(
                                'pdfs/School of Natural and Applied Science'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/NS.png',
                            height: 25,
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
                              builder: ((context) => LangizakoPdfDG())));
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
                          FutureBuilder(
                            future: _countFilesInFolder(
                                'pdfs/School of Directorate of Research and Post Graduate Studies'),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData && snapshot.data != 0) {
                                return Positioned(
                                    right: null,
                                    top: null,
                                    child: Transform.translate(
                                        offset: Offset(10.0, -10.0),
                                        child: FractionalTranslation(
                                          translation: Offset(1.9, 0.051),
                                          child: badges.Badge(
                                            badgeContent: Text(
                                                '${snapshot.data}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )));
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Image.asset(
                            'assets/images/chuwi.png',
                            height: 25,
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
                      MaterialPageRoute(builder: ((context) => repoHome())));
                }),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              label: ("home"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => LangizakodPdf())));
                }),
                child: Icon(
                  Icons.folder,
                  color: Colors.white,
                ),
              ),
              label: ("MyRepo"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => LangizakoPdf())));
                }),
                child: Icon(
                  Icons.looks,
                  color: Colors.white,
                ),
              ),
              label: ("Explore"),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => UploadPDFz())));
                }),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
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
