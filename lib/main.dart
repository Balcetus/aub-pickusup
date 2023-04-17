import 'package:aub_pickusup/pages/auth_page.dart';
import 'package:aub_pickusup/pages/home_page.dart';
import 'package:aub_pickusup/pages/register_page.dart';
import 'package:aub_pickusup/pages/sign_in_page.dart';
import 'package:aub_pickusup/pages/verify_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const Color aubRed = Color.fromRGBO(106, 19, 44, 1);
const Color aubGrey = Color.fromRGBO(197, 197, 197, 1);
final FirebaseFirestore db = FirebaseFirestore.instance;
final userRef = db.collection('users');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AUBPickUsUp(),
  );
}

class AUBPickUsUp extends StatelessWidget {
  const AUBPickUsUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Jost',
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: aubRed,
          secondary: aubRed,
          onSecondary: Colors.white,
          error: Colors.lightBlue,
          onError: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          outline: aubRed),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      title: 'AUB PickUsUp',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/home': (context) => HomePage(),
        '/signin': (context) => const SignInPage(),
        '/verify': (context) => const VerifyPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
