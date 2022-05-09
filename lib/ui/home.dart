// ignore: unnecessary_import
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/bottom_nav_controller.dart';
import 'product_details_screen.dart';
import 'search_screen.dart';
import 'product_card.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselController buttonCarouselController = CarouselController();

  Widget _productWidget(List item_list) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 600,
      height: 200,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20),
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        children: item_list
            .map(
              (product) => ProductCard(
                product,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _categoryRow(
    String title,
    // Color primary,
    // Color textColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: const Color(0xff5a5d85), fontWeight: FontWeight.bold),
          ),
          // _chip("See all", primary)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text(
          "ShoPee",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => SearchScreen()));
              },
              icon: Icon(Icons.search, color: Colors.white))
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
        child: Column(children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(left: 20, right: 20),
          //   child: TextFormField(
          //     readOnly: true,
          //     decoration: InputDecoration(
          //       fillColor: Colors.white,
          //       focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(0)),
          //           borderSide: BorderSide(color: Colors.blue)),
          //       enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(0)),
          //           borderSide: BorderSide(color: Colors.grey)),
          //       hintText: 'Enter a search term',
          //       hintStyle: TextStyle(fontSize: 15),
          //     ),
          //     onTap: () => Navigator.push(
          //         context, CupertinoPageRoute(builder: (_) => SearchScreen())),
          //   ),
          // ),
          CarouselSlider(
              items: _carouselImages
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth)),
                        ),
                      ))
                  // .map((item) => Container(
                  //       child: Container(
                  //           child: Image.network(item,
                  //               fit: BoxFit.fitWidth, width: 1200)),
                  //     ))
                  .toList(),
              options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  // autoPlay: false,
                  // enlargeCenterPage: true,
                  // viewportFraction: 0.8,
                  // enlargeStrategy: CenterPageEnlargeStrategy.height,
                  disableCenter: true,
                  onPageChanged: (val, carouselPageChangedReason) {
                    setState(() {
                      _dotPosition = val;
                    });
                  })),
          DotsIndicator(
            dotsCount: _carouselImages.length == 0 ? 1 : _carouselImages.length,
            position: _dotPosition.toDouble(),
            decorator: DotsDecorator(
              activeColor: AppColors.deep_orange,
              color: AppColors.deep_orange.withOpacity(0.5),
              spacing: EdgeInsets.all(2),
              activeSize: Size(8, 8),
              size: Size(6, 6),
            ),
          ),
          // Expanded(
          //   child: GridView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: _products.length,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2, childAspectRatio: 1),
          //       itemBuilder: (_, index) {
          //         return GestureDetector(
          //           onTap: () => Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (_) => ProductDetails(_products[index]))),
          //           child: Card(
          //             elevation: 3,
          //             child: Column(
          //               children: [
          //                 AspectRatio(
          //                     aspectRatio: 2,
          //                     child: Container(
          //                         color: Colors.yellow,
          //                         child: Image.network(
          //                           // 'https://picsum.photos/250?image=9'
          //                           _products[index]["product-img"],
          //                         ))),
          //                 Text("${_products[index]["product-name"]}"),
          //                 Text("${_products[index]["product-price"].toString()}"),
          //               ],
          //             ),
          //           ),
          //         );
          //       }),
          // ),

          // _categoryRow("Electronics"),
          //
          // _productWidget(_products),

          _categoryRow("Watches"),

          _productWidget(_watches),

          _categoryRow("Clothes"),

          _productWidget(_shirts),
        ]),
      ))),
      // bottomNavigationBar: BottomNavController("home"),
    );
  }
