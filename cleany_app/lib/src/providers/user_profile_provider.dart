import 'package:flutter/material.dart';
import 'package:cleany_app/src/models/user_profile_model.dart';
import 'package:cleany_app/src/services/user_service.dart';

enum ViewState { initial, loading, loaded, error }

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  List<UserProfile> _userProfiles = [];
  List<UserProfile> get userProfiles => _userProfiles;
  
  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // lib/providers/user_provider.dart

Future<void> getUserProfile() async {
  _state = ViewState.loading;
  notifyListeners();

  try {
    // 1. Ambil semua data dari service
    final allUsers = await _userService.fetchUserProfile(); 
    
    // 2. Filter data: hanya ambil user dengan role 'cleaner'
    _userProfiles = allUsers.where((user) => user.role.toLowerCase() == 'cleaner').toList();

    _state = ViewState.loaded;
  } catch (e) {
    _errorMessage = e.toString().replaceFirst('Exception: ', '');
    _state = ViewState.error;
  } finally {
    notifyListeners();
  }
}
}