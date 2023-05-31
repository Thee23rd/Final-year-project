import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repository/Explore/threadlist.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Profile.dart/profle.dart';
import 'package:repository/view/MyFiles.dart';
import '../view/viewed.dart';

class UploadPDFz extends StatefulWidget {
  const UploadPDFz({Key? key}) : super(key: key);

  @override
  State<UploadPDFz> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDFz> {
  String? pdfUrl;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedFolder;
  String? selectedSchool;
  String? selectedDepartment;
  bool isUploading = false;
  double _uploadProgress = 0.0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // add _uploadProgress here

  DateTime? selectedDate; // Track the selected date

  Future<void> uploadPDF(String selectedSchool, String selectedDepartment,
      BuildContext context) async {
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
          'user': FirebaseAuth.instance.currentUser!.uid,
          'author': _authorController.text,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'School': selectedSchool,
          'Department': selectedDepartment,
          'date': selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              : '',
        },
      );

      // Upload the PDF file to Firebase Storage
      final uploadTask = _firebaseStorage
          .ref()
          .child(
              'pdfs/$selectedSchool/$selectedDepartment/${basename(file.path)}')
          .putFile(file, metadata);

      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {},
          onError: (error) {
        print(error.toString());
      }, onDone: () async {
        final downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          FirebaseFirestore.instance
              .collection('users')
              .where('Userid',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((snapshot) => snapshot.docs.forEach((documentSnapshot) {
                    documentSnapshot.reference.update({'pdfUrl': downloadUrl});
                  }));
        });

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

  void showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File uploaded'),
          content: const Text('Your PDF file has been uploaded.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => LangizakoPdfmy()),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool _isLoading = false;

  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload PDF'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                    FormBuilderDateTimePicker(
                      name: 'date',
                      inputType: InputType.date,
                      format: DateFormat('yyyy-MM-dd'),
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      validator: FormBuilderValidators.required(),
                      onChanged: (DateTime? value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
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
                          selectedSchool = value;
                          selectedDepartment =
                              value; // reset selectedDepartment when school changes
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    if (selectedSchool != null)
                      FormBuilderDropdown(
                        name: 'department',
                        decoration: InputDecoration(
                          labelText: 'Department',
                        ),
                        validator: FormBuilderValidators.required(),
                        items: _getDepartmentItems(selectedSchool!).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartment = value;
                          });
                        },
                      ),
                    const SizedBox(height: 20),
                    ScaffoldMessenger(
                        key: scaffoldMessengerKey,
                        child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    // Check if file is selected
                                    if (_formKey.currentState!.fields['pdf']!
                                            .value !=
                                        null) {
                                      // Trigger field validation
                                      _formKey.currentState!.save();

                                      // Validate form fields
                                      if (_formKey.currentState!.validate()) {
                                        // Request storage permission
                                        var status =
                                            await Permission.storage.request();
                                        if (status.isGranted) {
                                          // Display loading feedback
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                    children: [
                                                      const CircularProgressIndicator(),
                                                      const SizedBox(
                                                          width: 16.0),
                                                      const Text(
                                                          'Uploading PDF...'),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );

                                          // Upload PDF file to Firebase Storage
                                          await uploadPDF(selectedSchool!,
                                              selectedDepartment!, context);
                                          Navigator.pop(context);
                                          showUploadDialog(context);
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
                        ))
                  ],
                ),
              ),
            ),
          );
        }),
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
                        builder: ((context) => LangizakoPdfmy())));
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => UploadPDFz())));
                }),
                child: Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                ),
              ),
              label: ("Upload"),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ThreadListPage())));
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => PersonalPage())));
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
        ));
  }
}

Iterable<DropdownMenuItem<String>> _getDepartmentItems(String school) sync* {
  switch (school) {
    case 'School of Agriculture':
      yield* const [
        DropdownMenuItem(
          value: 'Department of Agriculture',
          child: Text('Department of Agriculture'),
        ),
        DropdownMenuItem(
          value: 'Department of Natural Resources',
          child: Text('Department of Natural Resources'),
        ),
        DropdownMenuItem(
          value: 'Department of Disaster Management Studies',
          child: Text('Department aof Disaster Management Studies'),
        ),
      ];
      break;
    case 'School of Business Studies':
      yield* const [
        DropdownMenuItem(
          value: 'Department of Business',
          child: Text('Department of Business'),
        ),
        DropdownMenuItem(
          value: 'Department of Law and Human Resource',
          child: Text('Department of Law and Human Resource'),
        ),
      ];
      break;
    // Add cases for other schools
    case 'School of Engineering and Technology':
      yield* const [
        DropdownMenuItem(
          value: 'Department of Engineering',
          child: Text('Department of Engineering'),
        ),
        DropdownMenuItem(
          value: 'Department of computer Science and IT',
          child: Text('Department of computer Science and IT'),
        ),
      ];
      break;
    case 'School of Medicine and Health Science':
      yield* const [
        DropdownMenuItem(
          value: 'Anatomy Department',
          child: Text('Anatomy Department'),
        ),
        DropdownMenuItem(
          value: 'Basic Science Department',
          child: Text('Basic Science Department'),
        ),
        DropdownMenuItem(
          value: 'Pharmachology Department',
          child: Text('Pharmachology Department'),
        ),
      ];
      break;
    case 'School of Education':
      yield* const [
        DropdownMenuItem(
          value: 'LSNSE Department',
          child: Text('LSNSE Department'),
        ),
        DropdownMenuItem(
          value: 'Education & Business Studies',
          child: Text('Education & Business Studies'),
        ),
      ];
      break;
    case 'School of Directorate of Research and Post Graduate Studies':
      yield* const [
        DropdownMenuItem(
          value: 'SET Directorate of Research and Post Graduate Studies',
          child: Text('SET Directorate of Research and Post Graduate Studies'),
        ),
        DropdownMenuItem(
          value: 'SS Directorate of Research and Post Graduate Studies',
          child: Text('SS Directorate of Research and Post Graduate Studies'),
        ),
        DropdownMenuItem(
          value: 'SOB Directorate of Research and Post Graduate Studies',
          child: Text('SOB Directorate of Research and Post Graduate Studies'),
        ),
        DropdownMenuItem(
          value: 'SOE Directorate of Research and Post Graduate Studies',
          child: Text('SOE Directorate of Research and Post Graduate Studies'),
        ),
      ];
      break;
    case 'School of Social Science':
      yield* const [
        DropdownMenuItem(
          value: 'Department of Economics',
          child: Text('Department of Economics'),
        ),
        DropdownMenuItem(
          value: 'Department of Social Development Studies',
          child: Text('Department of Social Development Studies'),
        ),
        DropdownMenuItem(
          value: 'Department of Public Admin & International Relations',
          child: Text('Department of Public Admin & International Relations'),
        ),
      ];
      break;
    case 'School of Natural and Applied Science':
      yield* const [
        DropdownMenuItem(
          value: 'Physics',
          child: Text('Physics'),
        ),
        DropdownMenuItem(
          value: 'Biochemistry',
          child: Text('Biochemistry'),
        ),
      ];
      break;
  }
}
