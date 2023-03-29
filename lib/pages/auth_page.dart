import 'package:aub_pickusup/pages/sign_in_page.dart';
import 'package:aub_pickusup/pages/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred, please try again later.'),
            );
          }
          return Center(
            child: snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator(
                    backgroundColor: Colors.orange.shade200,
                  )
                : snapshot.hasData
                    ? const VerifyPage()
                    : const SignInPage(),
          );
        },
      ),
    );
  }
}
