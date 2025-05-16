import 'package:cleany_app/src/views/home_page.dart';
import 'package:cleany_app/src/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 118),
        Image.asset('assets/images/Logo with text.png', width: 310, height: 70),
        const SizedBox(height: 54),

        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),

        const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 32),

        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? "),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            "Forget Password?",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
