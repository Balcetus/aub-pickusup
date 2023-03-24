import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final IconData? specIcon;
  final controller;
  final double topPadding;

  const MyTextField({
    super.key,
    required this.obscureText,
    required this.specIcon,
    required this.controller,
    required this.topPadding,
    required this.labelText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(70, topPadding, 70, 0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.zero),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.orange[200]),
          prefixIcon: Icon(specIcon, color: Colors.orange[200]),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
