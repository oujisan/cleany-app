import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';

import 'src/views/splash_screen.dart';
import 'src/views/auth/login_screen.dart';
import 'src/views/auth/register_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step1_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step2_screen.dart';
import 'src/views/auth/forgot_password/forgot_password_step3_screen.dart';
import 'src/views/home/home_screen.dart';
import 'src/views/user/user_screen.dart';
import 'src/views/task/add_report_task_screen.dart';
import 'src/views/task/report_task_detail.dart';
import 'package:cleany_app/src/views/task/add_routine_task_screen.dart';
import 'package:cleany_app/src/views/task/routine_task_detail.dart';
import 'package:cleany_app/src/views/history/history_screen.dart';
import 'package:cleany_app/src/views/user/profile_screen.dart';

import 'package:cleany_app/src/providers/auth_provider.dart';
import 'package:cleany_app/src/providers/navbar_provider.dart';
import 'package:cleany_app/src/providers/home_provider.dart';
import 'package:cleany_app/src/providers/task_provider.dart';
import 'package:cleany_app/src/providers/task_detail_provider.dart';
import 'package:cleany_app/src/providers/edit_task_provider.dart';
import 'package:cleany_app/src/providers/user_profile_provider.dart';
import 'package:cleany_app/src/providers/profile_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await dotenv.load(fileName: ".env");

  runApp(
    DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
      defaultDevice: Devices.android.samsungGalaxyS20,
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
        ChangeNotifierProvider(create: (_) => EditTaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
          '/cleaner': (context) => UserProfileView(),
          '/add-report-task': (context) => AddReportTaskScreen(),
          '/report-task-detail': (context) => ReportTaskDetailScreen(),
          '/routine-task-detail': (context) => RoutineTaskDetailScreen(),
          '/add-routine-task': (context) => AddRoutineTaskScreen(),
          '/history': (context) => HistoryScreen(),
          '/profile': (context) => ProfileScreen(),

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
