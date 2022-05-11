import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:signup/screens/add_product.dart';
import 'package:signup/screens/product_category.dart';
import 'package:signup/utils/color_utils.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // @override
  // void initState() {
  //   super.initState();
  //   print('k');
  //   size = 0;

  //   getCategoryNumber();
  // }
 List<dynamic> value = [];





  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  // BrandService _brandService = BrandService();
  // CategoryService _categoryService = CategoryService();
 getCategoryNumber() async {

    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    int product_size = 0;
    int size = 0;
    
    print("h");
    var dress = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Dress').get();
    var watch = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Watch').get();
    var shirt = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Shirt').get();
    var tech = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Tech').get();
    var home = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Home').get();
    var jewel = await _firestoreInstance.collection("seller-products").doc(currentUser!.email).collection('Jewel').get();

    if(await !(dress.docs.isEmpty)){
     product_size = product_size + dress.docs.length;
      size=size+1;
    }
    if(await !(watch.docs.isEmpty)){
           product_size = product_size + dress.docs.length;

      size=size+1;
    }
     if(await !(shirt.docs.isEmpty)){
            product_size = product_size + dress.docs.length;

      size=size+1;
    }
     if(await !(tech.docs.isEmpty)){
            product_size = product_size + dress.docs.length;

      size=size+1;
    }
     if(await !(home.docs.isEmpty)){
            product_size = product_size + dress.docs.length;

      size=size+1;
    }
     if(await !(jewel.docs.isEmpty)){
            product_size = product_size + dress.docs.length;

      size=size+1;
    }

    // print(size);
    value[0] = size;
    // value.add(size);
    value[1] = product_size;
    // value.add(product_size);
    // print(value[0]);
    // print(value[1]);



  }
  getOrder() async {

    int sold = 0;

    var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var doc = await _firestoreInstance.collection("Order_details").get();
    for(int k = 0; k < doc.docs.length ; k ++){
    var second =  await doc.docs[k].reference.collection("Orders").get();

   for(int i = 0; i< second.docs.length; i++){
     List<dynamic> count = second.docs[i]["Items"];
     print(count.length);
     for(int j =0; j< count.length; j ++){
        print(second.docs[i]["Items"][j]["seller-name"] );
              
              if(second.docs[i]["Items"][j]["seller-name"] == _auth.currentUser!.email){

                    print("in");
                    print(second.docs[i]["Items"][j]["quantity"]);
                    int v = second.docs[i]["Items"][j]["quantity"];
                        sold = v + sold;
                        // sold = second.docs[i]["Items"][j]["quantity"]+1;
              }


     }
   }
    }
  value[2] = sold;
  //  value.add(sold);

  //  List<dynamic> count = second.docs[7]["Items"];



    // print(count.length);
    // print(doc.size);

  }

  getCartItems() async {
     int items = 0;
     var _firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var doc = await _firestoreInstance.collection("users-cart-items").doc("a@s.com").collection("items").get();
    var doc2 = await _firestoreInstance.collection("users-form-data").get();
    // print(doc2.docs.length);
    for(int k = 0; k < doc2.docs.length ; k ++){
      // print(doc2.docs[k].id);
      
      // var sample = await doc2.docs[k].reference.collection("items").get();
      var sample = await _firestoreInstance.collection("users-cart-items").doc(doc2.docs[k].id).collection("items").get();
      // print(sample.asStream().isEmpty);
    //  print(sample.docs.length);
      // bool v = await sample.asStream().isEmpty;
      // print(v);
      if(sample.docs.length > 0){

       for(int i = 0 ; i < sample.docs.length ; i ++){
          print(sample.docs[i]["seller-name"]);
         if (sample.docs[i]["seller-name"] == _auth.currentUser!.email){
              int val = sample.docs[i]["quantity"];
              
              items = items + val;
         }
       }
      }
      
    //   var second =  await doc.docs[k].reference.collection("items").get();
    //   print(second.docs.length);
    //   // for(int i = 0; i< second.docs.length; i++){

      }
      print(items);
    // }
    value[3] = items;
    


  }


  @override
  Widget build(BuildContext context)  {
  value.add(0);
  value.add(0);
  value.add(0);
  value.add(0);
    return Scaffold(
  
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.pink,
          
        ),
        body : Container(
          width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),

child: Padding(
          // padding: EdgeInsets.fromLTRB(
          //     20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          padding:  const EdgeInsets.all(18.0),
          child: Column(children: <Widget>[

             ListTile(
              subtitle: ElevatedButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                    
                         children: <Widget> [
                    Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(

                          title: ElevatedButton.icon(
                              onPressed: (){
                                setState((){
                                  getCategoryNumber();
                                  print(value[0]);

                                });
                              },
                              icon: Icon(Icons.category),
                              label: Text("Category")),
                          subtitle: Text(
                            value[0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: ElevatedButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Producs")),
                          subtitle: Text(
                            value[1].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: ElevatedButton.icon(
                              onPressed: () => getOrder() ,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            value[2].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: ElevatedButton.icon(
                              onPressed: () => getCartItems(),
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            value[3].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: ElevatedButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  ]  
                ))
           
          ]),
        )
        ));
  }

 
}