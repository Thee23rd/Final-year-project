import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp {
  String firstname;
  String lastName;
  String studentNumber;
  String programme;
  String email;
  String password;

  SignUp(
      {required this.email,
      required this.firstname,
      required this.lastName,
      required this.password,
      required this.programme,
      required this.studentNumber});
      

  Future Register() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    storeData(firstname, lastName, programme, int.parse(studentNumber));
  }

  Future storeData(String firstname, String lastname, String programme,
      int StudentNumber) async {
    await FirebaseFirestore.instance.collection('Credentials').add({
      'firstname': firstname,
      'lastname': lastName,
      'StudentNumber': int.parse(studentNumber),
      'Programme': programme,
    });
  }
}
