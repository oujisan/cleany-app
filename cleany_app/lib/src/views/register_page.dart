import 'package:cleany_app/src/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart'; // Gunakan Colors.teal jika tidak punya AppColors

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/Logo with text.png',
          width: 310,
          height: 70,
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),

        const Text("Firstname", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),

        const Text("Lastname", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
     
        const Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),

       
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
              "Register",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),

        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Have an account? "),
            GestureDetector(
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
