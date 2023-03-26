import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:aub_pickusup/components/confirm_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      controller: emailController,
                      labelText: 'Email'),
                ),
                SizedBox(
                  height: 80,
                  child: MyTextField(
                      obscureText: true,
                      specIcon: Icons.password_rounded,
                      controller: passwordController,
                      labelText: 'Password'),
                ),
                const ConfirmSignIn(),
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
}
