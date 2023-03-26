import 'package:aub_pickusup/pages/signin.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Jost',
          colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.black,
              secondary: Colors.orange.shade200,
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.white,
              background: Colors.black,
              onBackground: Colors.white,
              surface: Colors.grey.shade200,
              onSurface: Colors.black,
              outline: Colors.orange[200]),
        ),
        initialRoute: '/signin',
        routes: {
          '/signin': (context) => const SignIn(),
          '/': (context) => const Home(),
        },
      ),
    );
