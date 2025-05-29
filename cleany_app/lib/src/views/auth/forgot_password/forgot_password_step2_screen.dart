import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/forgot_password_provider.dart';

class ForgotPasswordStep2Screen extends StatelessWidget {
  const ForgotPasswordStep2Screen({super.key});

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
                              value: 0.66,
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

                const SizedBox(height: 36),

                const Center(
                  child: Text(
                    "Please enter code",
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

                  PinCodeTextField(
                    onChanged: forgotPasswdProvider.setVerifcode,
                    appContext: context,
                    animationType: AnimationType.none,
                    textStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    length: 6,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      activeColor: AppColors.grey,
                      selectedColor: AppColors.secondary,
                      inactiveColor: AppColors.grey,
                      disabledColor: AppColors.grey,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 50,
                    ),
                  ),

                  SizedBox(height: 60),

                  GestureDetector(
                    onTap: () {
                      if (forgotPasswdProvider.isVerificationCodeValid) {
                        Navigator.pushNamed(context, '/forgot-password-step3');
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
                            forgotPasswdProvider.isVerificationCodeValid
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Next',
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
