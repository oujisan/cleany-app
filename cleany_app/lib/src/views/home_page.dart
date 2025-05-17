import 'package:cleany_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';
import 'package:cleany_app/src/providers/task_provider.dart';
import 'package:cleany_app/core/font.dart';
import 'package:intl/intl.dart';
import 'package:cleany_app/src/widgets/navbar_widget.dart';
import 'package:cleany_app/src/models/task_response_model.dart';
import 'package:cleany_app/src/views/task_detail_page.dart';
import 'add_task_report_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  List<String> getTabs(String? role) {
    if (role == 'cleaner') {
      return ['Report', 'Routine'];
    } else {
      return ['Report'];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'in_progress':
        return Colors.blue.shade700;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  Widget getContent(List<String> tabs) {
    if (tabs.length == 1) {
      // Hanya tab Report
      return const Center(child: Text('Report Only'));
    }
    switch (selectedTab) {
      case 0:
        return StreamBuilder<List<TaskResponseModel>>(
          stream:
              Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tasks found.'));
            } else {
              final tasks = snapshot.data!;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.taskTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.areaName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  task.status,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(task.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      case 1:
        // Tab Routine
        return const Center(child: Text('Routine Tasks'));
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username ?? '';
    final role = authProvider.role ?? '';

    final currentDate = DateFormat(
      'EEEE, d MMMM y',
      'id_ID',
    ).format(DateTime.now());
    final tabs = getTabs(role);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onItemTapped: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/cleaning');
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTaskReportScreen()));
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(
                          Icons.person,
                          color: Colors.teal.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: AppFonts.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            role,
                            style: AppFonts.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: Colors.teal.shade700,
                        size: 32,
                      ),
                      // Positioned(
                      //   right: 0,
                      //   top: 0,
                      //   child: Container(
                      //     width: 10,
                      //     height: 10,
                      //     decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(color: Colors.white, width: 1.5),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Colors.teal, // warna sesuai tema, bisa disesuaikan
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currentDate,
                    style: AppFonts.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 16,
                      letterSpacing: 0.5,
                      height: 1.3,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tab Switcher jika ada lebih dari 1 tab
              if (tabs.length > 1)
                TaskTabSwitcher(
                  currentIndex: selectedTab,
                  onTabSelected: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  tabs: tabs,
                ),

              if (tabs.length > 1) const SizedBox(height: 16),

              // Content (List task atau placeholder)
              Expanded(child: getContent(tabs)),
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
  final List<String> tabs;

  const TaskTabSwitcher({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
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
                color:
                    isSelected
                        ? const Color(0xFF00796B)
                        : const Color(0xFF009688),
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(15) : Radius.zero,
                  topRight:
                      index == tabs.length - 1
                          ? const Radius.circular(15)
                          : Radius.zero,
                  bottomLeft:
                      index == 0 ? const Radius.circular(15) : Radius.zero,
                  bottomRight:
                      index == tabs.length - 1
                          ? const Radius.circular(15)
                          : Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: const TextStyle(
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
