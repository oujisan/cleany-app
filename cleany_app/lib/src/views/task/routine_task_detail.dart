import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/src/providers/task_detail_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/src/views/task/edit_routine_task_screen.dart';
import 'package:cleany_app/src/providers/task_provider.dart';

class RoutineTaskDetailScreen extends StatefulWidget {
  const RoutineTaskDetailScreen({super.key});

  @override
  State<RoutineTaskDetailScreen> createState() => _RoutineTaskDetailScreenState();  
}

class _RoutineTaskDetailScreenState extends State<RoutineTaskDetailScreen> {
  late String _roleUser = '';
  late String _usernameUser = '';
  List<File> _localImages = [];
  List<String> _proofImageUrls = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final provider = Provider.of<TaskDetailProvider>(context, listen: false);
    provider.loadTaskDetails();
    provider.fetchVerificationTask();

    final role = await SecureStorage.read(AppConstants.keyRole);
    final username = await SecureStorage.read(AppConstants.keyUsername);
    setState(() {
      _roleUser = role ?? '';
      _usernameUser = username ?? '';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final status = await Permission.camera.status;

    if (status.isGranted || await Permission.camera.request().isGranted) {
      final pickedImage = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedImage != null) {
        setState(() {
          _localImages.add(File(pickedImage.path));
        });
      }
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      _showPermissionDialog();
    } else {
      if (!mounted) return;
      _showSnackBar('Tidak dapat mengakses kamera', isError: true);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Izin Kamera Diperlukan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            content: const Text(
              'Aplikasi memerlukan izin kamera untuk mengambil foto. Silakan berikan izin melalui pengaturan.',
              style: TextStyle(color: AppColors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Buka Pengaturan',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog.fullscreen(
            backgroundColor: AppColors.black,
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.black,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                size: 80,
                                color: AppColors.white,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Gagal memuat gambar',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatusChip(String status, {bool verif = false}) {
    Color chipColor;
    String statusText;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = AppColors.secondary;
        statusText = verif ? 'Menunggu Verifikasi' : 'Menunggu';
        statusIcon = Icons.schedule_rounded;
        break;
      case 'in_progress':
        chipColor = Colors.orange;
        statusText = 'Dikerjakan';
        statusIcon = Icons.work_outline_rounded;
        break;
      case 'completed':
        chipColor = AppColors.primary;
        statusText = 'Selesai';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'approved':
        chipColor = Colors.green;
        statusText = 'Disetujui';
        statusIcon = Icons.verified_rounded;
        break;
      case 'rejected':
        chipColor = AppColors.error;
        statusText = 'Ditolak';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        chipColor = AppColors.grey;
        statusText = status;
        statusIcon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: chipColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid({
    required String title,
    required List<String> imageUrls,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          if (imageUrls.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showImagePreview(imageUrls[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.grey.withOpacity(0.1),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_rounded,
                                      size: 32,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Gagal memuat',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Overlay with zoom icon
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.center,
                                colors: [
                                  AppColors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.zoom_in_rounded,
                                color: AppColors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.2),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    size: 40,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tidak ada foto',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    bool isOutlined = false,
  }) {
    return SizedBox(
      height: 48,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              )
              : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: AppColors.white,
                  elevation: 2,
                  shadowColor: color.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
    );
  }

  Future<void> _handleUpdateStatus(
    BuildContext context,
    TaskDetailProvider taskProvider,
    String status,
  ) async {
    final result = await taskProvider.updateTaskStatus(status);

    if (result) {
      if (!context.mounted) return;
      _showSnackBar('Tugas Diterima! Segera selesaikan tugas.');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!context.mounted) return;
      _showSnackBar('Gagal menerima tugas. Silakan coba lagi.', isError: true);
    }
  }

  Future<void> _handleDeleteTask(
    TaskDetailProvider provider,
    String taskId
  ) async {
    final success = await provider.deleteTask(taskId);
      if (success) {
        _showSnackBar('Laporan berhasil dihapus!');
      } else {
        _showSnackBar(
          'Gagal menghapus laporan. Silakan coba lagi.',
          isError: true,
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Laporan',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Consumer<TaskDetailProvider>(
            builder: (context, provider, _) {
              if (provider.task?.status == 'pending' && _usernameUser == provider.createdBy) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => EditRoutineTaskScreen(taskId: provider.taskAssignmentId!,),
                        )
                      );
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Hapus Laporan',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus laporan ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Batal',
                                      style: TextStyle(color: AppColors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      
                                      _handleDeleteTask(provider, provider.taskId);
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                    ,
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<TaskDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final asn = provider.task;
          final verif = provider.verification;

          if (asn == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: AppColors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Data tidak tersedia',
                    style: TextStyle(color: AppColors.grey, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.grey.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              asn.task.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (provider.role == 'cleaner')
                            verif != null && asn.status == 'completed' ? _buildStatusChip(verif.status!, verif: true) : _buildStatusChip(asn.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          asn.task.description ?? 'Tidak ada deskripsi',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Task Details
                _buildDetailCard(
                  icon: Icons.location_on_rounded,
                  label: 'Lokasi',
                  value:
                      '${asn.task.area.name} - ${asn.task.area.building} - Lt. ${asn.task.area.floor}',
                ),

                _buildDetailCard(
                  icon: Icons.timer_rounded,
                  label: 'Waktu Pengerjaan',
                  value: DateFormat('HH:mm', 'id_ID').format(
                    DateFormat('HH:mm').parse(asn.task.routine!.time),
                  ),
                  iconColor: AppColors.secondary,
                ),

                _buildDetailCard(
                  icon: Icons.person_rounded,
                  label: 'Dibuat oleh',
                  value: asn.task.createdBy,
                  iconColor: AppColors.primary,
                ),

                if (asn.workedBy != null)
                  _buildDetailCard(
                    icon: Icons.engineering_rounded,
                    label: 'Dikerjakan oleh',
                    value: asn.workedBy!,
                    iconColor: Colors.orange,
                  ),

                if (asn.assignmentAt != null)
                  _buildDetailCard(
                    icon: Icons.work_history_rounded,
                    label: 'Ditugaskan pada',
                    value: asn.assignmentAt!,
                    iconColor: AppColors.secondary,
                  ),

                if (asn.completeAt != null)
                  _buildDetailCard(
                    icon: Icons.check_circle_rounded,
                    label: 'Diselesaikan pada',
                    value: asn.completeAt!,
                    iconColor: Colors.green,
                  ),

                const SizedBox(height: 12),

                // Task Images
                _buildImageGrid(
                  title: 'Foto Tugas',
                  imageUrls: asn.task.taskImageUrl ?? [],
                ),
                
                SizedBox(height: 32),

                // Proof Images
                if (asn.status == 'completed' &&
                    asn.proofImageUrl != null &&
                    asn.proofImageUrl!.isNotEmpty)
                  _buildImageGrid(
                    title: 'Foto Bukti Pengerjaan',
                    imageUrls: asn.proofImageUrl!,
                  ),

                // Action Button for Cleaner
                if (_roleUser == 'cleaner')
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    child:
                        asn.status == 'completed'
                            ? null
                            : _buildActionButton(
                              text:
                                  asn.status == 'pending'
                                      ? 'Mulai Pengerjaan'
                                      : asn.status == 'in_progress'
                                      ? 'Selesai Pengerjaan'
                                      : 'Laporan Selesai',
                              onPressed: () {
                                String newStatus;
                                if (asn.status == 'pending') {
                                  newStatus = 'in_progress';
                                } else if (asn.status == 'in_progress') {
                                  newStatus = 'completed';
                                } else {
                                  newStatus = 'pending';
                                }
                                _handleUpdateStatus(
                                    context,
                                    provider,
                                    newStatus,
                                  );
                              },
                              color:
                                  asn.status == 'pending'
                                      ? AppColors.primary
                                      : asn.status == 'in_progress'
                                      ? Colors.green
                                      : AppColors.grey,
                            ),
                  ),

                // Verification Section          
              ],
            ),
          );
        },
      ),
    );
  }
}