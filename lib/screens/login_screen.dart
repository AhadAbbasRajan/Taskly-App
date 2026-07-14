import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'task_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final border = OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xffE4E7EB)),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill out all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TaskScreen()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff203142))),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: "Email", filled: true, fillColor: const Color(0xffF8F9FA), prefixIcon: const Icon(Icons.email, color: Color(0xff323F4B)), focusedBorder: border, enabledBorder: border),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Password", filled: true, fillColor: const Color(0xffF8F9FA), prefixIcon: const Icon(Icons.lock, color: Color(0xff323F4B)), focusedBorder: border, enabledBorder: border),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _isLoading ? null : _loginUser,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xffF9703B), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(fontSize: 16, color: Color(0xff4C5980))),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())),
                    child: const Text("Signup", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffF9703B))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}