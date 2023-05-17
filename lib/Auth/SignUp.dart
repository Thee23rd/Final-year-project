import 'package:drop_down_list/model/selected_list_item.dart';

import 'package:flutter/material.dart';
import 'package:repository/Auth/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:repository/Home/Home.dart';
import 'package:repository/Auth/sign_up.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaSignUp();
}

class PaSignUp extends State<SignUpPage> {
  final FirstNameController = TextEditingController();
  final LastNameController = TextEditingController();
  final StudentNumController = TextEditingController();
  final programController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  List<String> programs = <String>[
    "Select Programme",
    "Bachelor of Science (BSc) in Agriculture",
    "Bachelor of Science (BSc) in Agronomy",
    "Bachelor of Science (BSc) Agricultural Business Management",
    "Bachelor of Science (BSc) in Agricultural Economics",
    "Bachelor of Science (BSc) in Land and Water Resources Management",
    "Bachelor of Science (BSc) in Environmental Studies",
    "Bachelor of Science (BSc) in Natural Resources Management",
    "Bachelor of Science (BSc) in Climatology and Environmental Management",
    "Bachelor of Science (BSc) in Hydrology and Earth System Science",
    "Bachelor of Laws (LLB)",
    "Bachelor of Human Resource Management (BHRM)",
    "Bachelor of Labour and Employment Relations (BLER)",
    "Bachelor of Arts in Labour and Human Resource Management (BALHRM)",
    "Bachelor of Arts in Criminology and Criminal Justice (BACCJ)",
    "Bachelor of Arts in Security Studies (BASS)",
    "Bachelor of Law in Labour Studies (LLBLS)",
    "Bachelor of Business Administration and Marketing",
    "Bachelor of Business Administration with Marketing",
    "Bachelor of Marketing",
    "Bachelor of Arts in Communications",
    "Public Relations (BComPR)",
    "Journalism (BCoMJm)",
    "Bachelor of Commerce (BCom) in Accounting and Finance",
    "Bachelor of Commerce (BCom) in Marketing",
    "Bachelor of Commerce (BCom) Business Management",
    "Bachelor of Commerce (BCom) in Economics",
    "Bachelor of Business Administration and Entrepreneurship (BBAE)",
    "Bachelor of Banking and Finance (BBF)",
    "Bachelor of Accounting and Finance (BAF)",
    "Bachelor of Purchasing and Supply Management (BPSM)",
    "Bachelor of Engineering in Industrial Engineering (in conjunction with Evelyn Hone College)",
    "Bachelor of Science in International Business",
    "Professional Diploma in Programme Planning, Monitoring and Evaluation ",
    "Bachelor Science (BSc) in ICT with Education",
    "Bachelor of Science (BSc) in Mathematics with Education",
    "Bachelor of Science (BSc) in Agriculture with Education",
    "Bachelor of Science (BSc) in Mathematics and ICT with Education ",
    "Bachelor of Science with Education (BSc ED) in Biology and Chemistry",
    "Bachelor of Science with Education (BSc ED) in Biology and Physics",
    "Bachelor of Science with Education (BSc ED) in Biology and Mathematics",
    "Bachelor of Science with Education (BSc ED) in Physics and Chemistry",
    "Bachelor of Science with Education (BSc ED) in Physics and Biology",
    "Bachelor of Science with Education (BSc ED) in Physics and Mathematics",
    "Bachelor of Science with Education (BSc ED) in Mathematics and Chemistry",
    "Bachelor of Science with Education (BSc ED) in Mathematics and Biology",
    "Bachelor of Arts with Education (BA ED) in English Language and Zambian languages",
    "Bachelor of Arts with Education (BA ED) in English Language and French",
    "Bachelor of Arts with Education (BA ED) in English Language and Chinese",
    "Bachelor of Arts with Education (BA ED) in English Language and Civic Education",
    "Bachelor of Arts with Education (BA ED) in English Language and Religious Studies",
    "Bachelor of Arts with Education (BA ED) in English Language and Physical Education and Sports (PES)",
    "Bachelor of Arts with Education (BA ED) in English Language and Histroy",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and French",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Chinese",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Civic Education",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Religious Studies",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Physical Education and Sports (PES)",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Histroy",
    "Bachelor of Arts with Education (BA ED) in Zambia languages and Physical Education and Sports (PES)",
    "Bachelor of Arts with Education (BA ED) in Geography Bachelor of Primary Education",
    "Bachelor of Business Studies with Education (BBSED)",
    "Bachelor of Business Administration &Entrepreneurship with Education (BBAE ED)",
    "Bachelor of Medicine and Bachelor of Surgery (MBChB)",
    "Bachelor of Pharmacy",
    "Bachelor of Science in Biomedical Sciences",
    "Bachelor of Science in Nursing (Full-time and Distance)",
    "Abridged Diploma in Nursing (Registered Nursing)",
    "Bachelor of Science (BSc) in Computer Science",
    "Bachelor of Science (BSc) in Information Technology",
    "Bachelor of Science in Information Systems",
    "Bachelor of Business Informatics",
    "Bachelor of Science in Data Science",
    "Bachelor of Science in Cyber Security",
    "Bachelor of Science (BSc) in Statistics",
    "Bachelor of Science (BSc) in Mathematics and Statistics",
    "Bachelor of Science (BSc) in Biological Sciences",
    "Bachelor of Science (BSc) in Chemistry",
    "Bachelor of Science (BSc) in Bio-Chemistry",
    "Bachelor of Science (BSc) in Physics",
    "Bachelor of Science (BSc) in Medical Physics",
    "Bachelor of Science in Laboratory Technology",
    "Biological Sciences in Electronics and Instrumentation)",
    "Bachelor of Science in Actuarial Science",
    "Bachelor of Science in Biotechnology",
    "Bachelor of Engineering (BEng) Civil Engineering",
    "Bachelor of Engineering (BEng) Electronics and Electrical Engineering (specializations: Control Systems; Energy Systems; Communication and Network Systems)",
    "Bachelor of Engineering (BEng) Mechanical Engineering",
    "Bachelor of Engineering (BEng) Agricultural Engineering",
    "Bachelor of Engineering (BEng) - Geomatics Engineering",
    "Bachelor of Science (BSc) in Economics and Statistics",
    "Bachelor Arts (BA) in Economics",
    "Bachelor of Industrial Psychology",
    "Bachelor of Development Studies",
    "Bachelor of Social Work",
    "Bachelor of Psychology ",
    "Bachelor of International Relations and Development",
    "Bachelor of Local Government Administration",
    "Bachelor of Public Administration",
    "Bachelor of Arts in Development Planning",
    "Bachelor of Arts in Governance and Development",
    "Bachelor of Arts in Local Government Finance ",
  ];
  String dropdownValue = "Select Programme";

