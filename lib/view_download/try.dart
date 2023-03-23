import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPDFs extends StatefulWidget {
  const UploadPDFs({Key? key}) : super(key: key);

  @override
  State<UploadPDFs> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDFs> {
  String? pdfUrl;

  Future uploadPDF() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    File? file = result?.files.isNotEmpty == true
        ? File(result!.files.first.path!)
        : null;

    print(file);

    if (file != null) {
      // Set metadata for the PDF file
      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'author': 'John Doe',
          'title': 'Sample PDF',
          'description': 'This is a sample PDF file'
        },
      );

      // Upload the PDF file to Firebase Storage
      final uploadTask = _firebaseStorage
          .ref()
          .child('pdfs/${basename(file.path)}')
          .putFile(file, metadata);

      // Get the download URL of the uploaded PDF file
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        pdfUrl = downloadUrl;
        FirebaseFirestore.instance
            .collection('users')
            .where('Userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((snapshot) => snapshot.docs.forEach((documentSnapshot) {
                  documentSnapshot.reference.update({'pdfUrl': pdfUrl});
                }));
      });
    } else {
      print('No PDF File Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload PDF'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            pdfUrl != null
                ? Text(
                    'PDF file uploaded successfully!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadPDF();
              },
              child: const Text(
                'Upload PDF',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Save and Exit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
