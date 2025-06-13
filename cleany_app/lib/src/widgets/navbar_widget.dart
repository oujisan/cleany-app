import 'package:cleany_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/navbar_provider.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNav = Provider.of<NavbarProvider>(context);
    final currentIndex = bottomNav.currentIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      unselectedItemColor: AppColors.grey,
      selectedItemColor: AppColors.primary,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        bottomNav.setIndex(index);

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/cleaner');
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, '/history', (route) => false);
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cleaning_services),
          label: 'Cleaner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
