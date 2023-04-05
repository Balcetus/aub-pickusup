import 'package:aub_pickusup/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final IconData specIcon;
  final TextEditingController controller1;
  final TextInputType? inputType;

  const MyTextField(
      {super.key,
      required this.obscureText,
      required this.specIcon,
      required this.controller1,
      required this.labelText,
      this.inputType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
      child: TextFormField(
        controller: controller1,
        obscureText: obscureText,
        keyboardType: inputType,
        maxLength: obscureText == false ? null : null,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: labelText,
          fillColor: aubRed,
          filled: true,
          labelStyle: const TextStyle(color: aubGrey),
          prefixIcon: Icon(specIcon, color: Colors.white, size: 22),
          counterText: '',
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
