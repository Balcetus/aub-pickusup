import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // Navigator.pushReplacementNamed(context, '/signin');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Text(
        'LOGGED IN SUCCESFULLY ${user!.email}',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
