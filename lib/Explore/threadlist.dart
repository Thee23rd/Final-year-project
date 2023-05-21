import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:repository/Explore/Mythread.dart';
import 'package:repository/Explore/collabo.dart';
import 'package:repository/Explore/threadread.dart';
import 'package:repository/Explore/threads.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';

class ThreadListPage extends StatefulWidget {
  @override
  _ThreadListPageState createState() => _ThreadListPageState();
}

class _ThreadListPageState extends State<ThreadListPage> {
  bool _hasUnreadNotification = false;

  @override
  void initState() {
    super.initState();
    _checkUnreadNotifications();
  }

  void _checkUnreadNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('collaborationRequests')
          .where('userId', isEqualTo: userId)
          .where('hasUnreadNotification', isEqualTo: true)
          .limit(1)
          .get();

      setState(() {
        _hasUnreadNotification = snapshot.docs.isNotEmpty;
      });
    }
  }

  void _handleNotificationIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyThreadsPage()),
    );
  }

  void _handleCreateThreadButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => CreateThreadPage()),
      ),
    );
  }

  int _currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                if (_hasUnreadNotification)
                  Positioned(
                    right: 0,
                    child: Icon(
                      Icons.brightness_1,
                      size: 12,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            onPressed: _handleNotificationIconPressed,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('threads').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final threadList = snapshot.data!.docs;

          if (threadList.isEmpty) {
            return Center(child: Text('No threads found.'));
          }

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: threadList.length,
              itemBuilder: (BuildContext context, int index) {
                final thread = threadList[index];
                final threadData = thread.data();

                if (threadData == null || threadData is! Map<String, dynamic>) {
                  return SizedBox.shrink();
                }

                return Card(
                  elevation: 2.0,
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Credentials')
                              .doc(threadData['userId'])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            }

                            final userData = snapshot.data!.data();

                            if (userData == null ||
                                userData is! Map<String, dynamic>) {
                              return SizedBox.shrink();
                            }

                            final userName = userData['firstname'];

                            return Text(
                              userName,
                            );
                          },
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          threadData['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(threadData['content']),
                        Text(
                          _getFormattedDate(threadData['timestamp']),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThreadPage(
                            threadId: thread.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleCreateThreadButtonPressed,
        icon: Icon(Icons.add),
        label: Text('Create Thread'),
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
  }

  String _getFormattedDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }
}
