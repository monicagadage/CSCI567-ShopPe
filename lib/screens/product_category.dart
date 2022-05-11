import 'package:flutter/material.dart';
import 'package:signup/reusable_widgets/category_card.dart';
import 'package:signup/ui/favourite.dart';
import 'package:signup/utils/color_utils.dart';

class productcategory extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
       automaticallyImplyLeading: false,

        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Seller Module",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ), 
    body :Container(
       width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      // height: 120,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
        ),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CategoryCard(
            "assest/image/dress.jpeg",
            'Dress'
            ),
            CategoryCard(
            "assest/image/shirt.jpeg",
            'Shirt'
            ),
            CategoryCard(
            "assest/image/watch.jpeg",
            'watch'
            ),
            CategoryCard(
           "assest/image/tech.jpeg",
            'Tech'
            ),
            CategoryCard(
            "assest/image/home.jpeg",
            'Home'
            ),
            CategoryCard(
            "assest/image/jewel.webp",
            'Jewel'
            ),
        ],
      ),
    ),
    );
  }
}
