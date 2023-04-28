import 'package:aub_pickusup/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_screen_driver.dart';
import 'main_screen_user.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        backgroundColor: aubRed,
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
          'WHAT ARE\nYOU?',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 10.0,
              color: Colors.white,
              fontFamily: 'JosefinSans'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainScreenUser()),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 310.0,
                    height: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('image/choose-user.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Hero(
                      tag: 'user',
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                          color: aubRed,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: const Text(
                          'User',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 45.0),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 310.0,
                    height: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      image: const DecorationImage(
                        image: AssetImage('image/choose-driver.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Hero(
                      tag: 'driver',
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0)),
                          color: aubBlue,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: const Text(
                          'Driver',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
