import 'package:flutter/material.dart';
import 'package:cleany_app/src/models/task_response_model.dart';
import 'package:cleany_app/src/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskResponseModel> _tasks = [];
  List<TaskResponseModel> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Stream<List<TaskResponseModel>> fetchTasks() async* {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tasks = await _taskService.getReportTasks();
      _tasks = tasks;
      yield tasks;
    } catch (e) {
      _error = e.toString();
      _tasks = [];
      yield [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
