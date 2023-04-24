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
import '../view/viewed.dart';

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
  String? selectedFolder;
  bool isUploading = false;
  double _uploadProgress = 0.0; // add _uploadProgress here

  Future<void> uploadPDF(String selectedSchool, BuildContext context) async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    File? file = result?.files.isNotEmpty == true
        ? File(result!.files.first.path!)
        : null;

    if (file != null) {
      // Show a loading indicator while the file is being uploaded
      setState(() {
        isUploading = true;
      });

      // Set metadata for the PDF file
      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'author': _authorController.text,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'School': selectedSchool,
        },
      );

      // Upload the PDF file to Firebase Storage
      final uploadTask = _firebaseStorage
          .ref()
          .child('pdfs/$selectedFolder/${basename(file.path)}')
          .putFile(file, metadata);

      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred /
              snapshot.totalBytes; // update the _uploadProgress variable
        });
      }, onError: (error) {
        print(error.toString());
      }, onDone: () async {
        final downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          pdfUrl = downloadUrl;
          isUploading =
              false; // set isUploading to false after the upload is complete
          _uploadProgress =
              0.0; // reset _uploadProgress after the upload is complete
          FirebaseFirestore.instance
              .collection('users')
              .where('Userid',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((snapshot) => snapshot.docs.forEach((documentSnapshot) {
                    documentSnapshot.reference.update({'pdfUrl': pdfUrl});
                  }));
        });
        // Show a snackbar to inform the user that the upload is complete
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully'),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to another page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LangizakoPdf()),
        );
      });
    } else {
      print('No PDF File Selected');
    }
  }

  int _currentIndex = 0;
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
                FormBuilderDropdown(
                  name: 'school',
                  decoration: InputDecoration(
                    labelText: 'School',
                  ),
                  validator: FormBuilderValidators
                      .required(), // Validate school option
                  items: <String>[
                    'School of Agriculture',
                    'School of Business Studies',
                    'School of Education',
                    'School of Engineering and Technology',
                    'School of Natural and Applied Science',
                    'School of Social Science',
                    'School of Medicine and Health Science',
                    'School of Directorate of Research and Post Graduate Studies',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFolder = value; // Update selectedFolder value
                    });
                    uploadPDF(value!, context);
                  },
                ),
                const SizedBox(height: 20),
                if (isUploading)
                  // Show a loading indicator while the file is being uploaded
                  Center(
                    child: CircularProgressIndicator(
                      value: _uploadProgress,
                    ),
                  ),
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

                          await uploadPDF(String as String, context);
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
                      builder: ((context) => LangizakodPdf())));
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => UploadPDFz())));
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
}
