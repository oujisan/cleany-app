import 'package:cleany_app/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:cleany_app/src/models/user_profile_model.dart';
import 'package:cleany_app/core/secure_storage.dart';

class UserService {
  Future<List<UserProfile>> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.apiFetchProfileUserUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = apiResponseFromJson(response.body);
        if (apiResponse.success && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        // Handle server errors (e.g., 500, 404)
        throw Exception('Failed to load user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print(e.toString());
      throw Exception('An error occurred: ${e.toString()}');
    }
  }
}