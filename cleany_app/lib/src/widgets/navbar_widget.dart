import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF00796B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home, 0, selectedIndex, onItemTapped,),
          _buildNavItem(Icons.cleaning_services, 1, selectedIndex, onItemTapped),
          _buildNavItem(Icons.add_circle, 2, selectedIndex, onItemTapped),
          _buildNavItem(Icons.history, 3, selectedIndex, onItemTapped),
          _buildNavItem(Icons.person, 4, selectedIndex, onItemTapped),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int selectedIndex, Function(int) onTap, {Color? color}) {
    return IconButton(
      icon: Icon(
        icon,
        color: color ?? (index == selectedIndex ? Colors.white : Colors.white70),
      ),
      onPressed: () => onTap(index),
    );
  }
}
