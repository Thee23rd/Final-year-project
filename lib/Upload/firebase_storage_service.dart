import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> uploadPdfFile(
  File file,
  String name,
  String author,
  String topic,
  String fieldOfResearch,
) async {
  // Create a reference to the location where you want to upload the file
  final _firebaseStorage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  File? file =
      result?.files.isNotEmpty == true ? File(result!.files.first.path!) : null;

  print(file);

  // Create metadata for the file
  final metadata = SettableMetadata(
    contentType: 'application/pdf',
    customMetadata: {
      'author': author,
      'topic': topic,
      'field_of_research': fieldOfResearch,
    },
  );

  // Upload the file to Firebase Storage
  final uploadTask = _firebaseStorage
      .ref()
      .child('pdfs/${basename(file!.path)}')
      .putFile(file, metadata);

  // Wait for the upload to complete
  final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() {});

  // Return the download URL of the uploaded file
  final String url = await downloadUrl.ref.getDownloadURL();
  return url;
}
