import 'package:flutter/material.dart';
import 'package:cleany_app/src/models/task_assignment_model.dart';
import 'package:cleany_app/src/models/verification_model.dart';
import 'package:cleany_app/src/services/task_service.dart';
import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/core/constant.dart';


class TaskDetailProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  String? _taskAssignmentId;
  TaskAssignmentModel? _task;
  bool _isLoading = false;
  String? _error;
  String _role = '';
  VerificationModel? _verification;

  // Getters
  String? get taskAssignmentId => _taskAssignmentId;
  TaskAssignmentModel? get task => _task;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get role => _role;
  VerificationModel? get verification => _verification;

  // Set task assignment ID
  void setTaskAssignmentId(String id) {
    _taskAssignmentId = id;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    _role = await SecureStorage.read(AppConstants.keyRole) ?? '';
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
      _verification = await _taskService.fetchVerificationTask(_taskAssignmentId!);
      _error = null;
    } catch (e) {
      _verification = null;
      _error = 'Gagal memuat verifikasi tugas: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTaskStatus(String status) async {
    if (_taskAssignmentId == null) return;

    try {
      final result = await _taskService.updateStatusReportTask(
        assignmentId: _taskAssignmentId!,
        status: status,
      );
      if (result) {
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Gagal memperbarui status tugas: $e';
      notifyListeners();
    }
  }

  Future<void> updateVerificationStatus(String status) async {
    if (_taskAssignmentId == null) return;

    try {
      final result = await _taskService.updateVerificationStatusTask(
        assignmentId: _taskAssignmentId!,
        status: status,
      );
      if (result) {
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Gagal memperbarui verifikasi tugas: $e';
      notifyListeners();
    }
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
}
