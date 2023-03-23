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

class LangizaPdf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LangizaURLState();
}

class LangizaURLState extends State<LangizaPdf> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('pdfs')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('pdfs/Today.pdf')
        .getDownloadURL();
    print(downloadURL);
    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewPDFwe(doc))); //Notice the Push Route once this is done.
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listExample();
    downloadURLExample();
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ViewPDFwe extends StatefulWidget {
  PDFDocument document;
  ViewPDFwe(this.document);
  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDFwe> {
  @override
  Widget build(BuildContext context) {
    return Center(child: PDFViewer(document: widget.document));
  }
}
