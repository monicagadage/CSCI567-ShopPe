// ignore_for_file: deprecated_member_use

// import 'dart:html';

import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/extra/card_type.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:signup/screens/bottom_nav_controller.dart';
import 'package:signup/ui/payment/paymentDetails.dart';
import 'package:signup/ui/profile/components/body.dart';
import 'package:signup/utils/color_utils.dart';

import '../main.dart';

class OrderPayment extends StatefulWidget {
  String Address, Apt, City, State, PinCode, date;
  var uuid;
  double totalprice;
  List cart_items;

  OrderPayment(this.uuid, this.Address, this.City, this.Apt, this.PinCode,
      this.State, this.date, this.totalprice, this.cart_items);

  @override
  _OrderPayment createState() => _OrderPayment();
}

class StickyLabel extends StatelessWidget {
  final String text;
  final Color textColor;
  StickyLabel({
    Key? key,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 24.0,
        top: 16,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class _OrderPayment extends State<OrderPayment> {
  _removefromCart() async {
    // return doNothing;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    for (int i = 0; i < widget.cart_items.length; i++) {
      final s = widget.cart_items[i]["location"].split('/');

      var docref =
          await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
      Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

      print("${allData} string string ${s[1]}");

      var isliked = allData[currentUser!.email.toString()]["isliked"];
      var favorite_reference =
          allData[currentUser.email.toString()]["favorite-reference"];
      var reference = allData[currentUser.email.toString()]['cart-reference'];

      FirebaseFirestore.instance.collection(s[1]).doc(s[2]).set(
        {
          currentUser.email.toString(): {
            'isliked': isliked,
            'favorite-reference': favorite_reference,
            'cart': false,
            'cart-reference': "",
            "quantity": 0
          }
        },
        SetOptions(merge: true),
      ).then((value) => print("updated the item item item item"));

      CollectionReference _collectionRef =
          FirebaseFirestore.instance.collection("users-cart-items");
      _collectionRef
          .doc(currentUser.email)
          .collection("items")
          .doc(reference)
          .delete()
          .then((value) => print("Removed from cart"));
    }
  }

  sendUserCardDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Order_details");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("Orders")
        .doc(widget.date + "-" + widget.uuid)
        .set({
          "orderid": widget.uuid,
          "Address": widget.Address,
          "Apt": widget.Apt,
          "City": widget.City,
          "State": widget.State,
          "PinCode": widget.PinCode,
          "date": widget.date,
          "CardNumber": cardNumber,
          "BankName": bankName,
          "totalprice": widget.totalprice,
          "Items": widget.cart_items
        })
        .then((value) => showToast("Address Saved"))
        // .then((value) => Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => ProfileBody())))
        .catchError((error) => print("something is wrong. $error"));
  }

  showToast(String textmessage) {
    // var textmessage2 = this.textmessage;
    Fluttertoast.showToast(
      msg: textmessage,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void initState() {
    super.initState();
    fetch_card();
  }

  void showNotification() {
    setState(() {
      // _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "ShopPe ",
        "Order Placed",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  late String cardNumber = "",
      cardExpiry = "",
      cardHolderName = "",
      bankName = "",
      cvv = "";
  List card_items = [];
  fetch_card() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    DocumentSnapshot<Map<String, dynamic>> qn = await _firestoreInstance
        .collection("payment")
        .doc(currentUser!.email)
        .get();

    setState(() {
      // for (int i = 0; i < qn.docs.length; i++) {
      cardNumber = qn['cardNumber'];
      cardExpiry = qn['cardExpiry'];
      cardHolderName = qn['cardHolderName'];
      bankName = qn['bankName'];
      cvv = qn['cvv'];
      print("cardNumber ${cardNumber}");
    });

    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          " Saved Payment",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: cardExpiry,
              cardHolderName: cardHolderName,
              bankName: bankName,
              cvv: cvv,
              // showBackSide: true,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              cardType: CardType.masterCard,
              showShadow: true,
            ),
            StickyLabel(
              text: "Card Information",
              textColor: Colors.black,
            ),
            SizedBox(height: 8.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Perosnal Card",
                            style: TextStyle(fontSize: 18.0)),
                        Container(
                            width: 60.0,
                            child: Icon(Icons.payment,
                                color: Color(0xFFFF8084), size: 40.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card Number",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              cardNumber,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Container(
                          width: 45.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Exp.",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                cardExpiry,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card Name",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              cardHolderName,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Container(
                          width: 45.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CVV",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                cvv,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48.0,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      color: Color.fromARGB(255, 44, 34, 34).withOpacity(0.2),
                      child: Text(
                        "Edit Detail",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () => print("Edit"),
                      // {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           content: Stack(
                      //             overflow: Overflow.visible,
                      //             children: <Widget>[
                      //               Positioned(
                      //                 right: -40.0,
                      //                 top: -40.0,
                      //                 child: InkResponse(
                      //                   onTap: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: CircleAvatar(
                      //                     child: Icon(Icons.close),
                      //                     backgroundColor: Colors.red,
                      //                   ),
                      //                 ),
                      //               ),
                      //               Form(
                      //                 // key: _formKey,
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: <Widget>[
                      //                     Text("data"),
                      //                     Padding(
                      //                       padding: EdgeInsets.all(8.0),
                      //                       child: Text("Enter Cvv"),
                      //                     ),
                      //                     Padding(
                      //                       padding: EdgeInsets.all(8.0),
                      //                       child: TextFormField(),
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.all(8.0),
                      //                       child: RaisedButton(
                      //                         child: Text("Submit"),
                      //                         onPressed: () {
                      //                           // if (_formKey.currentState!.validate()) {
                      //                           //   _formKey.currentState!.save();
                      //                           // }
                      //                         },
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       });
                      // },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            firebaseUIButton(context, "Pay", () {
              sendUserCardDataToDB();
              showNotification();
              _removefromCart();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavController()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
