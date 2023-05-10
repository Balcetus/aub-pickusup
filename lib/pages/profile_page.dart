// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final userEmail = user!.email;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: aubRed,
        elevation: 5,
        leading: null,
        automaticallyImplyLeading: false,
        toolbarHeight: 150,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(70, 40),
            bottomRight: Radius.elliptical(70, 40),
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: aubRed,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            'PROFILE',
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 10.0,
              color: Colors.white,
              fontFamily: 'JosefinSans',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: aubRed,
                  width: 4.0,
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                foregroundImage: AssetImage('assets/logo.png'),
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$userDisplayName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$userEmail',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle edit profile button action
              },
              child: const Text('Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
