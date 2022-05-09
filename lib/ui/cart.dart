// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/ui/checkout_card.dart';
// import 'package:flutter_ecommerce/widgets/fetchProducts.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    fetch_cart();
  }

  List cart_items = [];
  fetch_cart() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    QuerySnapshot qn = await _firestoreInstance
        .collection("users-cart-items")
        .doc(currentUser!.email)
        .collection("items")
        .get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        cart_items.add({
          "name": qn.docs[i]["name"],
          "price": qn.docs[i]["price"],
          "img": qn.docs[i]["images"],
          "quantity": qn.docs[i]["quantity"],
          "location": qn.docs[i]["reference"]
        });
        print("cart cart cart cart ${qn.docs[i].reference.path}");
      }
    });

    return qn.docs;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${cart_items.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(cart_items),
      bottomNavigationBar: CheckoutCard(cart_items),
    );
    // ),
  }
}

class Body extends StatefulWidget {
  List cart_item;
  Body(this.cart_item);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Future removefromFavourite(String docId) async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  //   DocumentReference docRef = await FirebaseFirestore.instance.doc(docId);     //.get() as DocumentReference<Object?>;
  //   Map<String, dynamic> pro =  await docRef.get() as Map<String, dynamic>;
  //   print(docRef);
  //
  //   var reference = pro['favorite-reference'];
  //
  //   print("${reference} 111111111111111");
  //
  //   docRef.update({
  //     "favorite-reference": "",
  //     "isliked": false,
  //   });
  //
  //
  //   var currentUser = _auth.currentUser;
  //
  //   CollectionReference _collectionRef =
  //   FirebaseFirestore.instance.collection("users-favourite-items");
  //   return _collectionRef
  //       .doc(currentUser!.email)
  //       .collection("items")
  //       .doc(reference)
  //       .delete().then((value) => print("Removed from favourite"));
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 50), // getProportionateScreenWidth(20)
      child: ListView.builder(
        itemCount: widget.cart_item.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(widget.cart_item[index].toString()),
            // direction: DismissDirection.endToStart,
            // onDismissed: (direction) {
            //   setState(() {
            //     widget.cart_item.removeAt(index);
            //   });
            // },
            // background: Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFFFE6E6),
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Row(
            //     children: [
            //       Spacer(),
            //       SvgPicture.asset("assets/Trash.svg"),
            //     ],
            //   ),
            // ),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),

            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to delete ${widget.cart_item[index]["name"]}?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: Delete the item from DB etc..
                              // removefromFavourite(widget.cart_item[index]["location"]);
                              setState(() {
                                widget.cart_item.removeAt(index);
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                return res;
              } else {
                // TODO: Navigate to edit page;
                print("swipe right right right right");
              }
            },

            child: CartCard(widget.cart_item[index]),
          ),
        ),
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  var item;

  CartCard(this.item);

  // final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(20), // getProportionateScreenWidth(10)
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(item['img']),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\$${item['price']}",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                children: [
                  TextSpan(
                      text: " x${item['quantity']}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

// //////////////////////////////////////////////////////////////////////////////////////////////
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../reusable_widgets/fetchProducts.dart';
//
// class Cart extends StatefulWidget {
//   @override
//   _CartState createState() => _CartState();
// }
//
// class _CartState extends State<Cart> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: fetchData("users-cart-items"),
//       ),
//     );
//   }
// }
