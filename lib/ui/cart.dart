// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ecommerce/widgets/fetchProducts.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Profile'),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: fetchData("users-cart-items"),
  //     ),
  //   );
  // }

  Widget fetchData(String collectionName) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something is wrong"),
          );
        }

        return ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

              return Card(
                elevation: 5,
                child: ListTile(
                  leading: Text(_documentSnapshot['name']),
                  title: Text(
                    "\$ ${_documentSnapshot['price']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  trailing: GestureDetector(
                    child: CircleAvatar(
                      child: Icon(Icons.remove_circle),
                    ),
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(collectionName)
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection("items")
                          .doc(_documentSnapshot.id)
                          .delete();
                    },
                  ),
                ),
              );
            });
      },
    );
  }
}
