// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:signup/ui/orders_payment.dart';
import 'package:signup/ui/payment/paymentDetails.dart';
import 'package:signup/ui/profile/components/body.dart';
import 'package:signup/utils/color_utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OrderDetails extends StatefulWidget {
  double total;
  List cart_items;

  OrderDetails(this.total, this.cart_items);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController _Address = TextEditingController();
  TextEditingController _Apt = TextEditingController();
  TextEditingController _City = TextEditingController();
  TextEditingController _State = TextEditingController();
  TextEditingController _PinCode = TextEditingController();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatteddate = formatter.format(now);

  // Create uuid object
  var uuid = Uuid().v4();

  // FToast? fToast;

  @override
  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast.init(context);
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "Address Saved",
        toastLength: Toast.LENGTH_LONG,
        // gravity: ToastGravity.CENTER,
        gravity: ToastGravity.CENTER);
  }

  // showCustomToast() {
  //   Widget toast = Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25.0),
  //       color: Colors.greenAccent,
  //     ),
  //     child: Text("Address Added"),
  //   );

  //   fToast!.showToast(
  //     child: toast,
  //     toastDuration: Duration(seconds: 3),
  //   );
  // }

  // sendUserDataToDB() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   var currentUser = _auth.currentUser;

  //   CollectionReference _collectionRef =
  //       FirebaseFirestore.instance.collection("Order_details");
  //   return _collectionRef
  //       .doc(currentUser!.email)
  //       .set({
  //         "orderid": uuid,
  //         "Address": _Address.text,
  //         "Apt": _Apt.text,
  //         "City": _City.text,
  //         "State": _State.text,
  //         "PinCode": _PinCode.text,
  //         "date": formatteddate,
  //       })
  //       .then((value) => showToast())
  //       // .then((value) => Navigator.push(
  //       //     context, MaterialPageRoute(builder: (_) => ProfileBody())))
  //       .catchError((error) => print("something is wrong. $error"));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Order Details",
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
                    "Address 1", Icons.lock_outlined, false, _Address),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Apt", Icons.person_outline, false, _Apt),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("City", Icons.person_outline, false, _City),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("State", Icons.security, false, _State),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Pin Code", Icons.security, false, _PinCode),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Continue", () {
                  // sendUserDataToDB();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderPayment(
                              uuid,
                              _Address.text,
                              _City.text,
                              _Apt.text,
                              _PinCode.text,
                              _State.text,
                              formatteddate,
                              widget.total,
                              widget.cart_items,
                            )),
                  );
                }),
              ],
            ),
          ))),
    );
  }
}
