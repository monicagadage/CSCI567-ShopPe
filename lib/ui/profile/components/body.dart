import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup/screens/splash_screen.dart';
import 'package:signup/ui/notifications.dart';
import 'package:signup/ui/payment/add_card.dart';
import 'package:signup/ui/payment/paymentDetails.dart';
import 'package:signup/ui/profile.dart';
import 'package:signup/ui/settings.dart';

import '../../chatbot.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assest/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => Profile()))
            },
          ),
          ProfileMenu(
            text: "Payments",
            icon: "assest/icons/Cash.svg",
            press: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => PaymentDetails()));
            },
          ),
          ProfileMenu(
            text: "Add Card",
            icon: "assest/icons/receipt.svg",
            press: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => AddCard()));
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assest/icons/Bell.svg",
            press: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => Notifications()));
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assest/icons/Settings.svg",
            press: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => Settings()));
            },
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assest/icons/Question mark.svg",
            press: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => HomePageDialogflow()));
            },
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
        ],
      ),
    );
  }
}
