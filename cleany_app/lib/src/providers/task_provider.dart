import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:cleany_app/src/services/area_service.dart';
import 'package:cleany_app/src/models/area_model.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/core/secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cleany_app/src/services/task_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  String _title = '';
  String _description = '';
  String _username = '';
  String _imageUrl = '';
  List<AreaModel> _areas = [];
  String? _selectedAreaId;
  String _error = '';
  String _message = '';
  List<String> _taskImageUrls = [];
  String _selectedTime = '';
  String _startDate = '';
  String _endDate = '';
  List<int> _selectedDays = [];

  final AreaService _areaService = AreaService();
  final TaskService _taskService = TaskService();

  // Getters
  String get username => _username;
  String get imageUrl => _imageUrl;
  String get title => _title;
  String get description => _description;
  List<AreaModel> get areas => _areas;
  String? get selectedAreaId => _selectedAreaId;
  String get getError => _error;
  String get getMessage => _message;
  List<String> get taskImageUrls => _taskImageUrls;
  String get selectedTime => _selectedTime;
  String get startDate => _startDate;
  String get endDate => _endDate;
  List<int> get daysOfWeek => _selectedDays;

  // Initialization
  Future<void> initializeData() async {
    await Future.wait([loadUserProfile(), loadAreaData()]);
  }

  Future<void> loadUserProfile() async {
    _username = await SecureStorage.read(AppConstants.keyUsername) ?? '';
    _imageUrl = await SecureStorage.read(AppConstants.keyImageUrl) ?? '';
    notifyListeners();
  }

  Future<void> loadAreaData() async {
    _areas = await _areaService.fetchAllArea();
    notifyListeners();
  }

  // Form setters
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setSelectedAreaId(String? areaId) {
    _selectedAreaId = areaId;
    notifyListeners();
  }

  // Validasi form (gak perlu cek gambar karena gambar diupload saat submit)
  bool validateForm() {
    return _title.trim().isNotEmpty &&
        _selectedAreaId != null &&
        _selectedAreaId!.trim().isNotEmpty;
  }

  // Upload image ke Cloudinary dan simpan URL
  Future<void> addTaskImage(File imageFile) async {
    final imageUrl = await uploadImageToCloudinary(imageFile);
    if (imageUrl != null) {
      _taskImageUrls.add(imageUrl);
      notifyListeners();
    }
  }

  // Hapus image berdasarkan index
  void removeImageAt(int index) {
    if (index >= 0 && index < _taskImageUrls.length) {
      _taskImageUrls.removeAt(index);
      notifyListeners();
    }
  }

  // Upload ke Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

    if (cloudName == null || uploadPreset == null) {
      debugPrint('Cloudinary config not set');
      return null;
    }

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    // Resize image locally
    final originalImageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(originalImageBytes);

    if (originalImage == null) {
      debugPrint('Image decoding failed');
      return null;
    }

    final resizedImage = img.copyResize(originalImage, width: 800);
    final tempDir = await getTemporaryDirectory();
    final resizedImageFile = File(
      '${tempDir.path}/resized_upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
    )..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

    final mimeType = lookupMimeType(resizedImageFile.path);

    final request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              resizedImageFile.path,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          );

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      return data['secure_url'];
    } else {
      debugPrint('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  // Submit task ke backend
  Future<bool> submitTask() async {
    try {
      final areaId = int.tryParse(_selectedAreaId ?? '');
      if (areaId == null) {
        _error = 'Area tidak valid';
        notifyListeners();
        return false;
      }

      final isSuccess = await _taskService.addReportTask(
        title: _title.trim(),
        description: _description.trim(),
        imageUrlList: _taskImageUrls,
        areaId: areaId,
      );

      _message = _taskService.getMessage;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitRuutineTask() async {
    try {
      final areaId = int.tryParse(_selectedAreaId ?? '');
      if (areaId == null) {
        _error = 'Area tidak valid';
        notifyListeners();
        return false;
      }

      final isSuccess = await _taskService.addReportTask(
        title: _title.trim(),
        description: _description.trim(),
        imageUrlList: _taskImageUrls,
        areaId: areaId,
      );

      _message = _taskService.getMessage;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearForm({bool silent = false}) {
    _title = '';
    _description = '';
    _selectedAreaId = null;
    _taskImageUrls.clear();
    _error = '';
    _message = '';
    _selectedStartDate = null;
    _selectedEndDate = null;
    _selectedTimeOfDay = null;
    _selectedDays.clear();
    if (!silent) notifyListeners();
  }

  Future<void> updateTaskStatus(String assignmentId, String status) async {
    await _taskService.updateStatusReportTask(
      assignmentId: assignmentId,
      status: status,
    );
    notifyListeners();
  }

  Future<void> addRoutineTask() async {
    await _taskService.addRoutineTask(
      title: _title.trim(),
      description: _description.trim(),
      areaId: _selectedAreaId ?? '',
      time: _selectedTime,
      imageUrlList: _taskImageUrls,
      startDate: _startDate,
      endDate: _endDate,
      days: _selectedDays,
    );
    notifyListeners();
  }

  // GEMINI
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedTimeOfDay; // 1=Senin, 2=Selasa, ..., 7=Minggu

  // --- TAMBAHAN: Getters untuk menampilkan di UI ---
  String get startDateDisplay =>
      _selectedStartDate != null
          ? DateFormat('d MMMM yyyy').format(_selectedStartDate!)
          : '';
  String get endDateDisplay =>
      _selectedEndDate != null
          ? DateFormat('d MMMM yyyy').format(_selectedEndDate!)
          : '';
  String get timeDisplay {
    if (_selectedTimeOfDay == null) return '';
    final hour = _selectedTimeOfDay!.hour.toString().padLeft(2, '0');
    final minute = _selectedTimeOfDay!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  List<int> get selectedDays => _selectedDays;

  void setStartDate(DateTime date) {
    _selectedStartDate = date;
    // Jika tanggal akhir lebih awal dari tanggal mulai baru, reset tanggal akhir
    if (_selectedEndDate != null && _selectedEndDate!.isBefore(date)) {
      _selectedEndDate = null;
    }
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _selectedEndDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTimeOfDay = time;
    notifyListeners();
  }

  void toggleSelectedDay(int day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
      _selectedDays.sort(); // Jaga agar urutan tetap
    }
    notifyListeners();
  }

  bool validateRoutineForm() {
    if (title.isEmpty ||
        selectedAreaId == null ||
        selectedAreaId!.isEmpty ||
        _selectedStartDate == null ||
        _selectedEndDate == null ||
        _selectedTimeOfDay == null ||
        _selectedDays.isEmpty) {
      return false;
    }
    return true;
  }
  Future<bool> submitRoutineTask() async {
    if (!validateRoutineForm()) {
      // Validasi tambahan bisa dilakukan di sini atau di UI
      return false;
    }

    // Format data untuk dikirim ke service
    final String formattedStartDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedStartDate!);
    final String formattedEndDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedEndDate!);
    final String formattedTime =
        '${_selectedTimeOfDay!.hour.toString().padLeft(2, '0')}:${_selectedTimeOfDay!.minute.toString().padLeft(2, '0')}';

    final success = await _taskService.addRoutineTask(
      title: title,
      description: description,
      areaId: selectedAreaId!,
      time: formattedTime,
      imageUrlList: taskImageUrls.isNotEmpty ? taskImageUrls : null,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      days: _selectedDays,
    );

    // Asumsi _taskService akan mengembalikan true/false
    // dan mengatur message/error secara internal.
    return success;
  }
}
