import 'package:cleany_app/src/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class CleanerScreen extends StatelessWidget {
  const CleanerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
