import 'package:aub_pickusup/pages/choose_type.dart';
import 'package:aub_pickusup/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator if the stream is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.emailVerified) {
              // Check if the user ID exists in the database
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator if the user snapshot is still loading
                    return const CircularProgressIndicator();
                  } else if (userSnapshot.hasData &&
                      userSnapshot.data!.exists) {
                    Fluttertoast.showToast(
                      msg: 'Signed in Successfully',
                    );
                    return const ChooseUserType();
                  } else {
                    // User doesn't exist anymore, sign out
                    FirebaseAuth.instance.signOut();
                    return const SignInPage();
                  }
                },
              );
            }
          }

          // Default to the sign-in page
          return const SignInPage();
        },
      ),
    );
  }
}