  @override
  Widget build(BuildContextcontext) {
    return Ngena();
  }

  Widget Ngena() {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Colors.blue,
                gradient: LinearGradient(
                    colors: [(Colors.blue), (Colors.blue)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      child: Image.asset(
                        'assets/images/MU_Logo.jpg',
                        height: 90,
                        width: 90,
                      )),
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20),
                    alignment: Alignment.bottomRight,
                    child: Text("SignUp",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 50),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextField(
              controller: FirstNameController,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                hintText: "First Name",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextField(
              controller: LastNameController,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                hintText: "Last Name",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextField(
              controller: StudentNumController,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.numbers,
                  color: Colors.black,
                ),
                hintText: "Student Number",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              items: programs.map<DropdownMenuItem<String>>((String program) {
                return DropdownMenuItem<String>(
                  value: program,
                  child: Text(program),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  programController.text = newValue;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextFormField(
              controller: emailController,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                labelText: 'Email',
                hintText: "TheeDee@gmail.com",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextField(
              controller: phoneController,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                hintText: "Phone Number",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 12), blurRadius: 70, color: Colors.grey)
                ]),
            alignment: Alignment.center,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.vpn_key,
                  color: Colors.black,
                ),
                hintText: "password",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, right: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [(Colors.blue), Colors.blue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(),
            onPressed: () {
              String password = passwordController.text.trim();
              if (password.length < 8) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password is too short.'),
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }
              if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                  .hasMatch(password)) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password is too weak.'),
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }
              SignUp signup = SignUp(
                  email: emailController.text.trim(),
                  firstname: FirstNameController.text.trim(),
                  lastName: LastNameController.text.trim(),
                  password: passwordController.text.trim(),
                  programme: programController.text.trim(),
                  studentNumber: StudentNumController.text.trim());
              signup.Register();

              // Display a message to the user after signup is successful
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('New user created.'),
                  duration: Duration(seconds: 3),
                ),
              );
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              height: 50,
              width: 200,
              child: Center(
                child: Text(
                  "SignUp",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account"),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                  },
                  child: Text(
                    "Login Here",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
