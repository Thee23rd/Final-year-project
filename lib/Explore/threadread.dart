import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:repository/Explore/threadlist.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';

class ThreadPage extends StatefulWidget {
  final String threadId;

  ThreadPage({required this.threadId});

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final comment = _commentController.text;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Save the comment to Firestore
        await FirebaseFirestore.instance
            .collection('threads')
            .doc(widget.threadId)
            .collection('comments')
            .add({
          'text': comment,
          'timestamp': DateTime.now(),
          'userId': userId,
        });

        setState(() {
          comments.add({
            'text': comment,
            'userId': userId,
          });
          _commentController.clear();
        });
      }
    }
  }

  Future<String> _getUserName(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Credentials')
        .doc(userId)
        .get();

    final userData = userDoc.data() as Map<String, dynamic>?;
    final userName = userData?['firstname'] ?? '';

    return userName;
  }

  void _requestCollaboration() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _messageController =
            TextEditingController();

        return AlertDialog(
          title: Text('Collaboration Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your collaboration request details:'),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final message = _messageController.text;
                // Save the collaboration request or handle it in any way you want
                _sendCollaborationRequest(message);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _sendCollaborationRequest(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final collaborationRequestId =
          widget.threadId; // Use the same ID as the thread ID

      await FirebaseFirestore.instance
          .collection('threads')
          .doc(widget.threadId)
          .collection('collaborationRequests')
          .doc(collaborationRequestId)
          .set({
        'message': message,
        'userId': userId,
        'threadId': widget.threadId,
        'timestamp': DateTime.now(),
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Collaboration Request'),
            content: Text('Your collaboration request has been sent.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  int _currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('threads')
            .doc(widget.threadId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final threadData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        threadData['title'],
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        threadData['content'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      ElevatedButton(
                        onPressed: _requestCollaboration,
                        child: Text('Request Collaboration'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('threads')
                      .doc(widget.threadId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final commentDocs = snapshot.data!.docs;

                    if (commentDocs.isEmpty) {
                      return Center(
                        child: Text('No comments yet.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: commentDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final commentData =
                            commentDocs[index].data() as Map<String, dynamic>;
                        final commentText = commentData['text'] ?? '';
                        final userId = commentData['userId'] ?? '';

                        return FutureBuilder<String>(
                          future: _getUserName(userId),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(); // Placeholder widget while loading
                            }

                            final userName = snapshot.data ?? '';

                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(commentText),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Comment by: $userName',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Date: ${commentData['timestamp'].toDate().toString()}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _addComment,
                  child: Text('Add Comment'),
                ),
              ),
            ],
          );
        },
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
}
