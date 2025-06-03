import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Future<void> _handleRegister(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final isSuccess = await authProvider.register();
    if (!context.mounted) return;
    if (isSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful!"),
        ),
      );
      await Future.delayed(
        const Duration(seconds: 2),
      );
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${authProvider.message}! ${authProvider.error}"),
        ),
      );
    }
    authProvider.toggleRegisterButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 160,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', width: 50, height: 50),

                const SizedBox(height: 20),

                Text(
                  "Let's Get Started",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 8),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        authProvider.setFirstNameTouched();
                      }
                    },
                    child: TextField(
                      onChanged: authProvider.setFirstName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        errorText:
                            authProvider.isFirstNameTouched
                                ? authProvider.firstName.isEmpty
                                    ? 'First name is required'
                                    : authProvider.firstName.trim().isEmpty
                                    ? 'First name cannot whitespace'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  TextField(
                    onChanged: authProvider.setLastName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                  ),

                  SizedBox(height: 32),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        authProvider.setUsernameTouched();
                      }
                    },
                    child: TextField(
                      onChanged: authProvider.setUsername,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        errorText:
                            authProvider.isUsernameTouched
                                ? authProvider.username.isEmpty
                                    ? 'Username is required'
                                    : authProvider.username.trim().isEmpty
                                    ? 'Username cannot whitespace'
                                    : authProvider.username.length < 3
                                    ? 'Username must be at least 3 characters'
                                    : !authProvider.isUsernameValid
                                    ? 'contain only letters, numbers, and underscores'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

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
                                    ? 'Email cannot whitespace'
                                    : !authProvider.isEmailValid
                                    ? 'Invalid email format'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

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
                        labelText: 'Password',
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
                        labelText: 'Confirm Password',
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

                  SizedBox(height: 32),

                  GestureDetector(
                    onTap: () {
                      if (authProvider.isRegistrationFormValid) {
                        authProvider.isLoading
                            ? null
                            : authProvider.toggleRegisterButton();
                            _handleRegister(context, authProvider);
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration form is not valid!"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            authProvider.isRegistrationFormValid
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: authProvider.isLoading
                            ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            )
                            : Text(
                              'Register',
                              style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(right: 16),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
