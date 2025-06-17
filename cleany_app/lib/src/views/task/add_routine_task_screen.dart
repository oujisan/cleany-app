import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:cleany_app/src/providers/task_provider.dart';
import 'package:intl/intl.dart';

class AddRoutineTaskScreen extends StatefulWidget {
  const AddRoutineTaskScreen({super.key});

  @override
  State<AddRoutineTaskScreen> createState() => _AddRoutineTaskScreenState();
}

class _AddRoutineTaskScreenState extends State<AddRoutineTaskScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<File> _localImages = [];
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();

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
      builder: (context) => AlertDialog(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _submitTask(TaskProvider provider) async {
    if (!provider.validateForm() || _localImages.isEmpty) {
      _showSnackBar(
        'Harap isi judul, pilih area, dan upload minimal 1 foto',
        isError: true,
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
        _showSnackBar('Laporan berhasil dibuat!');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (mounted) {
          _showSnackBar('Gagal mengirim laporan. Silakan coba lagi.', isError: true);
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
      builder: (context) => Padding(
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
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
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

  Future<void> _selectDate(BuildContext context, TaskProvider provider, {required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = isStartDate ? now : (provider.startDateDisplay.isNotEmpty ? DateTime.parse(DateFormat('d MMMM yyyy').parse(provider.startDateDisplay).toString()) : now);
    final initialDate = isStartDate 
      ? (provider.startDateDisplay.isNotEmpty ? DateTime.parse(DateFormat('d MMMM yyyy').parse(provider.startDateDisplay).toString()) : now)
      : (provider.endDateDisplay.isNotEmpty ? DateTime.parse(DateFormat('d MMMM yyyy').parse(provider.endDateDisplay).toString()) : (provider.startDateDisplay.isNotEmpty ? DateTime.parse(DateFormat('d MMMM yyyy').parse(provider.startDateDisplay).toString()) : now));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isStartDate) {
        provider.setStartDate(pickedDate);
      } else {
        provider.setEndDate(pickedDate);
      }
    }
  }

  Future<void> _selectTime(BuildContext context, TaskProvider provider) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      provider.setSelectedTime(pickedTime);
    }
  }
  
  // --- MODIFIKASI: Ubah _submitTask menjadi _submitRoutineTask ---
  Future<void> _submitRoutineTask(TaskProvider provider) async {
    if (!provider.validateRoutineForm() || _localImages.isEmpty) {
      _showSnackBar(
        'Harap isi semua field yang wajib, pilih hari, dan upload minimal 1 foto',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      for (File image in _localImages) {
        await provider.addTaskImage(image);
      }
      
      // Panggil method baru di provider
      final success = await provider.submitRoutineTask(); 
      if (success) {
        if (!mounted) return;
        _showSnackBar('Laporan rutin berhasil dibuat!');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (mounted) {
          _showSnackBar('Gagal mengirim laporan. Silakan coba lagi.', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      }
    }

    setState(() => _isSubmitting = false);
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller
    _startDateController.dispose();
    _endDateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

Widget _buildDaySelector(TaskProvider provider) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: List<Widget>.generate(days.length, (index) {
        final dayIndex = index + 1; // 1 untuk Senin, dst.
        final isSelected = provider.selectedDays.contains(dayIndex);
        return ChoiceChip(
          label: Text(days[index]),
          selected: isSelected,
          onSelected: (selected) {
            provider.toggleSelectedDay(dayIndex);
          },
          labelStyle: TextStyle(
            color: isSelected ? AppColors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.white,
          selectedColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    _startDateController.text = provider.startDateDisplay;
    _endDateController.text = provider.endDateDisplay;
    _timeController.text = provider.timeDisplay;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
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
                    'Buat Laporan',
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
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                backgroundImage: provider.imageUrl.isNotEmpty
                                    ? NetworkImage(provider.imageUrl)
                                    : null,
                                child: provider.imageUrl.isEmpty
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dibuat oleh',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey.withOpacity(0.8),
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
                          child: TextField(
                            decoration: _buildInputDecoration('Masukkan judul laporan'),
                            style: const TextStyle(color: AppColors.black),
                            onChanged: provider.setTitle,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildFormField(
                          label: 'Deskripsi',
                          child: TextField(
                            decoration: _buildInputDecoration('Jelaskan detail laporan'),
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
                            value: (provider.selectedAreaId ?? '').isNotEmpty
                                ? provider.selectedAreaId
                                : null,
                            decoration: _buildInputDecoration('Pilih area'),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                            ),
                            dropdownColor: AppColors.white,
                            style: const TextStyle(color: AppColors.black),
                            items: provider.areas.map((area) {
                              return DropdownMenuItem<String>(
                                value: area.areaId,
                                child: Text('${area.name} - ${area.building}'),
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
                              if (_localImages.isEmpty)
                                InkWell(
                                  onTap: _showImagePickerBottomSheet,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.grey.withOpacity(0.3),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.grey.withOpacity(0.05),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 40,
                                          color: AppColors.grey.withOpacity(0.6),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Ketuk untuk upload foto',
                                          style: TextStyle(
                                            color: AppColors.grey.withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Minimal 1 foto diperlukan',
                                          style: TextStyle(
                                            color: AppColors.grey.withOpacity(0.6),
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
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _localImages.length,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemBuilder: (context, index) {
                                        final imageFile = _localImages[index];
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(
                                                imageFile,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _localImages.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.error,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 4,
                                                        offset: const Offset(0, 2),
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
                                      icon: const Icon(Icons.add_photo_alternate_outlined),
                                      label: const Text('Tambah Foto'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(color: AppColors.primary),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Tanggal Mulai',
                                child: TextField(
                                  controller: _startDateController,
                                  readOnly: true,
                                  onTap: () => _selectDate(context, provider, isStartDate: true),
                                  decoration: _buildInputDecoration('Pilih tanggal').copyWith(
                                    suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                                  ),
                                  style: const TextStyle(color: AppColors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFormField(
                                label: 'Tanggal Selesai',
                                child: TextField(
                                  controller: _endDateController,
                                  readOnly: true,
                                  onTap: () => _selectDate(context, provider, isStartDate: false),
                                  decoration: _buildInputDecoration('Pilih tanggal').copyWith(
                                    suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                                  ),
                                  style: const TextStyle(color: AppColors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- TAMBAHAN: Field Waktu ---
                        _buildFormField(
                          label: 'Waktu Pelaksanaan',
                          child: TextField(
                            controller: _timeController,
                            readOnly: true,
                            onTap: () => _selectTime(context, provider),
                            decoration: _buildInputDecoration('Pilih waktu').copyWith(
                              suffixIcon: const Icon(Icons.access_time_outlined, color: AppColors.primary, size: 20),
                            ),
                            style: const TextStyle(color: AppColors.black),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- TAMBAHAN: Field Pilih Hari ---
                        _buildFormField(
                          label: 'Pilih Hari',
                          child: _buildDaySelector(provider),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : () => _submitRoutineTask(provider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Simpan Laporan',
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
        borderSide: BorderSide(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.grey.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }
}