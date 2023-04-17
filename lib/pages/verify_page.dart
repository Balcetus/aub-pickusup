import 'dart:async';
import 'package:aub_pickusup/main.dart';
import 'package:aub_pickusup/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  User? user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        checkEmailVerified();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          backgroundColor: aubRed,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.halfTriangleDot(
                    color: Colors.white, size: 50),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'An email has been sent to ${user?.email}, please verify. If you can\'t find it, check your Junk/Spam folder.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    // Navigator.restorablePushNamedAndRemoveUntil(context, '/signin', (route) => true);
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(120, 50))),
                  child: const Text('Cancel',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
