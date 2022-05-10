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
