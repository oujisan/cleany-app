import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/font.dart';
import '../widgets/welcome_widget.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Just logo.png',
            width: 150,
            height: 150,
            ),
          SizedBox(height: 55),
          Text(
            'Welcome to',
            style: AppFonts.headingLarge.copyWith(
              color: AppColors.black),
            ),
          
          Text(
            'Cleany App',
            style: AppFonts.headingLarge.copyWith(
              color: AppColors.black)
            ),
            
          
          Text(
            'Clean Made Simple',
            style: AppFonts.headingSmall
            ),
          SizedBox(height: 55),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(text: "Login", onPressed: () {
              }),
              SizedBox(width: 26),
              CustomButton(text: "Register", onPressed: () {
              }),
            ],
          )
        ],
      )),
      )
    );

  }
}