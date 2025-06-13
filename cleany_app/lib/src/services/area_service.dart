import 'package:cleany_app/src/models/area_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/core/secure_storage.dart';

class AreaService {
  String _message = '';
  String _error = '';

  String get getMessage => _message;
  String get getError => _error;

  Future<List<AreaModel>> fetchAllArea() async {
    final url = Uri.parse(AppConstants.apiFetchAreaUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
      );
      final apiResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = apiResponse['data'];

        // Pakai AreaModel.fromJson
        final List<AreaModel> areas =
            data.map((json) => AreaModel.fromJson(json)).toList();

        return areas;
      } else {
        _message = 'Failed to load areas';
        _error = response.body;
        return [];
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return [];
    }
  }
}
