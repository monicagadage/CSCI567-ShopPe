// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/ui/checkout_card.dart';
// import 'package:flutter_ecommerce/widgets/fetchProducts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  double total = 0;
  @override
  void initState() {
    super.initState();
    fetch_cart().then((value) => calculate_total());
    // calculate_total();
  }

  callback()
  {
    cart_items = [];
    total = 0;
    fetch_cart().then((value) => calculate_total());

  }

  calculate_total()
  {
    print("${cart_items.length} lengthlengthlengthlengthlength");
    setState(() {
      for(int i=0; i<cart_items.length; i++)
      {
        total = total + cart_items[i]["price"]*cart_items[i]["quantity"];
        print("${total} totaltotaltotaltotaltotaltotal");
      }
    });
  }

  List cart_items = [];
  fetch_cart() async {
    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    QuerySnapshot qn = await _firestoreInstance.collection("users-cart-items").doc(currentUser!.email)
        .collection("items").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        cart_items.add({
          "name": qn.docs[i]["name"],
          "price": qn.docs[i]["price"],
          "img": qn.docs[i]["images"],
          "quantity": qn.docs[i]["quantity"],
          "location": qn.docs[i]["reference"]});
        print("cart cart cart cart ${qn.docs[i].reference.path}");
      }
    });

    return qn.docs;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent[200],
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${cart_items.length} items",
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(cart_items, callback),
      bottomNavigationBar: CheckoutCard(total),
    );
    // ),
  }

}

class Body extends StatefulWidget {
  List cart_item;
  Function callback;
  Body(this.cart_item, this.callback);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  void doNothing(BuildContext context) { }

  Future _removefromCart(BuildContext context, action, index) async{
  // return doNothing;
    print("${index} indexindexindexindexindexindex");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    final s = widget.cart_item[index]["location"].split('/');

    var docref = await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
    Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

    print("${allData} string string ${s[1]}");

    var isliked = allData[currentUser!.email.toString()]["isliked"];
    var favorite_reference = allData[currentUser!.email.toString()]["favorite-reference"];
    var reference = allData[currentUser!.email.toString()]['cart-reference'];


    FirebaseFirestore.instance.collection(s[1]).doc(s[2])
        .set({
      currentUser.email.toString() : {
        'isliked': isliked,
        'favorite-reference': favorite_reference,
        'cart': false,
        'cart-reference': "",
        "quantity": 0 }
    }, SetOptions(merge: true),).then((value) => print("updated the item item item item"));

    setState(() {
      widget.cart_item.removeAt(index);
    });
    // Navigator.of(context).pop();

    widget.callback();

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(reference)
        .delete().then((value) => print("Removed from cart"));
  }

  Future decrease_quantity(BuildContext context, action, index) async{
    // return doNothing;
    print("${index} indexindexindexindexindexindex");

    if(widget.cart_item[index]["quantity"] == 1){
      _removefromCart(context, action, index);
      return ;
    }

       final FirebaseAuth _auth = FirebaseAuth.instance;
       var currentUser = _auth.currentUser;

       final s = widget.cart_item[index]["location"].split('/');

       var docref = await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
       Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

       print("${allData} string string ${s[1]}");

       var isliked = allData[currentUser!.email.toString()]["isliked"];
       var favorite_reference = allData[currentUser!.email.toString()]["favorite-reference"];
       var reference = allData[currentUser!.email.toString()]['cart-reference'];
       var cart = allData[currentUser!.email.toString()]["cart"];
       var cart_reference = allData[currentUser!.email.toString()]["cart-reference"];
       var quantity = allData[currentUser!.email.toString()]["quantity"];


       FirebaseFirestore.instance.collection(s[1]).doc(s[2])
           .set({
         currentUser.email.toString() : {
           'isliked': isliked,
           'favorite-reference': favorite_reference,
           'cart': cart,
           'cart-reference': cart_reference,
           "quantity": quantity-1 }
       }, SetOptions(merge: true),).then((value) => print("updated the item item item item"));

       setState(() {
         widget.cart_item[index]["quantity"]--;
       });
    widget.callback();

       CollectionReference _collectionRef =
       FirebaseFirestore.instance.collection("users-cart-items");
       return _collectionRef
           .doc(currentUser!.email)
           .collection("items")
           .doc(reference)
           .update({
         "quantity": quantity-1,
       }).then((value) => print("quantity decreased"));
   }


  Future increase_quantity(BuildContext context, action, index) async{
    // return doNothing;
    print("${index} indexindexindexindexindexindex");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    final s = widget.cart_item[index]["location"].split('/');

    var docref = await FirebaseFirestore.instance.collection(s[1]).doc(s[2]).get();
    Map<String, dynamic> allData = docref.data() as Map<String, dynamic>;

    print("${allData} string string ${s[1]}");

    var isliked = allData[currentUser!.email.toString()]["isliked"];
    var favorite_reference = allData[currentUser!.email.toString()]["favorite-reference"];
    var reference = allData[currentUser!.email.toString()]['cart-reference'];
    var cart = allData[currentUser!.email.toString()]["cart"];
    var cart_reference = allData[currentUser!.email.toString()]["cart-reference"];
    var quantity = allData[currentUser!.email.toString()]["quantity"];


    FirebaseFirestore.instance.collection(s[1]).doc(s[2])
        .set({
      currentUser.email.toString() : {
        'isliked': isliked,
        'favorite-reference': favorite_reference,
        'cart': cart,
        'cart-reference': cart_reference,
        "quantity": quantity+1 }
    }, SetOptions(merge: true),).then((value) => print("updated the item item item item"));

    setState(() {
      widget.cart_item[index]["quantity"]++;
    });

    widget.callback();

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(reference)
        .update({
    "quantity": quantity+1,
    }).then((value) => print("quantity increased"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 50 ),    // getProportionateScreenWidth(20)
      child: ListView.builder(
        itemCount: widget.cart_item.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Slidable(
            child: CartCard(widget.cart_item[index]),

            // The start action pane is the one at the left or the top side.
            startActionPane:  ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: ScrollMotion(),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (action) => _removefromCart(context, action, index),
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              // dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  // flex: 2,
                  onPressed: (action) => increase_quantity(context, action, index),
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.green,
                  icon: Icons.add,
                  label: 'Increment',
                ),
                SlidableAction(
                  onPressed: (action) => decrease_quantity(context, action, index),
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.red,
                  icon: Icons.remove,
                  label: 'decrement',
                ),
              ],
            ),


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
