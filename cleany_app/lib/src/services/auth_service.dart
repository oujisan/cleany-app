import 'package:cleany_app/core/secure_storage.dart';
import 'package:cleany_app/core/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cleany_app/src/models/register_model.dart';

class AuthService {
  String _message = '';
  String _error = '';


  Future<bool> login(String email, String password) async {
    final url = Uri.parse(AppConstants.apiLoginUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = apiResponse['data'];
        final token = data['token'];
        final user = data['user'];
        final userId = user['userId'];
        final username = user['username'];
        final role = user['role'];
        final imageUrl = user['image_url'];

        // Token Expire Data
        final splitToken = token.split('.');
        var payload = splitToken[1];
        var normalized = base64Url.normalize(payload);
        final payloadJson = utf8.decode(base64Url.decode(normalized));
        final payloadMap = json.decode(payloadJson);
        final expireInUnix = payloadMap['exp'];

        await SecureStorage.write(AppConstants.keyToken, token);
        await SecureStorage.write(AppConstants.keyId, userId.toString());
        await SecureStorage.write(AppConstants.keyUsername, username);
        await SecureStorage.write(AppConstants.keyRole, role);
        await SecureStorage.write(AppConstants.keyImageUrl, imageUrl ?? '');
        await SecureStorage.write(
          AppConstants.keyExpireInUnix,
          expireInUnix.toString(),
        );

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

  Future<bool> register(RegisterModel registerData) async {
    final url = Uri.parse(AppConstants.apiRegisterUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registerData.toJson()),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
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

  Future<bool> forgotPassword(String email) async {
    final url = Uri.parse(AppConstants.apiForgotPasswordUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
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

  Future<bool> verifyCode(String email, String code) async {
    final url = Uri.parse(AppConstants.apiVerifyPasswordUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code}),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
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

  Future<bool> resetPassword(String email, String password) async {
    final url = Uri.parse(AppConstants.apiResetPasswordUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'newPassword': password}),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
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

  Future<String> getToken() async {
    final token = await SecureStorage.read(AppConstants.keyToken);
    return token ?? '';
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.read(AppConstants.keyToken);
    if (token == null) {
      return false;
    }

    final expireInUnix = await SecureStorage.read(AppConstants.keyExpireInUnix);

    final exp = int.tryParse(expireInUnix ?? '');
    if (exp == null) {
      await SecureStorage.clear();
      return false;
    }

    final expireDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now().toUtc();

    if (now.isAfter(expireDate)) {
      await SecureStorage.clear();
      return false;
    }

    return true;
  }

  Future<bool> logout() async {
    await SecureStorage.clear();
    return true;
  }

  String get getMessage => _message;
  String get getError => _error;
}
