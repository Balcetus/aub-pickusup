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
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: aubRed,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 10.0,
            color: Colors.white,
            fontFamily: 'JosefinSans',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              foregroundImage: AssetImage('assets/logo.png'),
              radius: 50,
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
              onPressed: () {
                // Handle logout button action
                FirebaseAuth.instance.signOut();
                user?.reload();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
