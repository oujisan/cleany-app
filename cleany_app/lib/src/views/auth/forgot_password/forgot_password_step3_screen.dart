import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/forgot_password_provider.dart';

class ForgotPasswordStep3Screen extends StatelessWidget{
  const ForgotPasswordStep3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 160,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 24,
                        ), // atau sesuaikan nilainya
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 1,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.secondary,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    "Please enter your \n new password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Consumer<ForgotPasswordProvider>(
            builder: (context, forgotPasswdProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 28),

                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        forgotPasswdProvider.setNewPasswdTouched();
                      }
                    },
                    child: TextField(
                      onChanged: forgotPasswdProvider.setNewPasswd,
                      obscureText: !forgotPasswdProvider.isNewPasswdVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Password',
                        errorText:
                            forgotPasswdProvider.isNewPasswdTouched
                                ? forgotPasswdProvider.newPasswd.isEmpty
                                    ? "Password cannot be empty"
                                    : forgotPasswdProvider.newPasswd.trim().isEmpty
                                    ? "Password cannot be whitespace only"
                                    : !forgotPasswdProvider.isPasswordValid
                                    ? "At least 8 characters and contains one number"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            forgotPasswdProvider.isNewPasswdVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: forgotPasswdProvider.toggleNewPasswdVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        forgotPasswdProvider.setConfirmNewPasswdTouched();
                      }
                    },
                    child: TextField(
                      onChanged: forgotPasswdProvider.setConfirmNewPasswd,
                      obscureText: !forgotPasswdProvider.isConfirmNewPasswdVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm New Password',
                        errorText:
                            forgotPasswdProvider.isConfirmNewPasswdTouched
                                ? forgotPasswdProvider.confirmNewPasswd.isEmpty
                                    ? "Confirm password cannot be empty"
                                    : !forgotPasswdProvider.isPasswordMatch
                                    ? "Password doesn't match"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            forgotPasswdProvider.isConfirmNewPasswdVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              forgotPasswdProvider.toggleConfirmNewPasswdVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  GestureDetector(
                    onTap: () {
                      if (forgotPasswdProvider.isPasswordMatch && forgotPasswdProvider.isPasswordValid) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                      else {
                        null;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            forgotPasswdProvider.isPasswordMatch && forgotPasswdProvider.isPasswordValid
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}