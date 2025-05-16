import 'package:flutter/material.dart';
import 'package:cleany_app/src/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cleany_app/src/models/login_response_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  LoginResponseModel? _loginResponse;
  bool _isLoading = false;

  String? _username;
  String? _role;
  int? _userId;

  LoginResponseModel? get loginResponse => _loginResponse;
  bool get isLoading => _isLoading;
  String? get username => _username;
  String? get role => _role;
  int? get userId => _userId;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);
      _loginResponse = result;
      _username = result.username;

      // Simpan data penting ke secure storage
      await _storage.write(key: 'token', value: result.token);
      await _storage.write(key: 'user_role', value: result.role);
      await _storage.write(key: 'user_id', value: result.userId.toString());
      await _storage.write(key: 'username', value: result.username);

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _loginResponse = null;
    _username = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    final storedToken = await _storage.read(key: 'token');
    final storedUsername = await _storage.read(key: 'username');
    final storedUserId = await _storage.read(key: 'user_id');
    final storedUserRole = await _storage.read(key: 'user_role');

    if (storedToken != null &&
        storedUsername != null &&
        storedUserId != null &&
        storedUserRole != null) {
      _loginResponse = LoginResponseModel(
        token: storedToken,
        userId: storedUserId,
        username: storedUsername,
        role: storedUserRole,
      );
      _username = storedUsername;
      _userId = int.parse(storedUserId);
      _role = storedUserRole;

      notifyListeners();
    }
  }
}
