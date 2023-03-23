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

class LangizakoPdf extends StatefulWidget {
  @override
  _LangizaPdfState createState() => _LangizaPdfState();
}

class _LangizaPdfState extends State<LangizakoPdf> {
  List<firebase_storage.Reference> _files = [];

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    final firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('pdfs')
        .listAll();

    setState(() {
      _files = result.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Files')),
      body: _files.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (BuildContext context, int index) {
                final file = _files[index];
                return ListTile(
                  title: Text(file.name),
                  onTap: () => _openPDF(context, file),
                );
              },
            ),
    );
  }

  Future<void> _openPDF(
      BuildContext context, firebase_storage.Reference file) async {
    final String downloadURL = await file.getDownloadURL();
    final PDFDocument document = await PDFDocument.fromURL(downloadURL);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfScreen(document: document)),
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
