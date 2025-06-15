import 'dart:convert';
import 'dart:io';
import 'package:cleany_app/src/models/task_assignment_model.dart';
import 'package:flutter/foundation.dart';
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

class EditTaskProvider extends ChangeNotifier {
  String _title = '';
  String _description = '';
  String _username = '';
  String _imageUrl = '';
  List<AreaModel> _areas = [];
  String? _selectedAreaId;
  String _error = '';
  String _message = '';
  List<String> _taskImageUrls = [];
  String _assignmentId = '';
  TaskAssignmentModel? _task;

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
  String get assignmentId => _assignmentId;
  TaskAssignmentModel? get task => _task;

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

  Future<void> loadTaskDetails() async {
    try {
      final result = await _taskService.fetchTaskAssignmentDetails(
        _assignmentId,
      );
      setTitle(result.task.title);
      setDescription(result.task.description!);
      setSelectedAreaId(result.task.area.areaId);
    } catch (e) {
      _error = 'Gagal memuat detail tugas: $e';
      _task = null;
    }
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

  void setTaskImageUrl(List<String> imageUrls) {
    _taskImageUrls = imageUrls;
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

  void clearForm({bool silent = false}) {
    _title = '';
    _description = '';
    _selectedAreaId = null;
    _taskImageUrls.clear();
    _error = '';
    _message = '';
    if (!silent) notifyListeners();
  }

  Future<void> updateTaskStatus(String assignmentId, String status) async {
    await _taskService.updateStatusReportTask(assignmentId: assignmentId, status: status);
    notifyListeners();
  }
  
  // Method untuk fetch detail task assignment
  Future<TaskAssignmentModel> fetchTaskAssignmentDetails(String? assignmentId) async {
    try {
      final taskAssignment = await _taskService.fetchTaskAssignmentDetails(assignmentId!);
      return taskAssignment;
    } catch (e) {
      _error = 'Gagal mengambil detail task: ${e.toString()}';
      notifyListeners();
      return TaskAssignmentModel.empty();
    }
  }

  // Method untuk update task
  Future<bool> updateTask({
    required String taskId,
    required List<String> imageUrlList,
  }) async {
    try {
      final areaId = int.tryParse(_selectedAreaId ?? '');
      if (areaId == null) {
        _error = 'Area tidak valid';
        notifyListeners();
        return false;
      }
      final isSuccess = await _taskService.updateReportTask(
        taskId: taskId,
        title: _title.trim(),
        description: _description.trim(),
        imageUrlList: imageUrlList,
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

  // Method untuk reset task image URLs (berguna saat edit)
  void resetTaskImageUrls() {
    _taskImageUrls.clear();
    notifyListeners();
  }

  // Method untuk set initial data dari task assignment
  void setInitialDataFromTaskAssignment(String title, String description, String areaId) {
    _title = title;
    _description = description;
    _selectedAreaId = areaId;
    notifyListeners();
  }

}
