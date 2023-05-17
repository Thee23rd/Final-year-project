import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:repository/Home/Home.dart';
import 'package:repository/view/viewed.dart';

import '../Schools/set.dart';

class DepartmentsPage extends StatefulWidget {
  final String schoolName;

  DepartmentsPage({required this.schoolName});

  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  List<firebase_storage.Reference> _folders = [];

  @override
  void initState() {
    super.initState();
    _listFolders();
  }

  Future<void> _listFolders() async {
    final firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('pdfs/${widget.schoolName}')
        .listAll();

    setState(() {
      _folders = result.prefixes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schoolName),
      ),
      body: _folders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _folders.length,
              itemBuilder: (BuildContext context, int index) {
                final folder = _folders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LangizakoPdfSet(
                          schoolName: widget.schoolName,
                          departmentName: folder.name,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(folder.name),
                    leading: Icon(Icons.folder),
                    trailing: FutureBuilder<firebase_storage.ListResult>(
                      future: folder.list(),
                      builder: (BuildContext context,
                          AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                        if (snapshot.hasData) {
                          final numFiles = snapshot.data!.items.length;
                          return Text('$numFiles files');
                        } else {
                          return SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
