// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup/reusable_widgets/customButton.dart';
import 'package:signup/reusable_widgets/myTextField.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          // title: const Text('User Details'),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: Text(
            "User Details",
            style: TextStyle(color: Colors.black),
          ),
          titleSpacing: 150,
        ),
        // body: const Center(
        //   child: Text('Profile'),

        // ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-form-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return setDataToTextField(data);
            },
          ),
        )),
      ),
    );
  }

  setDataToTextField(data) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            controller: _nameController =
                TextEditingController(text: data['name']),
            autofocus: false,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none, labelText: "Name",
              // hintText: 'Username',
              filled: true,
              fillColor: Color.fromARGB(255, 216, 208, 208),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            alignment: const Alignment(0, 0),
            children: <Widget>[
              TextFormField(
                controller: _phoneController =
                    TextEditingController(text: data['phone']),
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none, labelText: "Phone",
                  // hintText: 'Username',
                  filled: true,
                  fillColor: Color.fromARGB(255, 216, 208, 208),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              //   Positioned(
              //       right: 15,
              //       child: Container(
              //           width: 65,
              //           height: 30,
              //           child: RaisedButton(
              //               onPressed: () {
              //                 // _controller.clear();
              //               },
              //               child: Text(
              //                 'SHOW',
              //                 style: TextStyle(fontSize: 8),
              //               ))))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            controller: _ageController =
                TextEditingController(text: data['age']),
            autofocus: false,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none, labelText: "Age",
              // hintText: 'Username',
              filled: true,
              fillColor: Color.fromARGB(255, 216, 208, 208),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => updateData(),
                  child: Text("Update"),
                ))),
      ],

      // children: [
      //   TextFormField(
      //     controller: _nameController =
      //         TextEditingController(text: data['name']),
      //   ),
      //   TextFormField(
      //     controller: _phoneController =
      //         TextEditingController(text: data['phone']),
      //   ),
      //   TextFormField(
      //     controller: _ageController = TextEditingController(text: data['age']),
      //   ),
      //   ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
      // ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
    }).then((value) => showToast());
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "Details Updated",
        toastLength: Toast.LENGTH_LONG,
        // gravity: ToastGravity.CENTER,
        gravity: ToastGravity.CENTER);
  }

  showCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Text("Details Updated"),
    );

    fToast!.showToast(
      child: toast,
      toastDuration: Duration(seconds: 3),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //         child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: StreamBuilder(
  //         stream: FirebaseFirestore.instance
  //             .collection("users-form-data")
  //             .doc(FirebaseAuth.instance.currentUser!.email)
  //             .snapshots(),
  //         builder: (BuildContext context, AsyncSnapshot snapshot) {
  //           var data = snapshot.data;
  //           if (data == null) {
  //             return Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //           return setDataToTextField(data);
  //         },
  //       ),
  //     )),
  //   );
  // }
}
