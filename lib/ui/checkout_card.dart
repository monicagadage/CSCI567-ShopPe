// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:signup/ui/order_details.dart';
// // import 'package:signup/ui/settings.dart';

// // // ignore: must_be_immutable
// // class CheckoutCard extends StatefulWidget {
// //   List cart_item;

// //   CheckoutCard(this.cart_item);
// //   @override
// //   _CheckoutCardState createState() => _CheckoutCardState();
// // }

// // class _CheckoutCardState extends State<CheckoutCard> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetch_price();
// //   }

// //   late double totalprice;
// //   List cart_items2 = [];
// //   fetch_price() async {
// //     var _firestoreInstance = FirebaseFirestore.instance;
// //     final FirebaseAuth _auth = FirebaseAuth.instance;
// //     var currentUser = _auth.currentUser;
// //     totalprice = 0;
// //     QuerySnapshot qn = await _firestoreInstance
// //         .collection("users-cart-items")
// //         .doc(currentUser!.email)
// //         .collection("items")
// //         .get();
// //     setState(() {
// //       for (int i = 0; i < qn.docs.length; i++) {
// //         cart_items2.add({
// //           // "name": qn.docs[i]["name"],
// //           "price": qn.docs[i]["price"],
// //           // "img": qn.docs[i]["images"],
// //           "quantity": qn.docs[i]["quantity"],
// //           // "location": qn.docs[i]["reference"]
// //         });
// //         totalprice = totalprice + qn.docs[i]["price"] * qn.docs[i]["quantity"];
// //         // print("cart cart cart cart ${qn.docs[i].reference.path}");
// //       }
// //     });

// //     return totalprice;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(
// //         vertical: 25,
// //         horizontal: 40,
// //       ),
// //       // height: 174,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(30),
// //           topRight: Radius.circular(30),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             offset: Offset(0, -15),
// //             blurRadius: 20,
// //             color: Color(0xFFDADADA).withOpacity(0.15),
// //           )
// //         ],
// //       ),
// //       child: SafeArea(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: EdgeInsets.all(10),
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFFF5F6F9),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   // child: SvgPicture.asset("assets/icons/receipt.svg"),
// //                 ),
// //                 Spacer(),
// //                 Text("Add voucher code"),
// //                 const SizedBox(width: 10),
// //                 Icon(
// //                   Icons.arrow_forward_ios,
// //                   size: 12,
// //                   color: Color(0xFF757575),
// //                 )
// //               ],
// //             ),
// //             SizedBox(height: 20),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text.rich(
// //                   TextSpan(
// //                     text: "Total:\n",
// //                     children: [
// //                       TextSpan(
// //                         text: totalprice.toStringAsFixed(
// //                             totalprice.truncateToDouble() == totalprice
// //                                 ? 0
// //                                 : 2),
// //                         style: TextStyle(fontSize: 16, color: Colors.black),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   width: 190,
// //                   child: SizedBox(
// //                     width: double.infinity,
// //                     height: (56),
// //                     child: TextButton(
// //                       style: TextButton.styleFrom(
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(20)),
// //                         primary: Colors.white,
// //                         backgroundColor: Color(0xFFFF7643),
// //                       ),
// //                       onPressed: () {
// //                         Navigator.push(context,
// //                             CupertinoPageRoute(builder: (_) => OrderDetails()));
// //                       },
// //                       child: Text(
// //                         "Check Out",
// //                         style: TextStyle(
// //                           fontSize: (18),
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// //////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:signup/ui/order_details.dart';
// import 'package:signup/ui/payment/payment.dart';

// class CheckoutCard extends StatefulWidget {
//   double total;
//   List cart_items;

//   CheckoutCard(this.total, this.cart_items);
//   @override
//   _CheckoutCardState createState() => _CheckoutCardState();
// }

// class _CheckoutCardState extends State<CheckoutCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: 25,
//         horizontal: 40,
//       ),
//       // height: 174,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -15),
//             blurRadius: 20,
//             color: Color(0xFFDADADA).withOpacity(0.15),
//           )
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF5F6F9),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   // child: SvgPicture.asset("assets/icons/receipt.svg"),
//                 ),
//                 Spacer(),
//                 Text("Add voucher code"),
//                 const SizedBox(width: 10),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 12,
//                   color: Color(0xFF757575),
//                 )
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                     text: "Total:\n",
//                     children: [
//                       TextSpan(
//                         text: "\$${widget.total.toStringAsFixed(2)}",
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 190,
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: (56),
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         primary: Colors.white,
//                         backgroundColor: Color(0xFFFF7643),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             CupertinoPageRoute(
//                                 builder: (_) => OrderDetails(
//                                     widget.total, widget.cart_items)));
//                       },
//                       child: Text(
//                         "Check Out",
//                         style: TextStyle(
//                           fontSize: (18),
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

////////////////////////
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/ui/order_details.dart';

class CheckoutCard extends StatefulWidget {
  double total;
  List cart_items;

  CheckoutCard(this.total, this.cart_items);

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 40,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF757575),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$${widget.total.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: SizedBox(
                    width: double.infinity,
                    height: (56),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        primary: Colors.white,
                        backgroundColor: Color(0xFFFF7643),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => OrderDetails(
                                    widget.total, widget.cart_items)));
                      },
                      child: Text(
                        "Check Out",
                        style: TextStyle(
                          fontSize: (18),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
