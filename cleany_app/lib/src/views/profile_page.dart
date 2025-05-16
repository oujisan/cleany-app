import 'package:cleany_app/src/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 4,
        onItemTapped: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/cleaning');
              break;
            case 2:
              Navigator.pushNamed(context, '/add');
              break;
            case 3:
              Navigator.pushNamed(context, '/history');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Your Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: const Icon(Icons.image, size: 64),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
