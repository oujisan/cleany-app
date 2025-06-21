import 'package:flutter/material.dart';
import 'package:cleany_app/src/models/task_assignment_model.dart';
import 'package:cleany_app/src/models/verification_model.dart';
import 'package:cleany_app/src/services/task_service.dart';
import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:geolocator/geolocator.dart';

class TaskDetailProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  String? _taskAssignmentId;
  TaskAssignmentModel? _task;
  bool _isLoading = false;
  String? _error;
  String _role = '';
  VerificationModel? _verification;
  String _createdBy = '';
  String _username = '';
  String _taskId = '';
  String _latitude = '';
  String _logitude = '';

  // Getters
  String? get taskAssignmentId => _taskAssignmentId;
  TaskAssignmentModel? get task => _task;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get role => _role;
  VerificationModel? get verification => _verification;
  String get createdBy => _createdBy;
  String get username => _username;
  String get taskId => _taskId;
  String get latitude => _latitude;
  String get logitude => _logitude;

  // Set task assignment ID
  void setTaskAssignmentId(String id) {
    _taskAssignmentId = id;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    _role = await SecureStorage.read(AppConstants.keyRole) ?? '';
    _username = await SecureStorage.read(AppConstants.keyUsername) ?? '';
    notifyListeners();
  }

  Future<void> loadTaskDetails() async {
    if (_taskAssignmentId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _taskService.fetchTaskAssignmentDetails(
        _taskAssignmentId!,
      );
      _task = result;
      _createdBy = result.task.createdBy;
      _taskId = result.task.taskId;
    } catch (e) {
      _error = 'Gagal memuat detail tugas: $e';
      _task = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVerificationTask() async {
    if (_taskAssignmentId == null) return;

    try {
      _verification = await _taskService.fetchVerificationTask(
        _taskAssignmentId!,
      );
      _error = null;
    } catch (e) {
      _verification = null;
      _error = 'Gagal memuat verifikasi tugas: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateTaskStatus(String status) async {
    if (_taskAssignmentId == null) return false;
    try {
      final result = await _taskService.updateStatusReportTask(
        assignmentId: _taskAssignmentId!,
        status: status,
      );
      if (result) {
        _error = null;
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Gagal memperbarui status tugas: $e';
      return false;
    }
  }

  Future<bool> addProofImage(List<String> imageUrls) async {
    try {
      final result = await _taskService.addProofImage(
        assignmentId: _taskAssignmentId!,
        imageUrls: imageUrls,
      );
      if (result) {
        _error = null;
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Gagal menambahkan bukti tugas: $e';
      return false;
    }
  }

  Future<bool> updateVerificationStatus(String status) async {
    if (_taskAssignmentId == null) return false;

    try {
      final result = await _taskService.updateVerificationStatusTask(
        assignmentId: _taskAssignmentId!,
        status: status,
      );
      if (result) {
        _error = null;
        return true;
      }
    } catch (e) {
      _error = 'Gagal memperbarui verifikasi tugas: $e';
    }
    return false;
  }

  // Clear provider state
  void clear() {
    _taskAssignmentId = null;
    _task = null;
    _isLoading = false;
    _error = null;
    _verification = null;
    _role = '';
    notifyListeners();
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final result = await _taskService.deleteTask(taskId);
      if (result) {
        _error = null;
        return true;
      }
    } catch (e) {
      _error = 'Gagal menghapus tugas: $e';
    }
    return false;
  }

  Future<bool> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    _latitude = position.latitude.toString();
    _logitude = position.longitude.toString();

    await _taskService.updateLocationTask(
      assignmentId: _taskAssignmentId!,
      latitude: _latitude,
      longitude: _logitude,
    );

    notifyListeners();
    return true;
  }
}
