import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/forgot_password_provider.dart';

class ForgotPasswordStep1Screen extends StatelessWidget {
  const ForgotPasswordStep1Screen({super.key});

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
                        padding: const EdgeInsets.only(right: 24),
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.33,
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
                    "Please enter your\nemail address",
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
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        forgotPasswdProvider.setEmailTouched();
                      }
                    },
                    child: TextField(
                      onChanged: forgotPasswdProvider.setEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorText:
                            forgotPasswdProvider.isEmailTouched
                                ? forgotPasswdProvider.email.isEmpty
                                    ? 'Email is required'
                                    : forgotPasswdProvider.email.trim().isEmpty
                                    ? 'Email cannot be whitespace only'
                                    : !forgotPasswdProvider.isEmailValid
                                    ? 'Invalid email format'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  GestureDetector(
                    onTap: () {
                      if (forgotPasswdProvider.isEmailValid &&
                          !forgotPasswdProvider.isCooldown) {
                        forgotPasswdProvider.setCooldown();
                        forgotPasswdProvider.startTimer();
                        Navigator.pushNamed(context, '/forgot-password-step2');
                      } else {
                        null;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            forgotPasswdProvider.isEmailValid &&
                                    !forgotPasswdProvider.isCooldown
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Send Code',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  if (forgotPasswdProvider.isCooldown)
                    Text(
                      'Resend code in ${forgotPasswdProvider.durationInString} seconds',
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
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
