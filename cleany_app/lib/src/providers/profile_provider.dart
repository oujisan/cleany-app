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

  /// Load user ID from secure storage
  Future<void> loadUserId() async {
    try {
      _userId = await SecureStorage.read(AppConstants.keyId) ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user ID: $e');
    }
  }

  /// Fetch user profile
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
      _profileError = e.toString();
      _profile = ProfileModel.empty();
      debugPrint('Error fetching user profile: $e');
    }

    _isLoadingProfile = false;
    notifyListeners();
  }

  /// Update user profile
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
        
        // Refresh profile data after successful update
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

  /// Delete user profile
  Future<bool> deleteUserProfile([String? specificUserId]) async {
    final targetUserId = specificUserId ?? _userId;
    
    if (targetUserId.isEmpty) {
      _deleteError = "User ID is empty";
      notifyListeners();
      return false;
    }

    _isDeletingProfile = true;
    _deleteError = null;
    _deleteMessage = null;
    notifyListeners();

    try {
      final success = await _profileService.deleteUserProfile(targetUserId);
      
      if (success) {
        _deleteMessage = "Profile deleted successfully";
        _deleteError = null;
        
        // Clear profile data after successful deletion
        _profile = ProfileModel.empty();
      } else {
        _deleteError = _profileService.getError.isEmpty 
            ? _profileService.getMessage 
            : _profileService.getError;
        _deleteMessage = null;
      }
      
      _isDeletingProfile = false;
      notifyListeners();
      return success;
    } catch (e) {
      _deleteError = e.toString();
      _deleteMessage = null;
      _isDeletingProfile = false;
      notifyListeners();
      debugPrint('Error deleting user profile: $e');
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

  /// Update specific profile field locally (before API call)
  void updateProfileField(String field, dynamic value) {
    // Since ProfileModel doesn't have copyWith method, 
    // we need to create a new instance with updated values
    switch (field.toLowerCase()) {
      case 'firstname':
        _profile = ProfileModel(
          firstName: value as String,
          lastName: _profile.lastName,
          username: _profile.username,
          email: _profile.email,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: _profile.role,
          shift: _profile.shift,
        );
        break;
      case 'lastname':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: value as String?,
          username: _profile.username,
          email: _profile.email,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: _profile.role,
          shift: _profile.shift,
        );
        break;
      case 'username':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          username: value as String,
          email: _profile.email,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: _profile.role,
          shift: _profile.shift,
        );
        break;
      case 'email':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          username: _profile.username,
          email: value as String,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: _profile.role,
          shift: _profile.shift,
        );
        break;
      case 'imageurl':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          username: _profile.username,
          email: _profile.email,
          password: _profile.password,
          imageUrl: value as String?,
          role: _profile.role,
          shift: _profile.shift,
        );
        break;
      case 'role':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          username: _profile.username,
          email: _profile.email,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: value as String,
          shift: _profile.shift,
        );
        break;
      case 'shift':
        _profile = ProfileModel(
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          username: _profile.username,
          email: _profile.email,
          password: _profile.password,
          imageUrl: _profile.imageUrl,
          role: _profile.role,
          shift: value as String?,
        );
        break;
    }
    notifyListeners();
  }
}