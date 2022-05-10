// import 'package:flutter/material.dart';
// import 'package:signup/const/AppColors.dart';
// import 'package:signup/ui/cart.dart';
// import 'package:signup/ui/favourite.dart';
// import 'package:signup/ui/home.dart';
// import 'package:signup/ui/profile/profile_screen.dart';
// import 'package:signup/ui/profile/components/body.dart';
// import 'package:signup/ui/profile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:signup/ui/search_screen.dart';

// class BottomNavController extends StatefulWidget {
//   @override
//   _BottomNavControllerState createState() => _BottomNavControllerState();
// }
// // @override
// // _BottomNavControllerState createState() => _BottomNavControllerState();

// // class _BottomNavControllerState extends State<BottomNavController> {
// //   final _pages = [
// //     Home(),
// //     Favourite(),
// //     Cart(),
// //     Profile(),
// //   ];
// //   var _currentIndex = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.red,
// //         elevation: 0,
// //         title: Text(
// //           "ShoPee",
// //           style: TextStyle(color: Colors.black),
// //         ),
// //         actions: <Widget>[
// //           new IconButton(onPressed: (){
// //             Navigator.push(
// //                 context, CupertinoPageRoute(builder: (_) => SearchScreen()));
// //           }, icon: Icon(Icons.search, color: Colors.white))
// //         ],
// //         centerTitle: true,
// //         automaticallyImplyLeading: false,
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         elevation: 5,
// //         selectedItemColor: AppColors.deep_orange,
// //         backgroundColor: Colors.white,
// //         unselectedItemColor: Colors.grey,
// //         currentIndex: _currentIndex,
// //         selectedLabelStyle:
// //             TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //         items: [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home),
// //             label: "Home",
// //           ),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.favorite_outline), label: "Favourite"),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.add_shopping_cart),
// //             label: "Cart",
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person),
// //             label: "Person",
// //           ),
// //         ],
// //         onTap: (index) {
// //           setState(() {
// //             _currentIndex = index;
// //             print(_currentIndex);
// //             Navigator.push(
// //                 context, MaterialPageRoute(builder: (_) => _pages[index]));
// //           });
// //         },
// //       ),
// //       body: _pages[_currentIndex],
// //     );
// //   }
// // }

// class _BottomNavControllerState extends State<BottomNavController> {
//   final _pages = [
//     Home(),
//     Favourite(),
//     Cart(),
//     ProfileBody(),
//   ];
//   var _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 255, 255, 255),
//           elevation: 0,
//           title: Text(
//             "ShoPe",
//             style: TextStyle(color: Colors.black),
//           ),
//           actions: <Widget>[
//             new IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       CupertinoPageRoute(builder: (_) => SearchScreen()));
//                 },
//                 icon:
//                     Icon(Icons.search, color: Color.fromARGB(255, 14, 12, 12)))
//           ],
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           elevation: 5,
//           selectedItemColor: AppColors.deep_orange,
//           backgroundColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           currentIndex: _currentIndex,
//           selectedLabelStyle:
//               TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite_outline), label: "Favourite"),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add_shopping_cart),
//               label: "Cart",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: "Profile",
//             ),
//           ],
//         ));
//   }
// }
// // @override
// //   Widget build(BuildContext context) {
// //     final Color inActiveIconColor = Color(0xFFB6B6B6);
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             offset: Offset(0, -15),
// //             blurRadius: 20,
// //             color: Color(0xFFDADADA).withOpacity(0.15),

// //           ),
// //         ],
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(40),
// //           topRight: Radius.circular(40),
// //         ),
// //       ),
// //       child: SafeArea(
// //           top: false,
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               IconButton(
// //                 icon: Icon(
// //                   Icons.home,
// //                   color: selectedMenu == "home"
// //                       ? Color(0xFFFF7643)
// //                       : inActiveIconColor,
// //                 ),
// //                 onPressed: () {
// //                   print("in home home home ");

// //                   if(selectedMenu != "home")
// //                     Navigator.push(
// //                       context, CupertinoPageRoute(builder: (_) => Home()));

// //                   // selectedMenu == "home" ? (){} : Home();
// //                 }
// //                 // if(selectedMenu != "home") Home();
// //               ),
// //               IconButton(
// //                 icon: Icon(
// //                     Icons.favorite_outline,
// //                   color: selectedMenu == "favorite"
// //                       ? Color(0xFFFF7643)
// //                       : inActiveIconColor,),
// //                 onPressed: () {
// //                   print("in favorite favorite favoritefavorite ");
// //                   if(selectedMenu != "favorite")
// //                   Navigator.push(
// //                       context, CupertinoPageRoute(builder: (_) => Favourite()));
// //                   },
// //               ),
// //               IconButton(
// //                 icon: Icon(Icons.add_shopping_cart),
// //                 onPressed: () {
// //                   print("in Cart Cart Cart ");
// //                   Navigator.push(
// //                       context, CupertinoPageRoute(builder: (_) => Cart()));
// //                   Cart(); },
// //               ),
// //               IconButton(
// //                 icon: Icon(
// //                   Icons.person,
// //                   color: selectedMenu == "profile"
// //                       ? Color(0xFFFF7643)
// //                       : inActiveIconColor,
// //                 ),
// //                 onPressed: () {
// //                   print("in Profile Profile Profile ");
// //                   if(selectedMenu != "profile")
// //                   Navigator.push(
// //                       context, CupertinoPageRoute(builder: (_) => Profile()));

// //                   // selectedMenu == "profile" ? (){} : Profile();
// //                 }
// //               ),
// //             ],
// //           )),
// //     );
// //   }

// //  }

// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:signup/const/AppColors.dart';
import 'package:signup/ui/cart.dart';
import 'package:signup/ui/favourite.dart';
import 'package:signup/ui/home.dart';
import 'package:signup/ui/profile/components/body.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  final _pages = [
    Home(),
    Favourite(),
    Cart(),
    ProfileBody(),
    // Profile(),
  ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   title: Text(
            //     "E-Commerce",
            //     style: TextStyle(color: Colors.black),
            //   ),
            //   centerTitle: true,
            //   automaticallyImplyLeading: false,
            // ),

            bottomNavigationBar: BottomNavigationBar(
              elevation: 5,
              selectedItemColor: AppColors.deep_orange,
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              selectedLabelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline), label: "Favourite"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_shopping_cart),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Person",
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  print(_currentIndex);
                });
              },
            ),
            body: _pages[_currentIndex],
          );
        });
  }
}
