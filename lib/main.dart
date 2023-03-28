import 'package:aub_pickusup/pages/auth_page.dart';
import 'package:aub_pickusup/pages/home_page.dart';
import 'package:aub_pickusup/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
      fontFamily: 'Jost',
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.orange.shade200,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.orange.shade200,
          outline: Colors.orange.shade200),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          '/home': (context) => HomePage(),
          '/signin': (context) => const SignInPage(),
        });
  }
}
