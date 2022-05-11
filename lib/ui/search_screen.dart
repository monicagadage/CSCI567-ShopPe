import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup/ui/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();

}
class _SearchScreenState extends State<SearchScreen> {
  
  var inputText = "test";
  callback()
  {
    

  }
  
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Welcome to Flutter',
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Welcome to Flutter'),
    //     ),
    //     body: const Center(
    //       child: Text('Profile'),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Products")
                          .where("name",
                              isGreaterThanOrEqualTo: inputText)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(data['name'].toString()),
                                // leading: Image.network(
                                //     // 'https://picsum.photos/250?image=9')
                               
                                leading: Image.network(data['img'].toString()),
                                onTap: () => getDetails(data['reference'].toString()),

                                // onTap: ()=> Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                // builder : (context) => ProductDetails(data,callback))),

                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDetails(String data) async {

    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    final pathID = data.split("/");
    print (pathID);
    var value = await FirebaseFirestore.instance.collection(pathID[1]).doc(pathID[2]).get();
    // print(value.data());
    
    Map<String, dynamic> allData = value.data() as Map<String, dynamic> ;


    // var isliked = allData[currentUser!.email.toString()]["isliked"];
  //   // var favorite_reference = allData[currentUser!.email.toString()]["favorite-reference"];
  //   // var cart = allData[currentUser!.email.toString()]["cart"];
  //   // var cart_reference = allData[currentUser!.email.toString()]["cart-reference"];
  //   // var name = allData["name"];
  //   // var price = allData["price"];
  //   // var image = allData["img"];


  print(allData["name"]);

    Navigator.push(context, MaterialPageRoute(
                  builder : (context) => ProductDetails({
            "product-name": allData["name"],
            "product-description": allData["description"],
            "product-price": allData["price"],
            "product-img": allData["img"][0],
            "product-liked": allData[currentUser!.email.toString()]["isliked"],
            "product-quantity": allData[currentUser.email.toString()]["quantity"],
            "product-cart": allData[currentUser.email.toString()]["cart"],
            "product-location": allData["reference"],
            "cart-reference": allData[currentUser.email.toString()]["cart-reference"],
            "favorite-reference": allData[currentUser.email.toString()]["favorite-reference"],
            // "product-thumbnail": <String>[
            //   allData["thumbnail1"].toString(),
            //   allData["thumbnail2"].toString(),
            //   allData["thumbnail3"].toString(),
              // allData["thumbnail4"].toString()÷
          },callback)));


  }
}