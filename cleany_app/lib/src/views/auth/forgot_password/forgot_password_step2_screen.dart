import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class ForgotPasswordStep2Screen extends StatelessWidget {
  const ForgotPasswordStep2Screen({super.key});

  Future<void> _handleVerifyCode(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final isSuccess = await authProvider.verifyCode();
    if (isSuccess) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Code verified successfully. Redirecting to password setup...",
          ),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushNamed(context, '/forgot-password-step3');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${authProvider.message}! ${authProvider.error}"),
        ),
      );
    }
    authProvider.toggleVerifyCodeButton();
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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  SizedBox(height: 28),

                  PinCodeTextField(
                    onChanged: authProvider.setVerifcode,
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
                      if (
                          authProvider.isVerificationCodeValid &&
                          authProvider.verifyCodeButton &&
                          !authProvider.isLoading
                        ) {
                        authProvider.isLoading
                            ? null
                            : authProvider.toggleVerifyCodeButton();
                        _handleVerifyCode(context, authProvider);
                      } else {
                        null;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            authProvider.isVerificationCodeValid &&
                            authProvider.verifyCodeButton &&
                            !authProvider.isLoading
                                ? AppColors.primary
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: authProvider.isLoading
                          ? CircularProgressIndicator(
                            color: AppColors.white,
                          )
                          : Text(
                          'Verification',
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
