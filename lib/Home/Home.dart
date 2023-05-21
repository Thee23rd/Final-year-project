import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:repository/Explore/card.dart';
import 'package:repository/Explore/threads.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:repository/view/viewDep.dart';
import 'package:repository/view/view_year.dart';
import 'package:repository/view/viewed.dart';
import 'package:repository/Auth/login.dart';

import '../Explore/threadlist.dart';
import '../Explore/threadread.dart';
import '../view/departments.dart';

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
              /* child: Container(
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
              ),*/
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
                              image: AssetImage('assets/images/7.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/2.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/4.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/1.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/3.jpg'),
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
                                'assets/images/5.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                      options: CarouselOptions(
                        height: 150.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 5 / 3,
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
              padding: EdgeInsets.fromLTRB(20, 15, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'View all',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => LangizakoPdf()),
                            ),
                          ),
                        },
                      ),
                      SizedBox(
                          width:
                              10), // Add spacing between the GestureDetector widgets
                      GestureDetector(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'View by Department',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => DepartmentsPaged()),
                            ),
                          ),
                        },
                      ),
                      SizedBox(
                          width:
                              10), // Add spacing between the GestureDetector widgets
                      GestureDetector(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'View by Year',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => Langizakoyear()),
                            ),
                          ),
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'View by School',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName:
                                      'School of Engineering and Technology'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName: 'School of Agriculture'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName: 'School of Social Science'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName: 'School of Business Studies'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName: 'School of Education'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName:
                                      'School of Medicine and Health Science'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName:
                                      'School of Natural and Applied Science'))));
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
                              builder: ((context) => DepartmentsPage(
                                  schoolName:
                                      'School of Directorate of Research and Post Graduate Studies'))));
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
                      builder: ((context) => LangizakoPdfmy())));
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => UploadPDFz())));
              }),
              child: Icon(
                Icons.cloud_upload,
                color: Colors.white,
              ),
            ),
            label: ("Upload"),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ThreadListPage())));
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => PersonalPage())));
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
