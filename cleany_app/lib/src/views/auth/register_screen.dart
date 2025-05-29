import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
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
          child: Consumer<RegisterProvider>(
            builder: (context, registerProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 8),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        registerProvider.setFirstNameTouched();
                      }
                    },
                    child: TextField(
                      onChanged: registerProvider.setFirstName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        errorText:
                            registerProvider.isFirstNameTouched
                                ? registerProvider.firstName.isEmpty
                                    ? 'First name is required'
                                    : registerProvider.firstName.trim().isEmpty
                                    ? 'First name cannot whitespace'
                                    : null
                                : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  TextField(
                    onChanged: registerProvider.setLastName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                  ),

                  SizedBox(height: 32),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        registerProvider.setUsernameTouched();
                      }
                    },
                    child: TextField(
                      onChanged: registerProvider.setUsername,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        errorText:
                            registerProvider.isUsernameTouched
                                ? registerProvider.username.isEmpty
                                    ? 'Username is required'
                                    : registerProvider.username.trim().isEmpty
                                    ? 'Username cannot whitespace'
                                    : registerProvider.username.length < 3
                                    ? 'Username must be at least 3 characters'
                                    : !registerProvider.isUsernameValid
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
                        registerProvider.setEmailTouched();
                      }
                    },
                    child: TextField(
                      onChanged: registerProvider.setEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorText:
                            registerProvider.isEmailTouched
                                ? registerProvider.email.isEmpty
                                    ? 'Email is required'
                                    : registerProvider.email.trim().isEmpty
                                    ? 'Email cannot whitespace'
                                    : !registerProvider.isEmailValid
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
                        registerProvider.setPasswordTouched();
                      }
                    },
                    child: TextField(
                      onChanged: registerProvider.setPassword,
                      obscureText: !registerProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        errorText:
                            registerProvider.isPasswordTouched
                                ? registerProvider.password.isEmpty
                                    ? "Password cannot be empty"
                                    : registerProvider.password.trim().isEmpty
                                    ? "Password cannot be whitespace only"
                                    : !registerProvider.isPasswordValid
                                    ? "At least 8 characters and contains one number"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            registerProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: registerProvider.togglePasswordVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  Focus(
                    onFocusChange: (onFocus) {
                      if (!onFocus) {
                        registerProvider.setConfirmPasswordTouched();
                      }
                    },
                    child: TextField(
                      onChanged: registerProvider.setConfirmPassword,
                      obscureText: !registerProvider.isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        errorText:
                            registerProvider.isConfirmPasswordTouched
                                ? registerProvider.confirmPassword.isEmpty
                                    ? "Confirm password cannot be empty"
                                    : !registerProvider.isPasswordMatch
                                    ? "Password doesn't match"
                                    : null
                                : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            registerProvider.isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              registerProvider.toggleConfirmPasswordVisibility,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  GestureDetector(
                    onTap: () {
                      if (registerProvider.isFormValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Registration Successfull"),
                            action: SnackBarAction(label: "OK", onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },),
                            duration: Duration(seconds: 1),
                          )
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
                            registerProvider.isFormValid
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: Row(
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
