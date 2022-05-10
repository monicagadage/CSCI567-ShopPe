import 'package:flutter/material.dart';
import 'package:signup/screens/add_product.dart';

class CategoryCard extends StatelessWidget {
  final String path;
  final String name;

  CategoryCard(this.path, this.name);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(20),
        //   boxShadow: [
        //     BoxShadow(
        //       blurRadius: 5,
        //       color: Colors.blueGrey
        //     )
        //   ],
        // ),
        // width: 100,
        // child: Padding(
          // padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Material(
                  child: InkWell(
                    onTap: () {
                     Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addProduct(category: name,)));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(path, fit: BoxFit.fitHeight,width: 140,height: 140,)
                        // child: Image.asset(path,
                        //     width: 150.0, height: 150.0),
                      ),
                    
                  ),
    )
              // InkWell(
              //     onTap: () {}, // Image tapped
              //     splashColor: Colors.white10, // Splash color over image
              //     child: Ink.image(
              //       fit: BoxFit.cover, // Fixes border issues
              //       width: 100,
              //       height: 100,
              //       image: AssetImage(
              //         path,
              //       ),
              //     ),
              //   )
          //    ElevatedButton.icon(
          //      icon: ImageIcon(
          //   AssetImage(path),
          //   size: 24,
            
          // ), label: Text(name), 
          // onPressed: () {  
          //   print('Pressed');
          // },
          

          //    )
              // icon,
              
              // SizedBox(height: 10,),
              // Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      // ),
    );
  }
}
