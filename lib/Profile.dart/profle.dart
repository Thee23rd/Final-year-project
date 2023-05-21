import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repository/Auth/login.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late User _user;
  String? _firstName;
  String? _lastName;
  String? _studentNumber;
  String? _program;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _user = user;
        _loadUserData();
      }
    });
  }

  void _loadUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Credentials')
        .doc(_user.uid)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      setState(() {
        _firstName = data['firstname'];
        _lastName = data['lastname'];
        _studentNumber = data['StudentNumber'].toString();
        _program = data['Programme'];
      });
    }
  }

  int _currentIndex = 4;

  Widget build(BuildContext context) {
    bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    if (_firstName == null) {
      _loadUserData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal File'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => LoginPage()),
                ),
              );
            },
          ),
        ],
      ),
      body: isAuthenticated &&
              _firstName != null &&
              _lastName != null &&
              _studentNumber != null &&
              _program != null
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.red,
                    radius: 50,
                    child: Text(
                      _firstName!.substring(0, 1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${_firstName ?? ''} ${_lastName ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        // add bold and bigger font size to the name
                        SizedBox(
                            height: 20), // add some spacing between the fields
                        Text('Student Number: ${_studentNumber ?? ''}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        SizedBox(height: 10),
                        Text('Programme: ${_program ?? ''}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                'Hello guest, sign in to enjoy full access of the repository',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
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
                      builder: ((context) => LangizakoPdfmy())));
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
  }
}
