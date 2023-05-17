import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp {
  String firstname;
  String lastName;
  String studentNumber;
  String programme;
  String email;
  String password;

  SignUp({
    required this.email,
    required this.firstname,
    required this.lastName,
    required this.password,
    required this.programme,
    required this.studentNumber,
  });

  Future<void> Register() async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await storeData(
      userCredential.user!.uid,
      firstname,
      lastName,
      programme,
      int.parse(studentNumber),
    );
  }

  Future<void> storeData(
    String userId,
    String firstname,
    String lastname,
    String programme,
    int studentNumber,
  ) async {
    await FirebaseFirestore.instance.collection('Credentials').doc(userId).set({
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'StudentNumber': studentNumber,
      'Programme': programme,
    });
  }
}
