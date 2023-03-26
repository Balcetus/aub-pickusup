import 'package:flutter/material.dart';

class ConfirmSignIn extends StatefulWidget {
  const ConfirmSignIn({super.key});

  @override
  State<ConfirmSignIn> createState() => _ConfirmSignInState();
}

class _ConfirmSignInState extends State<ConfirmSignIn> {
  final double _originalBorderRadius = 8.0;
  double _currentBorderRadius = 8.0;

  void _onPressed() {
    setState(() {
      _currentBorderRadius = 25;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentBorderRadius = _originalBorderRadius;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      color: Colors.orange[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_currentBorderRadius),
        ),
      ),
      highlightColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
      child: const Text(
        'CONFIRM',
        style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 10,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
