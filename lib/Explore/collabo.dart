import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:repository/Explore/threadlist.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';
import 'package:url_launcher/url_launcher.dart';

class CollaborationRequestsPage extends StatefulWidget {
  final String currentUserId;
  final String threadId;

  CollaborationRequestsPage({
    required this.currentUserId,
    required this.threadId,
  });

  @override
  _CollaborationRequestsPageState createState() =>
      _CollaborationRequestsPageState();
}

class _CollaborationRequestsPageState extends State<CollaborationRequestsPage> {
  int _currentIndex = 3;

  Future<void> _sendEmail(String? recipientEmail) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail ?? '',
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String? senderEmail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Collaboration Request'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to accept this collaboration request?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Reject'),
              onPressed: () {
                Navigator.of(context).pop();
                // Send rejection email
                _sendEmail(senderEmail);
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
                // Send acceptance email
                _sendEmail(senderEmail);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collaboration Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('threads')
            .doc(widget.threadId)
            .collection('collaborationRequests')
            .where('threadId', isEqualTo: widget.threadId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final collaborationRequests = snapshot.data?.docs;

          if (collaborationRequests == null || collaborationRequests.isEmpty) {
            return Center(child: Text('No collaboration requests found.'));
          }

          return ListView.builder(
            itemCount: collaborationRequests.length,
            itemBuilder: (context, index) {
              final collaborationRequest = collaborationRequests[index];
              final data = collaborationRequest.data() as Map<String, dynamic>?;
              final message = data?['message'] as String?;
              final userId = data?['userId'] as String?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Credentials')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Loading...'),
                    );
                  }

                  final userData =
                      snapshot.data?.data() as Map<String, dynamic>?;
                  final firstName = userData?['firstname'] as String?;
                  final lastName = userData?['lastname'] as String?;
                  final senderEmail = userData?['email'] as String?;

                  return ListTile(
                    leading: Icon(Icons.message),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Message: $message'),
                        Text('Sent by: $firstName $lastName'),
                      ],
                    ),
                    onTap: () {
                      _showConfirmationDialog(context, senderEmail);
                    },
                  );
                },
              );
            },
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => repoHome()),
                );
              },
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LangizakoPdfmy()),
                );
              },
              child: Icon(
                Icons.folder,
                color: Colors.white,
              ),
            ),
            label: 'MyRepo',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UploadPDFz()),
                );
              },
              child: Icon(
                Icons.cloud_upload,
                color: Colors.white,
              ),
            ),
            label: 'Upload',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ThreadListPage()),
                );
              },
              child: Icon(
                Icons.looks,
                color: Colors.white,
              ),
            ),
            label: 'Explore',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PersonalPage()),
                );
              },
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
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
