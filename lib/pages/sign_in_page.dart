import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final emailController = TextEditingController();
  late final passwordController = TextEditingController();

  void userSignIn() async {
    final userEmail = emailController.text.trim();
    final userPassword = passwordController.text.trim();

    showLoadingDialog();

    // show loading dialog
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      if (mounted) {
        Navigator.pop(context);
      } else {
        return;
      }

      // Do something with credentials
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongCredentials();
      } else if (e.code == 'wrong-password') {
        wrongCredentials();
      } else {
        await Navigator.pushNamedAndRemoveUntil(
            context, '/signin', (route) => false);
      }
    }
  }

  Future<dynamic> showLoadingDialog() {
    return showDialog(
      barrierColor: Colors.black,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Colors.orange.shade200,
              rightDotColor: Colors.white,
              size: 80),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var credentials;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'WELCOME',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 16.0,
                      color: Colors.orange[200],
                      fontFamily: 'JosefinSans'),
                ),
                Divider(
                  height: 20.0,
                  thickness: 2,
                  color: Colors.orange[200],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 110.0, 0.0, 110.0),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8.0),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: MyTextField(
                      obscureText: false,
                      specIcon: Icons.email_rounded,
                      controller1: emailController,
                      labelText: 'Email'),
                ),
                SizedBox(
                  height: 80,
                  child: MyTextField(
                      obscureText: true,
                      specIcon: Icons.password_rounded,
                      controller1: passwordController,
                      labelText: 'Password'),
                ),
                MaterialButton(
                  onPressed: () {
                    userSignIn();
                  },
                  color: Colors.orange[200],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  highlightColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        letterSpacing: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 220, 0, 0),
                    alignment: Alignment.center,
                    color: Colors.grey.shade900,
                    child: const Text(
                        'Please log in using your AUBnet Credentials',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUpRequest() {}

  void wrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Credentials'),
        );
      },
    );
  }
}
