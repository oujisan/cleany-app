import 'package:cleany_app/src/views/profile_page.dart';
import 'package:cleany_app/src/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(
  DevicePreview(enabled: !kReleaseMode, builder: (context) => const MainApp()),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: RegisterScreen(),
    );
  }
}
