import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/viewed.dart';

class LangizakoPdfmy extends StatefulWidget {
  @override
  _LangizaPdfState createState() => _LangizaPdfState();
}

class _LangizaPdfState extends State<LangizakoPdfmy> {
  List<firebase_storage.Reference> _files = [];
  List<firebase_storage.Reference> filesByCurrentUser = [];
  List<firebase_storage.Reference> filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final List<firebase_storage.Reference> folders = [];
    final List<firebase_storage.Reference> files = [];
    await _listAllFiles(
      firebase_storage.FirebaseStorage.instance.ref(),
      folders,
      files,
    );
    final filesWithCustomMetadata = await Future.wait(
      files.map((file) => file.getMetadata()).toList(),
    );

    filesByCurrentUser = files
        .where((file) =>
            filesWithCustomMetadata[files.indexOf(file)]
                .customMetadata!['user'] ==
            userId)
        .toList();

    setState(() {
      filteredFiles = filesByCurrentUser;
    });
  }

  Future<void> _listAllFiles(
      firebase_storage.Reference ref,
      List<firebase_storage.Reference> folders,
      List<firebase_storage.Reference> files) async {
    final firebase_storage.ListResult result = await ref.listAll();
    folders.add(ref); // add current folder to the list
    files.addAll(result.items);
    await Future.forEach(result.prefixes,
        (firebase_storage.Reference prefixRef) async {
      await _listAllFiles(prefixRef, folders, files);
    });
  }

  int _currentIndex = 1;

  void _filterFiles(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        filteredFiles = filesByCurrentUser;
      });
    } else {
      setState(() {
        filteredFiles = filesByCurrentUser
            .where((file) =>
                file.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Files')),
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
                    controller: searchController,
                    onChanged: _filterFiles,
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
            child: filteredFiles.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      final file = filteredFiles[index];
                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 12),
                              blurRadius: 70,
                              color: Colors.grey,
                            )
                          ],
                        ),
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

                                final customMetadata = metadata.customMetadata;
                                final author = customMetadata!['author'];
                                final title = customMetadata['title'];
                                final school = customMetadata['School'];
                                final date = customMetadata['date'];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text('Author: $author'),
                                    Text('Title: $title'),
                                    SizedBox(height: 4),
                                    Text('Upload Date: $date'),
                                    Text('School: $school'),
                                  ],
                                );
                              }
                            },
                          ),
                          onTap: () => _openPDF(context, file),
                        ),
                      );
                    },
                  ),
          ),
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

class PdfScreen extends StatelessWidget {
  final PDFDocument document;

  const PdfScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Document"),
      ),
      body: Center(
        child: PDFViewer(document: document),
      ),
    );
  }
}
