import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 220.0, 0.0, 0.0),
              child: Text(
                'WELCOME',
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 15.0,
                    color: Colors.orange[200],
                    fontFamily: 'JosefinSans'),
              ),
            ),
            Divider(
              height: 20.0,
              thickness: 2,
              color: Colors.orange[200],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12.0, 0.0, 0.0),
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.all(Radius.zero)),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.orange[200]),
                  fillColor: Colors.amber[200],
                ),
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
