import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';

import 'package:http/http.dart' as http;
import 'package:repository/Explore/threadlist.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';

class LangizakoPdf extends StatefulWidget {
  @override
  _LangizaPdfState createState() => _LangizaPdfState();
}

class _LangizaPdfState extends State<LangizakoPdf> {
  List<firebase_storage.Reference> _files = [];
  List<firebase_storage.Reference> _filteredFiles = [];

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    final List<firebase_storage.Reference> folders = [];
    final List<firebase_storage.Reference> files = [];
    await _listAllFiles(firebase_storage.FirebaseStorage.instance.ref(), files);
    setState(() {
      _files = files;
      _filteredFiles = files; // initialize filtered list
    });
  }

  Future<void> _listAllFiles(firebase_storage.Reference ref,
      List<firebase_storage.Reference> files) async {
    final firebase_storage.ListResult result = await ref.listAll();
    files.addAll(result.items);
    await Future.forEach(result.prefixes,
        (firebase_storage.Reference prefixRef) async {
      await _listAllFiles(prefixRef, files);
    });
  }

  int _currentIndex = 3;

  void _onSearch(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredFiles = _files; // show all files if search text is empty
      } else {
        _filteredFiles = _files.where((file) {
          final fileName = file.name.toLowerCase();
          final search = searchText.toLowerCase();
          return fileName.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Files')),
      body: Column(
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
                    onChanged: _onSearch, // call onSearch method on text change
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
          Expanded(
              child: _filteredFiles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final file = _filteredFiles[index];
                        return Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 12),
                                      blurRadius: 70,
                                      color: Colors.grey)
                                ]),
                            child: ListTile(
                              title: Text(
                                file.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(Icons.picture_as_pdf),
                              subtitle: FutureBuilder(
                                future: file.getMetadata(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<firebase_storage.FullMetadata>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Loading...');
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final metadata = snapshot.data!;
                                    final lastModified = metadata.updated!
                                        .toIso8601String()
                                        .substring(0, 10);
                                    final customMetadata =
                                        metadata.customMetadata;
                                    final author = customMetadata!['author'];
                                    final title = customMetadata['title'];
                                    final school = customMetadata['School'];
                                    final department =
                                        customMetadata['Department'];
                                    final date = customMetadata['date'];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text('Author: $author'),
                                        Text('Title: $title'),
                                        SizedBox(height: 4),
                                        Text('Upload Date: $date'),
                                        Text('Department: $department'),
                                        Text('School: $school'),
                                      ],
                                    );
                                  }
                                },
                              ),
                              onTap: () => _openPDF(context, file),
                            ));
                      },
                    )),
        ],
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

  Future<void> _openPDF(
      BuildContext context, firebase_storage.Reference file) async {
    final String downloadURL = await file.getDownloadURL();

    final metadata = await file.getMetadata();
    final customMetadata = metadata.customMetadata;
    final author = customMetadata!['author'];
    final title = customMetadata['title'];
    final description = customMetadata['description'];
    final date = customMetadata['date'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(file.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Text('Author: $author'),
              SizedBox(height: 4),
              Text('Title: $title'),
              SizedBox(height: 4),
              Text('Description: $description'),
              SizedBox(height: 4),
              Text('Last modified: $date'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Open'),
              onPressed: () async {
                Navigator.of(context).pop();
                if (await Permission.storage.request().isGranted) {
                  final directory = await getExternalStorageDirectory();
                  final file = File('${directory!.path}/my_file.pdf');
                  final response = await http.get(Uri.parse(downloadURL));
                  await file.writeAsBytes(response.bodyBytes);

                  // open PDF file with default viewer
                  try {
                    await OpenFile.open(file.path);
                  } catch (e) {
                    // handle the exception here
                  }

                  // navigate to PDF screen
                  final PDFDocument document =
                      await PDFDocument.fromURL(downloadURL);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfScreen(document: document)),
                  );
                } else {
                  // handle the denied permission
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
