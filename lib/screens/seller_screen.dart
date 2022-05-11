
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:signup/screens/product_category.dart';
import 'package:signup/screens/seller_admin.dart';
import 'package:signup/screens/seller_products.dart';
import 'package:signup/screens/splash_screen.dart';
import 'package:signup/ui/profile/components/profile_menu.dart';
import 'package:signup/utils/color_utils.dart'; 

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  State<SellerScreen> createState() => _SellerScreenState();
  
}

class _SellerScreenState extends State<SellerScreen> {

  Widget build(BuildContext context) {
   return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(children: <Widget>[

            firebaseUIButton(context, "Category", () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder : (context) => productcategory()));

            }),
            const SizedBox(
              height: 5,
            ),
            firebaseUIButton(context, "Products", () {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => sellerProduct()));

            }),
            const SizedBox(
              height: 5,
            ),
            firebaseUIButton(context, "Dashboard", () {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Admin()));

            }),
            const SizedBox(
              height: 100,
            ),
             ProfileMenu(
            text: "Log Out",
            icon: "assest/icons/Log out.svg",
            press: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => SplashScreen()),
                  (route) => false);
            },
          ),

          ]),
        )),
      ),
    );
  }
  
  
}