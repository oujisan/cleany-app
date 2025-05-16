import 'package:cleany_app/core/font.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:cleany_app/src/widgets/navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  Widget getContent() {
    switch (selectedTab) {
      case 0:
        return const Center(child: Text('Daftar Tugas'));
      case 1:
        return const Center(child: Text('Sedang Diproses'));
      case 2:
        return const Center(child: Text('Selesai'));
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.image, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        'Hello, Asep Kasep',
                        style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications, color: Color(0xFF009688), size: 32),
                ],
              ),
              const SizedBox(height: 8),
              // Tanggal
              Text(
                currentDate,
                style: AppFonts.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TaskTabSwitcher(
                currentIndex: selectedTab,
                onTabSelected: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(child: getContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskTabSwitcher extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const TaskTabSwitcher({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tugas', 'Proses', 'Selesai'];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00796B) : const Color(0xFF009688),
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(15) : Radius.zero,
                  topRight: index == tabs.length - 1 ? const Radius.circular(15) : Radius.zero,
                  bottomLeft: index == 0 ? const Radius.circular(15) : Radius.zero,
                  bottomRight: index == tabs.length - 1 ? const Radius.circular(15) : Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
