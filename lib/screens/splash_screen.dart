import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/screens/task_screen.dart';
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

    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool isLoggedIn = sp.getBool('isLoggedIn') ?? false;

    if (mounted) {
      if (isLoggedIn) {
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
              image: AssetImage(
                "assets/images/logo.png",
              ), // Ensure this asset exists
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
