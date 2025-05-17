import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/area_model.dart';

class AreaService {
  static Future<List<AreaModel>> fetchAreas() async {
    final response = await http.get(Uri.parse('https://your-api.com/api/area'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AreaModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }
}
