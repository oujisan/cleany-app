import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/src/services/task_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _username = '';
  String _role = '';
  String _id = '';
  String _imageUrl = '';

  // State untuk task report dan routine
  List<Map<String, String>> _reportTasks = [];
  List<Map<String, String>> _routineTasks = [];
  bool _isLoadingTasks = false;
  String? _taskError;

  // Tab state
  int _selectedTabIndex = 0;

  // Getters
  String get username => _username;
  String get role => _role;
  String get id => _id;
  String get imageUrl => _imageUrl;

  List<Map<String, String>> get reportTasks => _reportTasks;
  List<Map<String, String>> get routineTasks => _routineTasks;
  List<Map<String, String>> get currentTasks =>
      _selectedTabIndex == 0 ? _routineTasks : _reportTasks;

  bool get isLoadingTasks => _isLoadingTasks;
  String? get taskError => _taskError;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isRoutineSelected => _selectedTabIndex == 0;

  final TaskService _taskService = TaskService();

  Future<void> loadUserProfile() async {
    try {
      _username = await SecureStorage.read(AppConstants.keyUsername) ?? '';
      _role = await SecureStorage.read(AppConstants.keyRole) ?? '';
      _id = await SecureStorage.read(AppConstants.keyId) ?? '';
      _imageUrl = await SecureStorage.read(AppConstants.keyImageUrl) ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  void switchTab(int index) {
    if (index != _selectedTabIndex) {
      _selectedTabIndex = index;
      notifyListeners();

      // Load tasks for the selected tab if not loaded yet
      if (index == 0 && _routineTasks.isEmpty) {
        fetchRoutineTasks();
      } else if (index == 1 && _reportTasks.isEmpty) {
        fetchReportTasks();
      }
    }
  }

  Future<void> fetchRoutineTasks() async {
    if (_id.isEmpty) {
      _taskError = "User ID is empty";
      notifyListeners();
      return;
    }

    _isLoadingTasks = true;
    _taskError = null;
    notifyListeners();

    try {
      final tasks = await _taskService.fetchRoutineTasks();
      _routineTasks = tasks.map((task) => task).toList();
    } catch (e) {
      _taskError = e.toString();
      _routineTasks = [];
      debugPrint('Error fetching routine tasks: $e');
    }

    _isLoadingTasks = false;
    notifyListeners();
  }

  /// Fetch report tasks
  Future<void> fetchReportTasks() async {
    if (_id.isEmpty) {
      _taskError = "User ID is empty";
      notifyListeners();
      return;
    }

    _isLoadingTasks = true;
    _taskError = null;
    notifyListeners();

    try {
      List<Map<String, String>> tasks = [];

      if (_role == 'user') {
        tasks = await _taskService.fetchReportTasks(_id);
      } else if (_role == 'koordinator' || _role == 'cleaner') {
        tasks = await _taskService.fetchAllReportTasks();
      }
      _reportTasks = tasks.map((task) => task).toList();
    } catch (e) {
      _taskError = e.toString();
      _reportTasks = [];
      debugPrint('Error fetching report tasks: $e');
    }

    _isLoadingTasks = false;
    notifyListeners();
  }

  /// Initialize all data
  Future<void> initializeData() async {
    await loadUserProfile();
    await fetchRoutineTasks();
  }

  /// Refresh current tab data
  Future<void> refreshCurrentTasks() async {
    if (_selectedTabIndex == 0) {
      await fetchRoutineTasks();
    } else {
      await fetchReportTasks();
    }
  }

  /// Clear all data (useful for logout)
  void clearData() {
    _username = '';
    _role = '';
    _id = '';
    _imageUrl = '';
    _reportTasks.clear();
    _routineTasks.clear();
    _isLoadingTasks = false;
    _taskError = null;
    _selectedTabIndex = 0;
    notifyListeners();
  }
}
