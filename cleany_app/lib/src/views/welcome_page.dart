import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/font.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Just logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 55),
              Text(
                'Welcome to',
                style: AppFonts.headingLarge.copyWith(color: AppColors.black),
              ),
              Text(
                'Cleany App',
                style: AppFonts.headingLarge.copyWith(color: AppColors.black),
              ),
              Text(
                'Clean Made Simple',
                style: AppFonts.headingSmall,
              ),
              const SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  const SizedBox(width: 26),
                  CustomButton(
                    text: "Register",
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        child: Text(
          text,
          style: AppFonts.button.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
