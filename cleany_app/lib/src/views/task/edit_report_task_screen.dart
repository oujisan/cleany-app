import 'dart:io';
import 'package:cleany_app/src/models/task_assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/src/providers/edit_task_provider.dart';

class EditReportTaskScreen extends StatefulWidget {
  final String? assignmentId;

  const EditReportTaskScreen({super.key, this.assignmentId});

  @override
  State<EditReportTaskScreen> createState() => _EditReportTaskScreenState();
}

class _EditReportTaskScreenState extends State<EditReportTaskScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<File> _localImages = [];
  List<String> _existingImageUrls = [];
  TaskAssignmentModel? _task;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final taskProvider = Provider.of<EditTaskProvider>(context, listen: false);
    await taskProvider.initializeData();
    await _loadTaskData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadTaskData() async {
    final taskProvider = Provider.of<EditTaskProvider>(context, listen: false);
    final taskAssignment = await taskProvider.fetchTaskAssignmentDetails(
      widget.assignmentId,
    );
    _task = taskAssignment;

    if (taskAssignment.assignmentId.isNotEmpty) {
      // Set data ke provider untuk editing
      taskProvider.setTitle(taskAssignment.task.title);
      taskProvider.setDescription(taskAssignment.task.description ?? '');
      taskProvider.setSelectedAreaId(taskAssignment.task.area.areaId);

      // Set existing images
      setState(() {
        _existingImageUrls = List<String>.from(
          taskAssignment.task.taskImageUrl ?? [],
        );
      });
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _updateTask(
    EditTaskProvider provider,
    TaskAssignmentModel? task,
  ) async {
    if (!provider.validateForm() ||
        (_localImages.isEmpty && _existingImageUrls.isEmpty)) {
      _showSnackBar(
        'Harap isi judul, pilih area, dan upload minimal 1 foto',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      provider.setTaskImageUrl([]);
      // Upload new images if any
      for (File image in _localImages) {
        await provider.addTaskImage(image);
      }

      // Combine existing and new image URLs
      final allImageUrls = [..._existingImageUrls, ...provider.taskImageUrls];

      final success = await provider.updateTask(
        taskId: task!.task.taskId,
        imageUrlList: allImageUrls,
      );

      if (success) {
        if (!mounted) return;
        _showSnackBar('Laporan berhasil diperbarui!');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      } else {
        if (mounted) {
          _showSnackBar(
            'Gagal memperbarui laporan. Silakan coba lagi.',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      }
    }

    setState(() => _isSubmitting = false);
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pilih Sumber Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildImageSourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Galeri',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageSourceButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Kamera',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditTaskProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    pinned: true,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      'Edit Laporan',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.primary
                                      .withOpacity(0.1),
                                  backgroundImage:
                                      provider.imageUrl.isNotEmpty
                                          ? NetworkImage(provider.imageUrl)
                                          : null,
                                  child:
                                      provider.imageUrl.isEmpty
                                          ? const Icon(
                                            Icons.person_outline,
                                            color: AppColors.primary,
                                            size: 28,
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Diedit oleh',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey.withOpacity(
                                            0.8,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        provider.username,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Form Fields
                          _buildFormField(
                            label: 'Judul Laporan',
                            child: TextFormField(
                              initialValue: provider.title,
                              decoration: _buildInputDecoration(
                                'Masukkan judul laporan',
                              ),
                              style: const TextStyle(color: AppColors.black),
                              onChanged: provider.setTitle,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildFormField(
                            label: 'Deskripsi',
                            child: TextFormField(
                              initialValue: provider.description,
                              decoration: _buildInputDecoration(
                                'Jelaskan detail laporan',
                              ),
                              style: const TextStyle(color: AppColors.black),
                              minLines: 3,
                              maxLines: 6,
                              onChanged: provider.setDescription,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildFormField(
                            label: 'Area',
                            child: DropdownButtonFormField<String>(
                              value:
                                  (provider.selectedAreaId ?? '').isNotEmpty
                                      ? provider.selectedAreaId
                                      : null,
                              decoration: _buildInputDecoration('Pilih area'),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                              dropdownColor: AppColors.white,
                              style: const TextStyle(color: AppColors.black),
                              items:
                                  provider.areas.map((area) {
                                    return DropdownMenuItem<String>(
                                      value: area.areaId,
                                      child: Text(
                                        '${area.name} - ${area.building}',
                                      ),
                                    );
                                  }).toList(),
                              onChanged: provider.setSelectedAreaId,
                              menuMaxHeight: 200,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Upload Photo Section
                          _buildFormField(
                            label: 'Foto Laporan',
                            child: Column(
                              children: [
                                if (_existingImageUrls.isEmpty &&
                                    _localImages.isEmpty)
                                  InkWell(
                                    onTap: _showImagePickerBottomSheet,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.grey.withOpacity(
                                            0.3,
                                          ),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.grey.withOpacity(0.05),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload_outlined,
                                            size: 40,
                                            color: AppColors.grey.withOpacity(
                                              0.6,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Ketuk untuk upload foto',
                                            style: TextStyle(
                                              color: AppColors.grey.withOpacity(
                                                0.8,
                                              ),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Minimal 1 foto diperlukan',
                                            style: TextStyle(
                                              color: AppColors.grey.withOpacity(
                                                0.6,
                                              ),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Column(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _existingImageUrls.length +
                                            _localImages.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                            ),
                                        itemBuilder: (context, index) {
                                          final isExistingImage =
                                              index < _existingImageUrls.length;

                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child:
                                                    isExistingImage
                                                        ? Image.network(
                                                          _existingImageUrls[index],
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: AppColors
                                                                  .grey
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                              child: const Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color:
                                                                    AppColors
                                                                        .error,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                        : Image.file(
                                                          _localImages[index -
                                                              _existingImageUrls
                                                                  .length],
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (isExistingImage) {
                                                        _existingImageUrls
                                                            .removeAt(index);
                                                      } else {
                                                        _localImages.removeAt(
                                                          index -
                                                              _existingImageUrls
                                                                  .length,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.error,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: AppColors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      OutlinedButton.icon(
                                        onPressed: _showImagePickerBottomSheet,
                                        icon: const Icon(
                                          Icons.add_photo_alternate_outlined,
                                        ),
                                        label: const Text('Tambah Foto'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: const BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  _isSubmitting
                                      ? null
                                      : () => _updateTask(provider, _task),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.grey
                                    .withOpacity(0.3),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child:
                                  _isSubmitting
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                      : const Text(
                                        'Perbarui Laporan',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.grey.withOpacity(0.7),
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppColors.grey.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
