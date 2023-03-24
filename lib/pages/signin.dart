import 'package:aub_pickusup/components/my_textfield.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Text(
                'WELCOME',
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 15.0,
                    color: Colors.orange[200],
                    fontFamily: 'JosefinSans'),
              ),
              Divider(
                height: 20.0,
                thickness: 2,
                color: Colors.orange[200],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 12.0, 0.0, 0.0),
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      letterSpacing: 3.0),
                ),
              ),
              MyTextField(
                  obscureText: false,
                  specIcon: Icons.email_sharp,
                  controller: emailController,
                  topPadding: 70,
                  labelText: 'Email'),
              MyTextField(
                  obscureText: true,
                  specIcon: Icons.password_sharp,
                  controller: passwordController,
                  topPadding: 20,
                  labelText: 'Password'),
            ],
          ),
        ),
      ),
    );
  }
}
