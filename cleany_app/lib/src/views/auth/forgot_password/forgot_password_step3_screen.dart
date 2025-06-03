import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class ForgotPasswordStep3Screen extends StatelessWidget {
  const ForgotPasswordStep3Screen({super.key});

  Future<void> _handleResetPassword(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final isSuccess = await authProvider.resetPassword();

    if (isSuccess) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset Password Successfully! Redirecting to login..."),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${authProvider.message}! ${authProvider.error}"),
        ),
      );
    }
    authProvider.toggleResetPasswordButton();
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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 28),

                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        authProvider.setPasswordTouched();
                      }
                    },
                    child: TextField(
                      onChanged: authProvider.setPassword,
                      obscureText: !authProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Password',
                        errorText:
                            authProvider.isPasswordTouched
                                ? authProvider.password.isEmpty
                                    ? "Password cannot be empty"
                                    : authProvider.password.trim().isEmpty
                                    ? "Password cannot be whitespace only"
                                    : !authProvider.isPasswordValid
                                    ? "At least 8 characters and contains one number"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: authProvider.togglePasswordVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        authProvider.setConfirmPasswordTouched();
                      }
                    },
                    child: TextField(
                      onChanged: authProvider.setConfirmPassword,
                      obscureText: !authProvider.isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm New Password',
                        errorText:
                            authProvider.isConfirmPasswordTouched
                                ? authProvider.confirmPassword.isEmpty
                                    ? "Confirm password cannot be empty"
                                    : !authProvider.isPasswordMatch
                                    ? "Password doesn't match"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              authProvider.toggleConfirmPasswordVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  GestureDetector(
                    onTap: () {
                      if (authProvider.isPasswordMatch &&
                          authProvider.isPasswordValid &&
                          !authProvider.isLoading &&
                          authProvider.resetPasswordButton) {
                        authProvider.toggleResetPasswordButton();
                        _handleResetPassword(context, authProvider);
                      } else {
                        null;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            authProvider.isPasswordMatch &&
                                    authProvider.isPasswordValid &&
                                    !authProvider.isLoading &&
                                    authProvider.resetPasswordButton
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child:
                            authProvider.isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
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
