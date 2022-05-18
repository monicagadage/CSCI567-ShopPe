// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ecommerce/widgets/fetchProducts.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:uuid/uuid.dart';

// import '../screens/bottom_nav_controller.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  void initState() {
    super.initState();
    fetch_favorite();
  }

  callback() {
    favorite_items = [];
    fetch_favorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(favorite_items, callback),
      // bottomNavigationBar: BottomNavController("favorite"),
    );
    // ),
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent[200],
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(
            "Favorite Items",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${favorite_items.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  List favorite_items = [];

// var _firestoreInstance = FirebaseFirestore.instance;

  fetch_favorite() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    QuerySnapshot qn = await _firestoreInstance
        .collection("users-favourite-items")
        .doc(currentUser!.email)
        .collection("items")
        .get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        favorite_items.add({
          "name": qn.docs[i]["name"],
          "price": qn.docs[i]["price"],
          "img": qn.docs[i]["images"],
          "location": qn.docs[i]["reference"]
        });
        print(
            "favourite favourite favourite favourite ${qn.docs[i].reference.path}");
      }
    });

    return qn.docs;
  }
}

// ignore: must_be_immutable
class Body extends StatefulWidget {
  List fav_item;
  Function callback;
  Body(this.fav_item, this.callback);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future addToCart(String docId) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    var uuid = Uuid();
    var v1 = uuid.v1();

    final s = docId.split('/');

    var docref =
        await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
    Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

    // print("${allData} string string ${s[1]}");

    var isliked = allData[currentUser!.email.toString()]["isliked"];
    var favorite_reference =
        allData[currentUser.email.toString()]["favorite-reference"];
    var name = allData["name"];
    var price = allData["price"];
    var image = allData["img"];
    var seller = allData["seller-name"];

    if (allData[currentUser.email.toString()]["cart"] == true)
      return Fluttertoast.showToast(msg: 'Already in the cart');

    FirebaseFirestore.instance.collection(s[1]).doc(s[2]).set(
      {
        currentUser.email.toString(): {
          'isliked': isliked,
          'favorite-reference': favorite_reference,
          'cart': true,
          'cart-reference': v1,
          "quantity": 1
        }
      },
      SetOptions(merge: true),
    ).then((value) => print("updated the item item item item"));

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser.email)
        .collection("items")
        .doc(v1)
        .set({
      "name": name,
      "price": price,
      "images": image[0],
      "quantity": 1,
      "reference": docId,
      "seller-name": seller
    }).then((value) => Fluttertoast.showToast(msg: 'Added to cart'));
  }

  Future removefromFavourite(String docId) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    final s = docId.split('/');

    var docref =
        await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
    Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

    // print("${allData} string string ${s[1]}");

    var cart = allData[currentUser!.email.toString()]["cart"];
    var cart_reference =
        allData[currentUser.email.toString()]["cart-reference"];
    var quantity = allData[currentUser.email.toString()]["quantity"];
    var reference = allData[currentUser.email.toString()]['favorite-reference'];

    FirebaseFirestore.instance.collection(s[1]).doc(s[2]).set(
      {
        currentUser.email.toString(): {
          'isliked': false,
          'favorite-reference': "",
          'cart': cart,
          'cart-reference': cart_reference,
          "quantity": quantity
        }
      },
      SetOptions(merge: true),
    ).then((value) => print("updated the item item item item"));

    widget.callback();

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser.email)
        .collection("items")
        .doc(reference)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: "Removed from favourite"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 50), // getProportionateScreenWidth(20)
      child: ListView.builder(
        itemCount: widget.fav_item.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(widget.fav_item[index].toString()),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to delete ${widget.fav_item[index]["name"]}?"),
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
                              removefromFavourite(
                                  widget.fav_item[index]["location"]);
                              setState(() {
                                widget.fav_item.removeAt(index);
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
                addToCart(widget.fav_item[index]["location"]);
                // print("swipe right right right right");
              }
            },
            child: CartCard(widget.fav_item[index]),
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
                // children: [
                //   TextSpan(
                //       text: " x${cart.numOfItem}",
                //       style: Theme.of(context).textTheme.bodyText1),
                // ],
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
            Icons.shopping_basket,
            color: Colors.white,
          ),
          Text(
            " Add to Cart",
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

////////////////////////////////////////////////////////////////////////////////////////////
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:signup/reusable_widgets/fetchProducts.dart';
//
// class Favourite extends StatefulWidget {
//   @override
//   _FavouriteState createState() => _FavouriteState();
// }
//
// class _FavouriteState extends State<Favourite> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: fetchData("users-favourite-items"),
//       ),
//     );
//   }
// }