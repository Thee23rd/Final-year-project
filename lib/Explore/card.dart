import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Credentials').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final users =
              snapshot.data!.docs.map((doc) => User.fromSnapshot(doc)).toList();

          if (users.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              final userId = user.userId; // Store userId in a separate variable

              return FutureBuilder<bool>(
                future: _hasFiles(
                    userId,
                    firebase_storage.FirebaseStorage.instance
                        .ref('pdfs/$userId')),
                builder: (BuildContext context,
                    AsyncSnapshot<bool> hasFilesSnapshot) {
                  if (hasFilesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Checking Files...'),
                      subtitle: Text('User: ${user.firstname}'),
                      trailing: CircularProgressIndicator(),
                    );
                  }

                  final hasFiles = hasFilesSnapshot.data;

                  if (hasFiles == true) {
                    return UserCard(user: user);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _hasFiles(String userId, Reference folderRef) async {
    try {
      final ListResult folderResult = await folderRef.listAll();

      if (folderResult.items.isNotEmpty) {
        // Files found in the current folder
        return true;
      }

      for (final prefixRef in folderResult.prefixes) {
        // Recursively check files in subfolders
        final hasFiles = await _hasFiles(userId, prefixRef);
        if (hasFiles) {
          // Files found in subfolder
          return true;
        }
      }

      // No files found in the current folder or its subfolders
      return false;
    } catch (e) {
      print('Error checking files for user: $e');
      return false;
    }
  }
}

class User {
  final String userId;
  final String? firstname;

  User({required this.userId, this.firstname});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final userId = snapshot.id;
    final displayName = data['firstname'] as String?;

    return User(userId: userId, firstname: displayName);
  }
}

class UserCard extends StatelessWidget {
  final User user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.firstname ?? 'No display name'),
        subtitle: Text(user.userId),
      ),
    );
  }
}
