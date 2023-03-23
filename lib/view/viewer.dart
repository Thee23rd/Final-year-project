import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class LangizadPdf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LangizadURLState();
}

class LangizadURLState extends State<LangizadPdf> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('pdfs')
        .listAll();

    List<String> fileList = [];
    result.items.forEach((firebase_storage.Reference ref) {
      String fileName = ref.name;
      fileList.add(fileName);
    });

    return fileList;
  }

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('pdfs/17.pdf')
        .getDownloadURL();
    print(downloadURL);
    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewPDFs(doc))); //Notice the Push Route once this is done.
  }

  @override
  void initState() {
    super.initState();
    listExample().then((fileList) {
      print(fileList); // Do something with the list of file names
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ViewPDFs extends StatefulWidget {
  PDFDocument document;
  ViewPDFs(this.document);
  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDFs> {
  @override
  Widget build(BuildContext context) {
    return Center(child: PDFViewer(document: widget.document));
  }
}
