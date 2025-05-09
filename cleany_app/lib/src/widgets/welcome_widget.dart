import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/core/font.dart';
import 'package:flutter/material.dart';

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
        style: AppFonts.button.copyWith(
          color: AppColors.white,
        ),
      ),
    )
    );
  }
}
