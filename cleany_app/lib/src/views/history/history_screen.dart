import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/src/widgets/task_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/home_provider.dart';
import 'package:cleany_app/src/widgets/navbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:cleany_app/src/providers/task_detail_provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late Future<void> _initDataFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initDataFuture = _initializeData();

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        context.read<HomeProvider>().switchTabHistory(_tabController.index);
      }
    });
  }

  Future<void> _initializeData() async {
    final homeProvider = context.read<HomeProvider>();
    await homeProvider.initializeDataHistory();
    await homeProvider.refreshCurrentTasksHistory();

    if (homeProvider.role == 'user') {
      homeProvider.switchTab(1);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildTabSection(),
          _buildTasksList(),
          _buildBottomSpacing(),
        ],
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: true,
      title: const Text(
        'Halaman Riwayat',
        style: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabSection() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTabSelectorAndAddButton(),
            const SizedBox(height: 20),
            _buildSectionHeader(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelectorAndAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          if (homeProvider.role == 'user') {
            return Column(
              children: [
                Row(
                  children: [
                    
                  ],
                ),
                // Tombol Add Report untuk user
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(child: _buildTabSelector()),
              ]
            );
          }
        },
      ),
    );
  }

  Widget _buildTabSelector() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              _buildTabOption('Routine', 0, homeProvider.isRoutineSelected),
              _buildTabOption('Report', 1, !homeProvider.isRoutineSelected),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabOption(String title, int index, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(23),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        if (homeProvider.role == 'user') {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  homeProvider.isRoutineSelected
                      ? Icons.repeat_rounded
                      : Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeProvider.isRoutineSelected
                          ? 'Routine Tasks'
                          : 'Report Tasks',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      homeProvider.isRoutineSelected
                          ? 'Daily cleaning routines'
                          : 'Special reports and maintenance',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasksList() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        if (homeProvider.isLoadingTasks) {
          return _buildTasksLoadingState();
        }

        if (homeProvider.taskError != null) {
          return _buildTasksErrorState(homeProvider.taskError!);
        }

        // Untuk role 'user', selalu ambil report tasks
        final tasks =
            homeProvider.role == 'user'
                ? homeProvider.reportTasks
                : homeProvider.currentTasks;

        if (tasks.isEmpty) {
          return _buildEmptyTasksState(
            homeProvider.role == 'user'
                ? false
                : homeProvider.isRoutineSelected,
          );
        }

        return _buildTasksListView(
          tasks,
          homeProvider.role == 'user' ? false : homeProvider.isRoutineSelected,
          homeProvider.role,
        );
      },
    );
  }

  Widget _buildTasksLoadingState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading tasks...',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksErrorState(String error) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTasksState(bool isRoutine) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                isRoutine
                    ? Icons.check_circle_outline
                    : Icons.assignment_turned_in_outlined,
                color: AppColors.primary,
                size: 52,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isRoutine ? 'Semua rutinitas selesai!' : 'Belum ada laporan',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isRoutine
                  ? 'Kerja bagus! Anda telah menyelesaikan semua tugas rutin Anda hari ini.'
                  : 'Mulailah dengan membuat laporan pertama Anda menggunakan tombol di atas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withOpacity(0.6),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksListView(
    List<Map<String, String>> tasks,
    bool isRoutineSelected,
    String role,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskCardWidget(
              title: task['title'] ?? 'No Title',
              status: task['status'] ?? 'No Status',
              areaName: task['areaName'] ?? '-',
              areaBuilding: task['areaBuilding'] ?? '-',
              taskType: isRoutineSelected ? 'routine' : 'report',
              // Untuk routine: tampilkan time jika ada
              role: role,
              time: isRoutineSelected ? (task['time'] ?? '') : null,
              createdBy: !isRoutineSelected ? (task['createdBy'] ?? '') : null,
              onTap: () {
                final taskId = tasks[index]['assignmentId'];
                Provider.of<TaskDetailProvider>(
                  context,
                  listen: false,
                ).setTaskAssignmentId(taskId!);

                if (isRoutineSelected) {
                  Navigator.pushNamed(
                    context,
                    '/routine-task-detail',
                    arguments: task,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/report-task-detail',
                    arguments: task,
                  );
                }
              },
            ),
          );
        }, childCount: tasks.length),
      ),
    );
  }

  Widget _buildBottomSpacing() {
    return const SliverToBoxAdapter(child: SizedBox(height: 120));
  }
}
