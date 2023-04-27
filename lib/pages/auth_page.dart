import 'package:aub_pickusup/pages/home_page.dart';
import 'package:aub_pickusup/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              FirebaseAuth.instance.currentUser!.emailVerified) {
            return HomePage();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
