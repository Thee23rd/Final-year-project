import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class PDFList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF List'),
      ),
      body: FutureBuilder<ListResult>(
        future: FirebaseStorage.instance.ref('pdfs/').listAll(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pdfDocuments = snapshot.data!.items;
          return ListView.builder(
            itemCount: snapshot.data!.items.length,
            itemBuilder: (context, index) {
              final pdfDocument = pdfDocuments[index];
              final pdfUrl = pdfDocument.getDownloadURL();
              final pdfMetadata = pdfDocument.getMetadata();

              return FutureBuilder<File>(
                future: _downloadPDFFile(pdfUrl, pdfMetadata['title']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final file = snapshot.data!;
                    return ListTile(
                      title: Text(pdfMetadata['title']),
                      subtitle: Text(pdfMetadata['author']),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return PDFView(
                            filePath: file.path,
                            enableSwipe: true,
                          );
                        }));
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<File> _downloadPDFFile(String pdfUrl, String title) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$title.pdf').create();
      final downloadUrl = Uri.parse(pdfUrl);
      final response = await http.get(downloadUrl);
      final bytes = response.bodyBytes;
      await file.writeAsBytes(bytes);
      return file;
    } else {
      print('Storage Permission Denied');
      throw Exception('Storage Permission Denied');
    }
  }
}
