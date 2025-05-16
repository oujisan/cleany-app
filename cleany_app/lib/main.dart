import 'package:cleany_app/src/views/home_page.dart';
import 'package:cleany_app/src/views/profile_page.dart';
import 'package:cleany_app/src/views/register_page.dart';
import 'package:cleany_app/src/views/taskform_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/views/splash_page.dart';
import 'package:cleany_app/src/views/login_page.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUserFromStorage();

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'Cleany App',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/profile': (context) => ProfilePage(),
          '/home': (context) => HomeScreen(),
          '/add': (context) => const CleaningTaskFormScreen(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
        ),
        builder: DevicePreview.appBuilder, // tetap pakai device preview
      ),
    );
  }
}
