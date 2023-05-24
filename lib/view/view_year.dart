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
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/Upload/chatup.dart';
import 'package:repository/view/MyFiles.dart';

class Langizakoyear extends StatefulWidget {
  @override
  _LangizaPdfState createState() => _LangizaPdfState();
}

class _LangizaPdfState extends State<Langizakoyear> {
  List<firebase_storage.Reference> _files = [];
  List<firebase_storage.Reference> _filteredFiles = [];
  Map<int, List<firebase_storage.Reference>> _filesByYear = {};

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    final List<firebase_storage.Reference> folders = [];
    final List<firebase_storage.Reference> files = [];
    final Map<int, List<firebase_storage.Reference>> filesByYear =
        await _listAllFiles(firebase_storage.FirebaseStorage.instance.ref());
    filesByYear.forEach((year, yearFiles) {
      files.addAll(yearFiles);
    });
    setState(() {
      _files = files;
      _filteredFiles = files; // initialize filtered list
      _filesByYear = filesByYear; // store files grouped by year
    });
  }

  Future<Map<int, List<firebase_storage.Reference>>> _listAllFiles(
      firebase_storage.Reference ref) async {
    final firebase_storage.ListResult result = await ref.listAll();
    final Map<int, List<firebase_storage.Reference>> filesByYear = {};
    for (final item in result.items) {
      final metadata = await item.getMetadata();
      final date = metadata.customMetadata!['date'];
      if (date != null) {
        final year = int.tryParse(date.substring(0, 4));
        if (year != null) {
          if (!filesByYear.containsKey(year)) {
            filesByYear[year] = [];
          }
          filesByYear[year]!.add(item);
        }
      }
    }
    await Future.forEach(result.prefixes,
        (firebase_storage.Reference prefixRef) async {
      final subFiles = await _listAllFiles(prefixRef);
      subFiles.forEach((year, files) {
        if (!filesByYear.containsKey(year)) {
          filesByYear[year] = [];
        }
        filesByYear[year]!.addAll(files);
      });
    });
    return filesByYear;
  }

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

  Widget _buildYearListTiles() {
    return ListView.builder(
      itemCount: _filesByYear.length,
      itemBuilder: (BuildContext context, int index) {
        final year = _filesByYear.keys.toList()[index];
        final yearFiles = _filesByYear[year]!;
        return ExpansionTile(
          title: Text(year.toString()),
          children: yearFiles.map((file) {
            return FutureBuilder(
              future: file.getMetadata(),
              builder: (BuildContext context,
                  AsyncSnapshot<firebase_storage.FullMetadata> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final metadata = snapshot.data!;
                  final school =
                      metadata.customMetadata!['School'] ?? 'Unknown School';
                  final date = metadata.customMetadata!['date'];
                  return ListTile(
                    title: Text(
                      file.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.picture_as_pdf),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Author: ${metadata.customMetadata!['author']}'),
                        Text('Title: ${metadata.customMetadata!['title']}'),
                        SizedBox(height: 4),
                        Text(
                            'Upload Date: ${metadata.customMetadata!['date']}'),
                        Text('School: $school'),
                        // Text('Year: ${metadata.customMetadata!['year']}'),
                      ],
                    ),
                    onTap: () => _openPDF(context, file),
                  );
                }
              },
            );
          }).toList(),
        );
      },
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
    final school = customMetadata['school'];
    final date = customMetadata['date'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View by year')),
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
                : _buildYearListTiles(),
          ),
        ],
      ),
    );
  }
}
