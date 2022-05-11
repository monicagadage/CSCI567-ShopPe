import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class sellerProduct extends StatefulWidget {
  @override
  _sellerProductState createState() => _sellerProductState();
}

class _sellerProductState extends State<sellerProduct> {

  @override
  void initState() {
    super.initState();
    List<String> category = ["Dress","watch","Tech","Shirt"];
    fetch_products();
  }
  List seller_items = [];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Body(seller_items),
      // bottomNavigationBar: BottomNavController("favorite"),
        );
      // ),
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
            "${seller_items.length} items",
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
        ],
      ),
    );
  }
  

  fetch_products() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    var doc = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).get();
    QuerySnapshot<Map<String, dynamic>> querry = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection("Dress").get();;
    print(querry.docs.length);
    setState(() {
      for (int i = 0; i < querry.docs.length; i++) {
        print('in');
        seller_items.add({
        
          "name": querry.docs[i]["name"],
          "price": querry.docs[i]["price"],
          "img": querry.docs[i]["img"][0],
          "location": querry.docs[i]["reference"],
          "path": querry.docs[i].reference.path });
        print("path ${querry.docs[i].reference.path}");
      }
    });

    return querry.docs;
  }

}

class Body extends StatefulWidget {
  List product;
  Body(this.product);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Future removefromFavourite(String docId,String path) async {

    print(path);
    print(docId);
    final pathID = path.split("/");
    final docID = path.split("/");
    FirebaseFirestore.instance.collection(pathID[0]).doc(pathID[1]).collection(pathID[2]).doc(pathID[3]).delete().then((value) => print("Removed from Seller "));
    FirebaseFirestore.instance.collection(docID[0]).doc(docID[1]).delete().then((value) => print("Removed from category "));

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 50 ),    // getProportionateScreenWidth(20)
      child: ListView.builder(
        itemCount: widget.product.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(widget.product[index].toString()),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),

            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to delete ${widget.product[index]["name"]}?"),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: Delete the item from DB etc..
                              print(widget.product[index]["location"]);
                              removefromFavourite(widget.product[index]["location"].toString(),widget.product[index]["path"].toString());
                              setState(() {
                                widget.product.removeAt(index);
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

            child: CartCard(widget.product[index]),
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
              padding: EdgeInsets.all(20),     // getProportionateScreenWidth(10)
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
            Icons.edit,
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