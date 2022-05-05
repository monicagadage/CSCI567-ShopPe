import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/const/AppColors.dart';
import 'package:signup/reusable_widgets/customButton.dart';
import 'package:signup/reusable_widgets/myTextField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../reusable_widgets/reusable_widgets.dart';
import '../ui/home.dart';
import '../utils/color_utils.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => Home())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "User Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Name", Icons.person_outline, false, _nameController),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.white70,
                    ),
                    hintText: "Date of Birth",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(
                    //   Icons.male,
                    //   color: Colors.white70,
                    // ),
                    hintText: "Gender",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Age", Icons.lock_outlined, true, _ageController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Phone Number ", Icons.person_outline,
                    false, _phoneController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Continue", () {
                  sendUserDataToDB();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home()),
                  );
                }),
              ],
            ),
          ))),
    );
  }

/////////////////////////////////////////////////////////////////////////////////

  //   return MaterialApp(
  //     title: 'Welcome to Flutter',
  //     home: Scaffold(
  //       // body: SafeArea(
  //       body: Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.height,
  //         decoration: BoxDecoration(
  //             gradient: LinearGradient(colors: [
  //           hexStringToColor("CB2B93"),
  //           hexStringToColor("9546C4"),
  //           hexStringToColor("5E61F4")
  //         ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
  //         child: Padding(
  //           padding: EdgeInsets.all(20),
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Text(
  //                   "Submit the form to continue.",
  //                   style:
  //                       TextStyle(fontSize: 22, color: AppColors.deep_orange),
  //                 ),
  //                 Text(
  //                   "We will not share your information with anyone.",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Color(0xFFBBBBBB),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 reusableTextField("Enter Your Name", Icons.person_outline,
  //                     false, _nameController),
  //                 reusableTextField("Enter Your Phone Number",
  //                     Icons.person_outline, false, _phoneController),
  //                 // myTextField(
  //                 //     "enter your name", TextInputType.text, _nameController),
  //                 myTextField("enter your phone number", TextInputType.number,
  //                     _phoneController),
  //                 TextField(
  //                   controller: _dobController,
  //                   readOnly: true,
  //                   decoration: InputDecoration(
  //                     hintText: "date of birth",
  //                     suffixIcon: IconButton(
  //                       onPressed: () => _selectDateFromPicker(context),
  //                       icon: Icon(Icons.calendar_today_outlined),
  //                     ),
  //                   ),
  //                 ),
  //                 TextField(
  //                   controller: _genderController,
  //                   readOnly: true,
  //                   decoration: InputDecoration(
  //                     hintText: "choose your gender",
  //                     prefixIcon: DropdownButton<String>(
  //                       items: gender.map((String value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value,
  //                           child: new Text(value),
  //                           onTap: () {
  //                             setState(() {
  //                               _genderController.text = value;
  //                             });
  //                           },
  //                         );
  //                       }).toList(),
  //                       onChanged: (_) {},
  //                     ),
  //                   ),
  //                 ),
  //                 myTextField(
  //                     "enter your age", TextInputType.number, _ageController),

  //                 SizedBox(
  //                   height: 50,
  //                 ),

  //                 ElevatedButton(
  //                   child: const Text('Continue'),
  //                   onPressed: () {
  //                     sendUserDataToDB();
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => BottomNavController()),
  //                     );
  //                   },
  //                 )
  //                 //  elevated button
  //                 // customButton("Continue", sendUserDataToDB()),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
