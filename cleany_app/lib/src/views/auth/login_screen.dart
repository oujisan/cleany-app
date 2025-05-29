import 'package:cleany_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:cleany_app/src/providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 200,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', width: 50, height: 50),

                const SizedBox(height: 16),

                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Login to your account',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<LoginProvider>(
              builder: (context, loginProvider, child) {
                return Column(
                  children: [
                    const SizedBox(height: 8),

                    // Email Textfield
                    Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          loginProvider.setEmailTouched();
                        }
                      },
                      child: TextField(
                        onChanged: loginProvider.setEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorText:
                              loginProvider.isEmailTouched
                                  ? loginProvider.email.isEmpty
                                      ? "Email cannot be empty"
                                      : loginProvider.email.trim().isEmpty
                                      ? "Email cannot be whitespace only"
                                      : !loginProvider.isEmailValid
                                      ? "Invalid Email"
                                      : null
                                  : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Password Textfield
                    Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          loginProvider.setPasswordTouched();
                        }
                      },
                      child: TextField(
                        onChanged: loginProvider.setPassword,
                        obscureText: !loginProvider.isPasswordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          errorText:
                              loginProvider.isPasswordTouched
                                  ? loginProvider.password.isEmpty
                                      ? "Password cannot be empty"
                                      : loginProvider.password.trim().isEmpty
                                      ? "Password cannot be whitespace only"
                                      : null
                                  : null,
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginProvider.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: loginProvider.togglePasswordVisibility,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Forgot Password Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.only(right: 4),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Login Button
                    GestureDetector(
                      onTap: () {
                        if (loginProvider.isEmailValid &&
                            loginProvider.password.trim().isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Login successful!'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  }
                                ),
                              ),
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
                              loginProvider.isEmailValid &&
                                      loginProvider.password.trim().isNotEmpty
                                  ? AppColors.primary
                                  : AppColors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Register button + text
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/register',
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
