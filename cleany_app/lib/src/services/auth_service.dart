import 'package:cleany_app/src/models/api_response_model.dart';
import 'package:cleany_app/core/secure_storage_service.dart';
import 'package:cleany_app/src/models/login_response_model.dart';
import 'package:cleany_app/core/api_service.dart';

class AuthService {
  Future<LoginResponseModel> login(String email, String password) async {
    final json = await ApiService.postWithoutToken('auth/login', {
      'email': email,
      'password': password,
    });

    final apiResponse = ApiResponseModel<LoginResponseModel>.fromJson(
      json,
      (data) => LoginResponseModel.fromJson(data),
    );
    if (!apiResponse.success) {
      final errorMessage = apiResponse.error ?? apiResponse.message;
      throw Exception(errorMessage);
    }

    await SecureStorageService.saveToken(apiResponse.data!.token);

    return apiResponse.data!;
  }
  
  Future<void> logout() async {
    await SecureStorageService.clearToken();
  }
}
