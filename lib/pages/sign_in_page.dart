import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:aub_pickusup/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late UserCredential credentials;

  Future<void> userSignIn(BuildContext context) async {
    final userEmail = emailController.text.trim();
    final userPassword = passwordController.text.trim();

    if (userEmail.isNotEmpty && userPassword.isNotEmpty) {
      // show loading dialog
      showLoadingDialog();

      try {
        credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
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
          Fluttertoast.showToast(msg: e.code.toString());
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTextField passwordTextField = MyTextField(
      inputType: TextInputType.text,
      obscureText: true,
      specIcon: Icons.password_rounded,
      controller1: passwordController,
      labelText: 'Password',
    );

    MyTextField emailTextField = MyTextField(
      inputType: TextInputType.emailAddress,
      obscureText: false,
      specIcon: Icons.email_rounded,
      controller1: emailController,
      labelText: 'Email',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          'SIGN IN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 10.0,
            color: aubRed,
            fontFamily: 'JosefinSans',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0.0, 0.0, 180.0),
                ),
                SizedBox(
                  height: 80,
                  child: emailTextField,
                ),
                SizedBox(
                  height: 80,
                  child: passwordTextField,
                ),
                confirmSignIn(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 160, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'don\'t have an account?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.right,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/register', (route) => false);
                        },
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 16,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(),
                      color: aubRed,
                    ),
                    child: const Text(
                      'Please use your AUBnet Credentials',
                      style: TextStyle(fontSize: 17, color: aubGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton confirmSignIn() {
    return MaterialButton(
      onPressed: () {
        userSignIn(context);
      },
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        side: BorderSide(width: 0),
      ),
      highlightColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
      child: const Text(
        'CONFIRM',
        style: TextStyle(
          color: aubRed,
          fontSize: 18,
          letterSpacing: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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

  showLoadingDialog() {
    return showDialog(
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.9),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.twistingDots(
              leftDotColor: aubRed, rightDotColor: Colors.white, size: 80),
        );
      },
    );
  }
}
