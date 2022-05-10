import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:signup/ui/payment/paymentDetails.dart';
import 'package:signup/ui/profile/components/body.dart';
import 'package:signup/utils/color_utils.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _cardExpiry = TextEditingController();
  TextEditingController _cardHolderName = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _cvv = TextEditingController();

  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // fToast.init(context);
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
      child: Text("Card Added"),
    );

    fToast!.showToast(
      child: toast,
      toastDuration: Duration(seconds: 3),
    );
  }

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _cardExpiry.text = "${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("payment");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "cardNumber": _cardNumber.text,
          "cardHolderName": _cardHolderName.text,
          "cardExpiry": _cardExpiry.text,
          "bankName": _bankName.text,
          "cvv": _cvv.text,
        })
        .then((value) => showToast())
        // .then((value) => Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => ProfileBody())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add Card",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 37, 26, 138),
            Color.fromARGB(255, 150, 144, 144),
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
                    "Card Number", Icons.lock_outlined, false, _cardNumber),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _cardExpiry,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.white70,
                    ),
                    hintText: "Exp date",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                // TextField(
                //   controller: _bankName,
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     // prefixIcon: Icon(
                //     //   Icons.male,
                //     //   color: Colors.white70,
                //     // ),
                //     hintText: "Bank Name",
                //     hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                //     // prefixIcon: DropdownButton<String>(
                //     //   items: gender.map((String value) {
                //     //     return DropdownMenuItem<String>(
                //     //       value: value,
                //     //       child: new Text(value),
                //     //       onTap: () {
                //     //         setState(() {
                //     //           _genderController.text = value;
                //     //         });
                //     //       },
                //     //     );
                //     //   }).toList(),
                //     //   onChanged: (_) {},
                //     // ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Bank Name", Icons.person_outline, false, _bankName),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Card Holder Name", Icons.person_outline,
                    false, _cardHolderName),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("CVV", Icons.security, false, _cvv),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Save Card", () {
                  sendUserDataToDB();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfileBody()),
                  // );
                }),
              ],
            ),
          ))),
    );
    throw UnimplementedError();
  }
}
