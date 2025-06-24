import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/src/services/profile_service.dart';
import 'package:cleany_app/src/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  // User profile data
  ProfileModel _profile = ProfileModel.empty();
  String _userId = '';
  
  // Loading states
  bool _isLoadingProfile = false;
  bool _isUpdatingProfile = false;
  bool _isDeletingProfile = false;
  
  // Error handling
  String? _profileError;
  String? _updateError;
  String? _deleteError;
  
  // Success messages
  String? _updateMessage;
  String? _deleteMessage;

  // Getters
  ProfileModel get profile => _profile;
  String get userId => _userId;
  
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isUpdatingProfile => _isUpdatingProfile;
  bool get isDeletingProfile => _isDeletingProfile;
  
  String? get profileError => _profileError;
  String? get updateError => _updateError;
  String? get deleteError => _deleteError;
  
  String? get updateMessage => _updateMessage;
  String? get deleteMessage => _deleteMessage;
  
  bool get hasProfile => _profile.username.isNotEmpty;

  final ProfileService _profileService = ProfileService();

  Future<void> loadUserId() async {
    try {
      _userId = await SecureStorage.read(AppConstants.keyId) ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user ID: $e');
    }
  }

  Future<void> fetchUserProfile([String? specificUserId]) async {
  final targetUserId = specificUserId ?? _userId;
  
  if (targetUserId.isEmpty) {
    _profileError = "User ID is empty";
    notifyListeners();
    return;
  }

  _isLoadingProfile = true;
  _profileError = null;
  notifyListeners();

  try {
    final profile = await _profileService.fetchUserProfile(targetUserId);

    if (profile.username.isNotEmpty) {
      _profile = profile;
      _profileError = null;
    } else {
      _profileError = _profileService.getError.isEmpty
          ? _profileService.getMessage
          : _profileService.getError;
      _profile = ProfileModel.empty();
    }
  } catch (e) {
    final errorMessage = e.toString();

    // Tangani khusus error shift_name null
    if (errorMessage.contains("shift_name")) {
      debugPrint("shift_name is null - continue rendering profile.");
      _profile = ProfileModel.empty(); // atau tetap gunakan _profile jika ada default
      _profileError = null; // tidak perlu tunjukkan error di UI
    } else {
      _profileError = errorMessage;
      _profile = ProfileModel.empty();
      debugPrint('Error fetching user profile: $e');
    }
  }

  _isLoadingProfile = false;
  notifyListeners();
}


  Future<bool> updateUserProfile(Map<String, dynamic> data, [String? specificUserId]) async {
    final targetUserId = specificUserId ?? _userId;
    
    if (targetUserId.isEmpty) {
      _updateError = "User ID is empty";
      notifyListeners();
      return false;
    }

    _isUpdatingProfile = true;
    _updateError = null;
    _updateMessage = null;
    notifyListeners();

    try {
      final success = await _profileService.updateUserProfile(targetUserId, data);
      
      if (success) {
        _updateMessage = "Profile updated successfully";
        _updateError = null;
        
        await fetchUserProfile(targetUserId);
      } else {
        _updateError = _profileService.getError.isEmpty 
            ? _profileService.getMessage 
            : _profileService.getError;
        _updateMessage = null;
      }
      
      _isUpdatingProfile = false;
      notifyListeners();
      return success;
    } catch (e) {
      _updateError = e.toString();
      _updateMessage = null;
      _isUpdatingProfile = false;
      notifyListeners();
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }



  /// Initialize profile data
  Future<void> initializeProfile() async {
    await loadUserId();
    if (_userId.isNotEmpty) {
      await fetchUserProfile();
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }

  /// Clear all error messages
  void clearErrors() {
    _profileError = null;
    _updateError = null;
    _deleteError = null;
    notifyListeners();
  }

  /// Clear all success messages
  void clearMessages() {
    _updateMessage = null;
    _deleteMessage = null;
    notifyListeners();
  }

  /// Clear all data (useful for logout)
  void clearData() {
    _profile = ProfileModel.empty();
    _userId = '';
    _isLoadingProfile = false;
    _isUpdatingProfile = false;
    _isDeletingProfile = false;
    _profileError = null;
    _updateError = null;
    _deleteError = null;
    _updateMessage = null;
    _deleteMessage = null;
    notifyListeners();
  }
 
  
}