import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/views/splash_screen.dart';
import 'src/views/auth/login_screen.dart';
import 'src/views/auth/register_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step1_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step2_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step3_screen.dart';
import 'src/views/home/home_screen.dart';
import 'src/views/cleaner/cleaner_screen.dart';
import 'src/views/task/add_report_task_screen.dart';
import 'src/views/task/report_task_detail.dart';

import 'package:cleany_app/src/providers/auth_provider.dart';
import 'package:cleany_app/src/providers/navbar_provider.dart';
import 'package:cleany_app/src/providers/home_provider.dart';
import 'package:cleany_app/src/providers/task_provider.dart';
import 'package:cleany_app/src/providers/task_detail_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavbarProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => TaskDetailProvider()),

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
          '/home': (context) => HomeScreen(),
          '/cleaner': (context) => CleanerScreen(),
          '/add-task': (context) => AddReportTaskScreen(),
          '/task-detail': (context) => ReportTaskDetailScreen(),

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
