import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/view/iewe.dart';
import 'package:repository/view/view.dart';

class UploadPDFz extends StatefulWidget {
  const UploadPDFz({Key? key}) : super(key: key);

  @override
  State<UploadPDFz> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDFz> {
  String? pdfUrl;
  final _formKey = GlobalKey<FormBuilderState>();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future uploadPDF() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    File? file = result?.files.isNotEmpty == true
        ? File(result!.files.first.path!)
        : null;

    if (file != null) {
      // Set metadata for the PDF file
      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'author': _authorController.text,
          'title': _titleController.text,
          'description': _descriptionController.text,
        },
      );

      showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
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

      Navigator.of(this.context).pushReplacement(
        MaterialPageRoute(builder: (context) => LangizaPdf()),
      );
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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                FormBuilderFilePicker(
                  name: 'pdf',
                  decoration: InputDecoration(labelText: 'PDF File'),
                  maxFiles: 1,
                  type: FileType.any,
                  selector: Row(
                    children: <Widget>[
                      Icon(Icons.file_upload),
                      Text('Upload'),
                    ],
                  ),
                  onFileLoading: (val) {
                    print(val);
                  },
                ),
                FormBuilderTextField(
                  name: 'author',
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Author'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'title of Project',
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'description',
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Check if file is selected
                    if (_formKey.currentState!.fields['pdf']!.value != null) {
                      // Validate form fields
                      if (_formKey.currentState!.validate()) {
                        // Request storage permission
                        var status = await Permission.storage.request();
                        if (status.isGranted) {
                          // Upload PDF file to Firebase Storage
                          await uploadPDF();
                        } else {
                          print('Storage Permission Denied');
                        }
                      }
                    } else {
                      print('No PDF File Selected');
                    }
                  },
                  child: const Text('Upload PDF'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}