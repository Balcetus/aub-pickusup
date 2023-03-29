import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:aub_pickusup/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

  Future<void> signUpRequest(BuildContext context) async {
    // final User? currentFirebaseUser =
    //     (await _firebaseAuth.createUserWithEmailAndPassword(
    //             email: emailController.text.trim(),
    //             password: passwordController.text.trim()))
    //         .user;

    // if (currentFirebaseUser != null) {
    // } else {}
  }

  Future<void> userSignIn() async {
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
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MyTextField passwordTextField = MyTextField(
        inputType: TextInputType.text,
        obscureText: true,
        specIcon: Icons.password_rounded,
        controller1: passwordController,
        labelText: 'Password');

    MyTextField emailTextField = MyTextField(
        inputType: TextInputType.emailAddress,
        obscureText: false,
        specIcon: Icons.email_rounded,
        controller1: emailController,
        labelText: 'Email');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: welcomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 120.0, 0.0, 100.0),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 16.0),
                  ),
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
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim())
                        .then((_) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/verify', (route) => false);
                    });
                  },
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    side: BorderSide(width: 0),
                  ),
                  highlightColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                  child: const Text(
                    'SignUp',
                    style: TextStyle(
                        color: aubRed,
                        fontSize: 18,
                        letterSpacing: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 220, 0, 0),
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                      ),
                      color: aubRed,
                    ),
                    child: const Text(
                      'Please log in using your AUBnet Credentials',
                      style: TextStyle(fontSize: 17),
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
        userSignIn();
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
            fontWeight: FontWeight.bold),
      ),
    );
  }

  AppBar welcomeAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: const Text(
        'WELCOME',
        style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 16.0,
            color: aubRed,
            fontFamily: 'JosefinSans'),
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

  Future<dynamic> showLoadingDialog() {
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
