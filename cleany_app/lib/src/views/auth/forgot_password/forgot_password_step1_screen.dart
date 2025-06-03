import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class ForgotPasswordStep1Screen extends StatelessWidget {
  const ForgotPasswordStep1Screen({super.key});

  Future<void> _handleSendVerificationCode(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final isSuccess = await authProvider.forgotPassword();

    if (isSuccess) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Verification code has been sent to your email. Please check your inbox.",
          ),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      authProvider.setCooldown();
      authProvider.startTimer();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushNamed(context, '/forgot-password-step2');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${authProvider.message}! ${authProvider.error}"),
          duration: const Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
    }
    authProvider.toggleSendCodeButton();
  }

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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 28),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        authProvider.setEmailTouched();
                      }
                    },
                    child: TextField(
                      onChanged: authProvider.setEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorText:
                            authProvider.isEmailTouched
                                ? authProvider.email.isEmpty
                                    ? 'Email is required'
                                    : authProvider.email.trim().isEmpty
                                    ? 'Email cannot be whitespace only'
                                    : !authProvider.isEmailValid
                                    ? 'Invalid email format'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  GestureDetector(
                    onTap: () {
                      if (authProvider.isEmailValid &&
                          !authProvider.isCooldown &&
                          authProvider.sendCodeButton) {
                        authProvider.isLoading
                            ? null
                            : authProvider.toggleSendCodeButton();
                            _handleSendVerificationCode(
                              context,
                              authProvider,
                            );

                      } else {
                        null;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            authProvider.isEmailValid &&
                            !authProvider.isCooldown &&
                            !authProvider.isLoading &&
                            authProvider.sendCodeButton
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child:
                            authProvider.isLoading
                                ? CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                                : Text(
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

                  if (authProvider.isCooldown)
                    Text(
                      'Resend code in ${authProvider.durationInString} seconds',
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
