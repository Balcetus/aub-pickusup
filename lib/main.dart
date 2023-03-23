import 'package:aub_pickusup/pages/signin.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignIn(),
        '/': (context) => const Home(),
        
      },
    ));
