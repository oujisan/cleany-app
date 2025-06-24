import 'package:flutter/material.dart';
import 'package:cleany_app/src/widgets/navbar_widget.dart';

class PlaceholderScreen extends StatelessWidget{
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Placeholder")),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}