// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:repository/Upload/firebase_storage_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload file'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey1,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: FormBuilderValidators.required(),
                      ),
                      FormBuilderTextField(
                        name: 'author',
                        decoration: InputDecoration(labelText: 'Author'),
                        validator: FormBuilderValidators.required(),
                      ),
                      FormBuilderTextField(
                        name: 'topic',
                        decoration: InputDecoration(labelText: 'Topic'),
                        validator: FormBuilderValidators.required(),
                      ),
                      FormBuilderTextField(
                        name: 'field',
                        decoration:
                            InputDecoration(labelText: 'Field of Research'),
                        validator: FormBuilderValidators.required(),
                      ),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            final Map<String, dynamic> formData =
                                _formKey.currentState!.value;
                            if (formData.containsKey('pdf_file')) {
                              final File file = formData['pdf_file'][0] as File;
                              final String name = formData['name'] as String;
                              final String author =
                                  formData['author'] as String;
                              final String topic = formData['topic'] as String;
                              final String fieldOfResearch =
                                  formData['field_of_research'] as String;

                              // Call the uploadPdfFile function with the file and metadata
                              uploadPdfFile(
                                  file, name, author, topic, fieldOfResearch);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
