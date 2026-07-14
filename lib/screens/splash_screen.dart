import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Check Firebase Auth current user
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TaskScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 100,
              width: 100,
              image: AssetImage("assets/images/logo.png"),
            ),
            SizedBox(height: 20),
            Text(
              "Taskly",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff203142),
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Color(0xffF9703B)),
          ],
        ),
      ),
    );
  }
}