///////////////////////////////////////////////////////////////////////////////////////////////

  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  List _watches = [];
  List _shirts = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  // fetchProducts() async {
  //   _firestoreInstance = FirebaseFirestore.instance;
  //   QuerySnapshot qn = await _firestoreInstance.collection("products").get();
  //   setState(() {
  //     for (int i = 0; i < qn.docs.length; i++) {
  //       _products.add({
  //         "product-name": qn.docs[i]["product-name"],
  //         "product-description": qn.docs[i]["product-description"],
  //         "product-price": qn.docs[i]["product-price"],
  //         "product-img": qn.docs[i]["product-img"],
  //       });
  //       print("jjjjjjjjjkllll ${qn.docs[i].reference.path}");
  //     }
  //   });
  //
  //   return qn.docs;
  // }

  fetch_watch() async {
    var details = {'isliked': false, 'favorite-reference': '', 'cart': false, 'cart-reference': '', "quantity": 0 };
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("watch").get();
    // CollectionReference _collectionRef = await _firestoreInstance.collection("Shirts").doc().collection(currentUser!.email ?? "");

    // setState(()  {
    for (int i = 0; i < qn.docs.length; i++) {

      print("currentUser!.email currentUser!.email currentUser!.email ${currentUser!.email}");
      var is_present;
      is_present = await countDocuments(qn.docs[i].reference.id.toString(), "watch");

      print("is_present is_present is_present is_present is_present ${is_present}");

      if(is_present)
      {
        Map<String, dynamic> allData = qn.docs[i].data() as Map<String, dynamic>;
        print("is_present is_present is_present is_present is_present ${qn.docs[i].reference.id} ddddddd ${allData['price']}");

        _watches.add({
          "product-name": allData["name"],
          "product-description": allData["description"],
          "product-price": allData["price"],
          "product-img": allData["img"],
          "product-liked": allData[currentUser.email.toString()]["isliked"],
          "product-quantity": allData[currentUser.email.toString()]["quantity"],
          "product-cart": allData[currentUser.email.toString()]["cart"],
          "product-location": allData["reference"],
          "cart-reference": allData[currentUser.email.toString()]["cart-reference"],
          "favorite-reference": allData[currentUser.email.toString()]["favorite-reference"],
          "product-thumbnail": <String>[
            allData["thumbnail1"].toString(),
            allData["thumbnail2"].toString(),
            allData["thumbnail3"].toString(),
            allData["thumbnail4"].toString()
          ]
        });
      }
      else
      {
        _watches.add({
          "product-name": qn.docs[i]["name"],
          "product-description": qn.docs[i]["description"],
          "product-price": qn.docs[i]["price"],
          "product-img": qn.docs[i]["img"],
          "product-liked": false,
          "product-quantity": 0,
          "product-cart": false,
          "product-location": qn.docs[i]["reference"],
          "cart-reference": "",
          "favorite-reference": "",
          "product-thumbnail": <String>[
            qn.docs[i]["thumbnail1"].toString(),
            qn.docs[i]["thumbnail2"].toString(),
            qn.docs[i]["thumbnail3"].toString(),
            qn.docs[i]["thumbnail4"].toString()
          ]
        });

        FirebaseFirestore.instance.collection("watch").doc(qn.docs[i].reference.id.toString())
            .set({
          currentUser.email.toString() : details,
        },
          SetOptions(merge: true),
        );
      }
    };
    setState(() {
      _watches;
    });
  }

  fetch_shirt() async {
    var details = {'isliked': false, 'favorite-reference': '', 'cart': false, 'cart-reference': '', "quantity": 0 };
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("Shirts").get();
    // CollectionReference _collectionRef = await _firestoreInstance.collection("Shirts").doc().collection(currentUser!.email ?? "");

    // setState(()  {
      for (int i = 0; i < qn.docs.length; i++) {

        print("currentUser!.email currentUser!.email currentUser!.email ${currentUser!.email}");
        var is_present;
        is_present = await countDocuments(qn.docs[i].reference.id.toString(), "Shirts");

        print("is_present is_present is_present is_present is_present ${is_present}");

        if(is_present)
        {
          Map<String, dynamic> allData = qn.docs[i].data() as Map<String, dynamic>;
          print("is_present is_present is_present is_present is_present ${qn.docs[i].reference.id} ddddddd ${allData['price']}");

          _shirts.add({
            "product-name": allData["name"],
            "product-description": allData["description"],
            "product-price": allData["price"],
            "product-img": allData["img"],
            "product-liked": allData[currentUser.email.toString()]["isliked"],
            "product-quantity": allData[currentUser.email.toString()]["quantity"],
            "product-cart": allData[currentUser.email.toString()]["cart"],
            "product-location": allData["reference"],
            "cart-reference": allData[currentUser.email.toString()]["cart-reference"],
            "favorite-reference": allData[currentUser.email.toString()]["favorite-reference"],
            "product-thumbnail": <String>[
              allData["thumbnail1"].toString(),
              allData["thumbnail2"].toString(),
              allData["thumbnail3"].toString(),
              allData["thumbnail4"].toString()
            ]
          });
        }
        else
        {
          _shirts.add({
            "product-name": qn.docs[i]["name"],
            "product-description": qn.docs[i]["description"],
            "product-price": qn.docs[i]["price"],
            "product-img": qn.docs[i]["img"],
            "product-liked": false,
            "product-quantity": 0,
            "product-cart": false,
            "product-location": qn.docs[i]["reference"],

            "cart-reference": "",
            "favorite-reference": "",
            "product-thumbnail": <String>[
              qn.docs[i]["thumbnail1"].toString(),
              qn.docs[i]["thumbnail2"].toString(),
              qn.docs[i]["thumbnail3"].toString(),
              qn.docs[i]["thumbnail4"].toString()
            ]
          });

          FirebaseFirestore.instance.collection("Shirts").doc(qn.docs[i].reference.id.toString())
              .set({
            currentUser.email.toString() : details,
            },
              SetOptions(merge: true),
            );
        }
      };
      setState(() {
        _shirts;
      });
  }

  Future<bool> countDocuments(String docid, String cat) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference users  = await FirebaseFirestore.instance.collection(cat); //.doc(docid).collection(currentUser!.email ?? "");
    var doc = await users.doc(docid).get();
    if(doc.exists){
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      if(map.containsKey(currentUser!.email)){// Replace field by the field you want to check.
        return true;
      }
      else
      {
          return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
    // fetchProducts();
    fetch_watch();
    fetch_shirt();
  }

  // @override
  // Widget build(BuildContext context) {
  //   // return MaterialApp(
  //   //   title: 'Welcome to Flutter',
  //   //   home: Scaffold(
  //   //     appBar: AppBar(
  //   //       title: const Text('Welcome to Flutter'),
  //   //     ),
  //   //     body: const Center(
  //   //       child: Text('Profile'),
  //   //     ),
  //   //   ),
  //   // );

  //   return Scaffold(
  //     body: SafeArea(
  //         child: Container(
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 20.w, right: 20.w),
  //             child: TextFormField(
  //               readOnly: true,
  //               decoration: InputDecoration(
  //                 fillColor: Colors.white,
  //                 focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(0)),
  //                     borderSide: BorderSide(color: Colors.blue)),
  //                 enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(0)),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 hintText: "Search products here",
  //                 hintStyle: TextStyle(fontSize: 15.sp),
  //               ),
  //               onTap: () => Navigator.push(context,
  //                   CupertinoPageRoute(builder: (_) => SearchScreen())),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10.h,
  //           ),
  //           AspectRatio(
  //             aspectRatio: 3.5,
  //             child: CarouselSlider(
  //                 items: _carouselImages
  //                     .map((item) => Padding(
  //                           padding: const EdgeInsets.only(left: 3, right: 3),
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                                 image: DecorationImage(
  //                                     image: NetworkImage(item),
  //                                     fit: BoxFit.fitWidth)),
  //                           ),
  //                         ))
  //                     .toList(),
  //                 options: CarouselOptions(
  //                     autoPlay: false,
  //                     enlargeCenterPage: true,
  //                     viewportFraction: 0.8,
  //                     enlargeStrategy: CenterPageEnlargeStrategy.height,
  //                     onPageChanged: (val, carouselPageChangedReason) {
  //                       setState(() {
  //                         _dotPosition = val;
  //                       });
  //                     })),
  //           ),
  //           SizedBox(
  //             height: 10.h,
  //           ),
  //           DotsIndicator(
  //             dotsCount:
  //                 _carouselImages.length == 0 ? 1 : _carouselImages.length,
  //             position: _dotPosition.toDouble(),
  //             decorator: DotsDecorator(
  //               activeColor: AppColors.deep_orange,
  //               color: AppColors.deep_orange.withOpacity(0.5),
  //               spacing: EdgeInsets.all(2),
  //               activeSize: Size(8, 8),
  //               size: Size(6, 6),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 15.h,
  //           ),
  //           Expanded(
  //             child: GridView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: _products.length,
  //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2, childAspectRatio: 1),
  //                 itemBuilder: (_, index) {
  //                   return GestureDetector(
  //                     onTap: () => Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (_) =>
  //                                 ProductDetails(_products[index]))),
  //                     child: Card(
  //                       elevation: 3,
  //                       child: Column(
  //                         children: [
  //                           AspectRatio(
  //                               aspectRatio: 2,
  //                               child: Container(
  //                                   color: Colors.yellow,
  //                                   child: Image.network(
  //                                     _products[index]["product-img"][0],
  //                                   ))),
  //                           Text("${_products[index]["product-name"]}"),
  //                           Text(
  //                               "${_products[index]["product-price"].toString()}"),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //           ),
  //         ],
  //       ),
  //     )),
  //   );
  // }
}

// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:signup/const/AppColors.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'product_details_screen.dart';
// import 'search_screen.dart';
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   List<String> _carouselImages = [];
//   var _dotPosition = 0;
//   List _products = [];
//   var _firestoreInstance = FirebaseFirestore.instance;
//
//   fetchCarouselImages() async {
//     QuerySnapshot qn =
//         await _firestoreInstance.collection("carousel-slider").get();
//     setState(() {
//       for (int i = 0; i < qn.docs.length; i++) {
//         _carouselImages.add(
//           qn.docs[i]["img-path"],
//         );
//         print(qn.docs[i]["img-path"]);
//       }
//     });
//
//     return qn.docs;
//   }
//
//   fetchProducts() async {
//     QuerySnapshot qn = await _firestoreInstance.collection("products").get();
//     setState(() {
//       for (int i = 0; i < qn.docs.length; i++) {
//         _products.add({
//           "product-name": qn.docs[i]["product-name"],
//           "product-description": qn.docs[i]["product-description"],
//           "product-price": qn.docs[i]["product-price"],
//           "product-img": qn.docs[i]["product-img"],
//         });
//       }
//     });
//
//     return qn.docs;
//   }
//
//   @override
//   void initState() {
//     fetchCarouselImages();
//     fetchProducts();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 20, right: 20),
//                 child: TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(0)),
//                         borderSide: BorderSide(color: Colors.blue)),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(0)),
//                         borderSide: BorderSide(color: Colors.grey)),
//                     hintText: "Search products here",
//                     hintStyle: TextStyle(fontSize: 15),
//                   ),
//                   onTap: () => Navigator.push(context,
//                       CupertinoPageRoute(builder: (_) => SearchScreen())),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               AspectRatio(
//                 aspectRatio: 3.5,
//                 child: CarouselSlider(
//                     items: _carouselImages
//                         .map((item) => Padding(
//                               padding: const EdgeInsets.only(left: 3, right: 3),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: NetworkImage(item),
//                                         fit: BoxFit.fitWidth)),
//                               ),
//                             ))
//                         .toList(),
//                     options: CarouselOptions(
//                         autoPlay: false,
//                         enlargeCenterPage: true,
//                         viewportFraction: 0.8,
//                         enlargeStrategy: CenterPageEnlargeStrategy.height,
//                         onPageChanged: (val, carouselPageChangedReason) {
//                           setState(() {
//                             _dotPosition = val;
//                           });
//                         })),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               DotsIndicator(
//                 dotsCount:
//                     _carouselImages.length == 0 ? 1 : _carouselImages.length,
//                 position: _dotPosition.toDouble(),
//                 decorator: DotsDecorator(
//                   activeColor: AppColors.deep_orange,
//                   color: AppColors.deep_orange.withOpacity(0.5),
//                   spacing: EdgeInsets.all(2),
//                   activeSize: Size(8, 8),
//                   size: Size(6, 6),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Expanded(
//                 child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _products.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2, childAspectRatio: 1),
//                     itemBuilder: (_, index) {
//                       return GestureDetector(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) =>
//                                     ProductDetails(_products[index]))),
//                         child: Card(
//                           elevation: 3,
//                           child: Column(
//                             children: [
//                               AspectRatio(
//                                   aspectRatio: 2,
//                                   child: Container(
//                                       color: Colors.yellow,
//                                       child: Image.network(
//                                         _products[index]["product-img"],
//                                       ))),
//                               Text("${_products[index]["product-name"]}"),
//                               Text("${_products[index]["product-price"]}"),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
