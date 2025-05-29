import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/core/colors.dart';

import 'src/views/splash_screen.dart';
import 'src/views/auth/login_screen.dart';
import 'src/views/auth/register_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step1_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step2_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step3_screen.dart';

import 'package:cleany_app/src/providers/login_provider.dart';
import 'package:cleany_app/src/providers/register_provider.dart';
import 'package:cleany_app/src/providers/forgot_password_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()), // Proviuder
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()), // Proviuder
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'Cleany App',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/forgot-password': (context) => ForgotPasswordStep1Screen(),
          '/forgot-password-step2': (context) => ForgotPasswordStep2Screen(),
          '/forgot-password-step3': (context) => ForgotPasswordStep3Screen(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
          fontFamily: 'Poppins',
        ),
        builder: DevicePreview.appBuilder, // tetap pakai device preview
      ),
    );
  }
}
