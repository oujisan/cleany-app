import 'package:cleany_app/src/views/login_page.dart';
import 'package:cleany_app/src/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MainApp(), // Wrap your app
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cleany",
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: RegisterScreen(),
    );
  }
}
