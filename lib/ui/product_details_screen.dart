import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  Map<String, dynamic> _product;
  ProductDetails(this._product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with TickerProviderStateMixin {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Welcome to Flutter',
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Welcome to Flutter'),
  //       ),
  //       body: const Center(
  //         child: Text('Profile'),
  //       ),
  //     ),
  //   );
  // }

  late AnimationController controller;
  late Animation<double> animation;
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
    isLiked = widget._product["product-liked"];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  // Future addToCart() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   var currentUser = _auth.currentUser;
  //   CollectionReference _collectionRef =
  //       FirebaseFirestore.instance.collection("users-cart-items");
  //   return _collectionRef
  //       .doc(currentUser!.email)
  //       .collection("items")
  //       .doc()
  //       .set({
  //     "name": widget._product["product-name"],
  //     "price": widget._product["product-price"],
  //     "images": widget._product["product-img"],
  //   }).then((value) => print("Added to cart"));
  // }

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uuid = Uuid();
    var v1 = uuid.v1();
    DocumentReference docRef = FirebaseFirestore.instance.doc(widget._product["product-location"]);
    docRef.update({
      "favorite-reference": v1,
      "isliked": true,
    });
    widget._product["favorite-reference"] = v1;
    widget._product["product-liked"] = true;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(v1)
        .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
      "reference": widget._product["product-location"],

    }).then((value) => print("Added to favourite"));
  }

  Future removefromFavourite(String docId) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    DocumentReference docRef = FirebaseFirestore.instance.doc(widget._product["product-location"]);
    docRef.update({
      "favorite-reference": "",
      "isliked": false,
    });
    var currentUser = _auth.currentUser;
    widget._product["favorite-reference"] = "";
    widget._product["product-liked"] = false;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(docId)
        .delete().then((value) => print("Removed from favourite"));
  }


  Widget _appBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Color(0xffF72804) : Color(0xffE1E2E4),
              size: 15,
              padding: 12,
              isOutLine: false,
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                  // isLiked = widget._product["product-liked"];
                  isLiked ? addToFavourite() : removefromFavourite(widget._product["favorite-reference"]);
                  // addToFavourite();
                });
              }),
        ],
      ),
    );
  }

  Widget _icon(
      IconData icon, {
        Color color = const Color(0xffa8a09b),
        double size = 20,
        double padding = 10,
        bool isOutLine = false,
        required Function onPressed,
      }) {
    return GestureDetector(
        onTap: () => onPressed(),

    child: Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: Color(0xffa8a09b),
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
        isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ),
    );
    //     .ripple(() {
    //   if (onPressed != null) {
    //     onPressed();
    //   }
    // }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // TitleText(
          //   text: "AIP",
          //   fontSize: 160,
          //   color: Color(0xffE1E2E4),
          // ),
          Image.network(widget._product["product-img"])
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    print("gggggggg ${widget._product["product-thumbnail"]}");

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: 100,
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          (widget._product["product-thumbnail"]).map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffA1A3A6),
            ),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            // color: Theme.of(context).backgroundColor,
          ),
          child: Image.network(image),
        )
            // .ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
      ),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: AppColors.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: widget._product["product-name"], fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "\$ ",
                                fontSize: 18,
                                color: AppColors.red,
                              ),
                              TitleText(
                                text: widget._product["product-price"].toString(),
                                fontSize: 25,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star,
                                  color: AppColors.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: AppColors.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: AppColors.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: AppColors.yellowColor, size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _availableSize(),
                SizedBox(
                  height: 20,
                ),
                _availableColor(),
                SizedBox(
                  height: 20,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("US 6"),
            _sizeWidget("US 7", isSelected: true),
            _sizeWidget("US 8"),
            _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: AppColors.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
        isSelected ? AppColors.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? AppColors.background : AppColors.titleTextColor,
      ),
    );
        // .ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(AppColors.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(AppColors.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(AppColors.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(AppColors.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(AppColors.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
        Icons.check_circle,
        color: color,
        size: 18,
      )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text((widget._product["product-description"]).replaceAll("\\n", "\n")),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffbfbfb),
                  Color(0xfff7f7f7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                  // _categoryWidget(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }
}
