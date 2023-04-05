import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:aub_pickusup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController fullnameController = TextEditingController();
  late final TextEditingController phoneController = TextEditingController();
  late UserCredential credentials;

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

    MyTextField fullnameTextField = MyTextField(
        inputType: TextInputType.name,
        obscureText: false,
        specIcon: Icons.person_2_rounded,
        controller1: fullnameController,
        labelText: 'Full Name');

    MyTextField phoneTextField = MyTextField(
        inputType: TextInputType.phone,
        obscureText: false,
        specIcon: Icons.phone_rounded,
        controller1: phoneController,
        labelText: 'Phone Number');

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
          'REGISTER',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 10.0,
              color: aubRed,
              fontFamily: 'JosefinSans'),
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
                  padding: EdgeInsets.fromLTRB(0, 0.0, 0.0, 100.0),
                ),
                SizedBox(
                  height: 80,
                  child: fullnameTextField,
                ),
                SizedBox(
                  height: 80,
                  child: phoneTextField,
                ),
                SizedBox(
                  height: 80,
                  child: emailTextField,
                ),
                SizedBox(
                  height: 80,
                  child: passwordTextField,
                ),
                confirmRegister(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('already have an account? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.right),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/signin', (route) => false);
                        },
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 16,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
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

  MaterialButton confirmRegister() {
    return MaterialButton(
      onPressed: () {
        List<String> validationErrors = [];

        if (fullnameController.text.length < 5) {
          validationErrors.add('Name must be at least 5 characters');
        }
        if (!emailController.text.trim().endsWith('@mail.aub.edu')) {
          validationErrors.add('Email must end with @mail.aub.edu');
        }
        if (phoneController.text.isEmpty) {
          validationErrors.add('Phone number is mandatory');
        }
        if (passwordController.text.trim().length < 6) {
          validationErrors.add('Password must be at least 6 characters');
        }

        if (validationErrors.isNotEmpty) {
          Fluttertoast.showToast(msg: validationErrors.join('\n'));
          return;
        }

        registerNewUser(context);
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

  // Future<void> signUpRequest(BuildContext context) async {
  //   await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim())
  //       .then((_) {
  //     Navigator.pushNamedAndRemoveUntil(context, '/verify', (route) => false);
  //   });
  // }

  Future<void> addUserDetails(BuildContext context) async {
    try {
      await userRef.add(
        {
          'fullname': fullnameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );
    } catch (e) {
      throw Exception('Failed to add user details: $e');
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> registerNewUser(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        Fluttertoast.showToast(msg: 'Account created successfully');
        await addUserDetails(context);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        Fluttertoast.showToast(msg: 'new user has not been created');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      rethrow;
    }
  }
}
