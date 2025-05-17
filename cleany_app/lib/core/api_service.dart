import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://localhost:7218/api';

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await SecureStorageService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await SecureStorageService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postWithoutToken(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    dynamic body,
    bool isRaw = false,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/$endpoint',
    ).replace(queryParameters: queryParams);
    final headers = {'Content-Type': 'application/json'};

    return http.put(
      uri,
      headers: headers,
      body: isRaw ? body : jsonEncode(body),
    );
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body);
    return body;
  }
}
