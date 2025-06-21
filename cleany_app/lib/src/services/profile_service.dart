import 'package:cleany_app/src/models/profile_model.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:cleany_app/core/secure_storage.dart';
import 'dart:convert';

class ProfileService {
    String _message = '';
    String _error = '';
  
    String get getMessage => _message;
    String get getError => _error;
 Future<ProfileModel> fetchUserProfile(String userId) async {
  final url = Uri.parse(AppConstants.apiFetchUserProfileUrl(userId));
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
      },
    );

    final apiResponse = json.decode(response.body);

    if (response.statusCode == 200 && apiResponse['data'] != null) {
      return ProfileModel.fromJson(apiResponse['data']);
    } else {
      _message = apiResponse['message'];
      _error = apiResponse['error'];
      return ProfileModel.empty(); 
    }
  } catch (e) {
    _message = 'Exception occurred';
    _error = e.toString();
    return ProfileModel.empty();
  }
}

  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final url = Uri.parse(AppConstants.updateUserProfileUrl(userId));
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: json.encode(data),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteUserProfile(String userId) async {
    final url = Uri.parse(AppConstants.apiDeleteUserProfileUrl(userId));
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }
}

