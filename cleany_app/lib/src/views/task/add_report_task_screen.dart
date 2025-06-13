import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/src/providers/task_provider.dart';

class AddReportTaskScreen extends StatefulWidget {
  const AddReportTaskScreen({super.key});

  @override
  State<AddReportTaskScreen> createState() => _AddReportTaskScreenState();
}

class _AddReportTaskScreenState extends State<AddReportTaskScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<File> _localImages = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.initializeData();
    taskProvider.clearForm();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final status = await Permission.camera.status;

    if (status.isGranted || await Permission.camera.request().isGranted) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _localImages.add(File(pickedImage.path));
        });
      }
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Izin kamera ditolak secara permanen. Silakan izinkan melalui Pengaturan.',
          ),
          action: SnackBarAction(
            label: 'Buka Pengaturan',
            onPressed: openAppSettings,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat mengakses kamera.')),
      );
    }
  }

  Future<void> _submitTask(TaskProvider provider) async {
    if (!provider.validateForm() || _localImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Harap isi judul, pilih area, dan upload minimal 1 foto',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      for (File image in _localImages) {
        await provider.addTaskImage(image);
      }

      final task = await provider.submitTask();
      if (task) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dibuat!')),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushReplacementNamed(context, '/home');

      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengirim laporan. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Report Task',
          style: TextStyle(color: AppColors.primary),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  provider.imageUrl.isNotEmpty
                                      ? NetworkImage(provider.imageUrl)
                                      : null,
                              backgroundColor: Colors.grey.shade200,
                              child:
                                  provider.imageUrl.isEmpty
                                      ? const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Created by:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  provider.username,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: provider.setTitle,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          minLines: 3,
                          maxLines: 6,
                          onChanged: provider.setDescription,
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value:
                              (provider.selectedAreaId ?? '').isNotEmpty
                                  ? provider.selectedAreaId
                                  : null,
                          decoration: InputDecoration(
                            labelText: 'Pilih Area',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownColor: Colors.white,
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
                        const SizedBox(height: 24),
                        const Text(
                          'Upload Foto Tugas',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.photo),
                              label: const Text('Galeri'),
                              onPressed: () => _pickImage(ImageSource.gallery),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Kamera'),
                              onPressed: () => _pickImage(ImageSource.camera),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _localImages.isNotEmpty
                            ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _localImages.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemBuilder: (context, index) {
                                final imageFile = _localImages[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        imageFile,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _localImages.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                            : Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Belum ada foto yang diupload',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed:
                              _isSubmitting
                                  ? null
                                  : () => _submitTask(provider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              _isSubmitting
                                  ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Center(
                                    child: Text(
                                      'Simpan',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
