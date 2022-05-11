import 'package:flutter/material.dart';
import 'product_details_screen.dart';
import 'package:signup/reusable_widgets/reusable_widgets.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  ProductCard(this.product);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Map<String, dynamic> product;
  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  callback(new_map) {
    print("inside callback inside callback inside callback inside callback");
    setState(() {
      product["product-liked"] = new_map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),
      // margin: EdgeInsets.symmetric(vertical: !product.isSelected ? 20 : 0),
      child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetails(product, callback))),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(
                      product["product-liked"]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product["product-liked"]
                          ? Color(0xffF72804)
                          : Color(0xffa8a09b),
                    ),
                    onPressed: () {},
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // SizedBox(height: product.isSelected ? 15 : 0),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundColor: Color(0xffE65829).withAlpha(40),
                          // ),
                          Image.network(product["product-img"])
                        ],
                      ),
                    ),
                    // SizedBox(height: 5),
                    TitleText(
                      text: product["product-name"],
                      // fontSize: product.isSelected ? 16 : 14,
                      fontSize: 16,
                    ),
                    // TitleText(
                    //   text: product.category,
                    //   fontSize: product.isSelected ? 14 : 12,
                    //   color: Color(0xffE65829),
                    // ),
                    TitleText(
                      text: product["product-price"].toString(),
                      // fontSize: product.isSelected ? 18 : 16,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
