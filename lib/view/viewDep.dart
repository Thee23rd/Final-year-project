import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repository/view/MyFiles.dart';
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

class DepartmentsPaged extends StatefulWidget {
  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPaged> {
  List<firebase_storage.Reference> _subfolders = [];
  List<Map<String, dynamic>> _files = [];

  @override
  void initState() {
    super.initState();
    _listSubfolders();
  }

  Future<void> _listSubfolders() async {
    final firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('pdfs')
        .listAll();

    final List<firebase_storage.Reference> folders = result.prefixes;

    List<firebase_storage.Reference> subfolders = [];
    for (final folder in folders) {
      final firebase_storage.ListResult subfolderResult = await folder.list();
      subfolders.addAll(subfolderResult.prefixes);
    }

    setState(() {
      _subfolders = subfolders;
    });
  }

  Future<void> _listFilesInSubfolder(
      firebase_storage.Reference subfolder) async {
    final firebase_storage.ListResult result = await subfolder.list();

    List<Map<String, dynamic>> files = [];
    for (final file in result.items) {
      final metadata = await file.getMetadata();
      final customMetadata = metadata.customMetadata;
      files.add({
        'file': file,
        'metadata': customMetadata,
      });
    }

    setState(() {
      _files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View By Departments'),
      ),
      body: _subfolders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? ListView.builder(
                  itemCount: _subfolders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final subfolder = _subfolders[index];
                    return ListTile(
                      title: Text(subfolder.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      leading: Icon(Icons.folder),
                      onTap: () {
                        _listFilesInSubfolder(subfolder);
                      },
                    );
                  },
                )
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (BuildContext context, int index) {
                    final fileData = _files[index];
                    final file = fileData['file'];
                    final metadata = fileData['metadata'];
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
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(' ${file.name}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Author: ${metadata['author']}'),
                              Text('Title: ${metadata['title']}'),
                              Text('Department: ${metadata['Department']}'),
                              Text('School: ${metadata['School']}'),

                              // Add more custom metadata fields as needed
                            ],
                          ),
                          leading: Icon(Icons.picture_as_pdf),
                          onTap: () {
                            _openPDF(context, file);
                          },
                        ));
                  },
                ),
    );
  }
}

Future<void> _openPDF(
    BuildContext context, firebase_storage.Reference file) async {
  final String downloadURL = await file.getDownloadURL();

  final metadata = await file.getMetadata();
  final customMetadata = metadata.customMetadata;
  final author = customMetadata!['author'];
  final title = customMetadata['title'];
  final description = customMetadata['description'];
  final school = customMetadata['school'];

  final lastModified = metadata.updated!.toIso8601String().substring(0, 10);

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
            Text('Last modified: $lastModified'),
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
