import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signup/firebase_options.dart';
import 'package:signup/screens/signin_screen.dart';
import 'package:signup/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoPe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}


<<<<<<< HEAD
// flutter run -d chrome --web-renderer html
=======
// flutter run -d chrome --web-renderer html


// add path reference field
// add quantity field
// add isliked field
// add add_to_cart field

// Category:
  // Shoes - size, color, add more images, description
  // T shirts - size(l, xl, xxl), color, add more images, description
  // Watch - description
>>>>>>> 41a1558e885682796439a0db210ce8a4246d0eba
