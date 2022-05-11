import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  var item;

  CartCard(this.item);

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
              child: Image.network(item['image']),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'].substring(0, 10),
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
        ),
      ],
    );
  }
}

class Detail extends StatefulWidget {
  String ref;
  Detail(this.ref);

  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<Detail> {

  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    print("inside order items init state");
    fetch_orders(widget.ref);
  }

  fetch_orders(String docid) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    var docref = await FirebaseFirestore.instance.collection("Order_details").doc(currentUser!.email).collection("Orders").doc(docid).get();
    Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

    for (int i = 0; i < allData["Items"].length; i++) {
      print("${allData["Items"][i]}");
      items.add({
        "reference": allData["Items"][i]["location"],
        "image": allData["Items"][i]["img"],
        "name": allData["Items"][i]["name"],
        "price": allData["Items"][i]["price"],
        "quantity": allData["Items"][i]["quantity"],
      });
    }

    setState(() {
      items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent[200],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                "Order Items",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "${items.length} items",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        body: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 50), // getProportionateScreenWidth(20)
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  // child: GestureDetector(
                  //   onTap: () => {},
                  // Navigator.push(context,
                  // MaterialPageRoute(builder: (_) => ProductDetails(product, callback))),
                  child: CartCard(items[index]),
                  // ),
                ),
          ),
        )
    );
  }
}