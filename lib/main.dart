import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:aub_pickusup/authentication/signup_screen.dart';
import 'package:aub_pickusup/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';
import 'mainScreens/Choose.dart';
import 'mainScreens/main_screenDriver.dart';




Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return   GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage()
    );
  }
}
