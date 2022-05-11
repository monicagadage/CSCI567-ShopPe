import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order_items.dart';

class CartCard extends StatelessWidget {
  var item;

  CartCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SizedBox(
        //   width: 88,
        //   child: AspectRatio(
        //     aspectRatio: 0.88,
        //     child: Container(
        //       padding: EdgeInsets.all(20), // getProportionateScreenWidth(10)
        //       decoration: BoxDecoration(
        //         color: Color(0xFFF5F6F9),
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //       child: Image.network(item['img']),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['order_id'].substring(0, 10),
              style: TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\$${item['total']}",
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
        ),
        SizedBox(width: 50),
        SizedBox(
          width: 100,
          child: Text(
            item['date'],
            style: TextStyle(color: Colors.black, fontSize: 16),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

class order_body extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<order_body> {

  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    print("inside past orders init state");
    fetch_orders();
  }

  fetch_orders() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("Order_details");
    QuerySnapshot qn = await _collectionRef
        .doc(currentUser!.email)
        .collection("Orders")
        .get();

    for (int i = 0; i < qn.docs.length; i++) {
      print("${qn.docs[i].reference.id}");
      items.add({
        "reference": qn.docs[i].reference.id,
        "order_id": qn.docs[i]["orderid"],
        "total": qn.docs[i]["totalprice"],
        "date": qn.docs[i]["date"]
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
              "Past Orders",
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
              child: GestureDetector(
                onTap: () =>
                    Navigator.push(context,
                    MaterialPageRoute(builder: (_) => Detail(items[index]["reference"]))),
                child: CartCard(items[index]),
              ),
            ),
      ),
    )
    );
  }
}
