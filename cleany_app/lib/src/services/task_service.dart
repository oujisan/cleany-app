import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:cleany_app/src/models/task_response_model.dart';
import 'package:cleany_app/core/api_service.dart';
import 'dart:convert';

class TaskService {
  Future<List<TaskResponseModel>> getReportTasks() async {
    final Map<String, dynamic> json = await ApiService.get(
      'task/report/assignment',
    );

    final data = json['data'];

    if (data is List) {
      return data.map((item) => TaskResponseModel.fromJson(item)).toList();
    } else {
      throw Exception('Unexpected data format');
    }
  }

  static Future<void> updateTaskStatus({
    required int assignmentId,
    required String status,
  }) async {
    final response = await ApiService.put(
      'task/status_update/$assignmentId',
      body: status,
      isRaw: false,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }

    static Future<void> createTaskReport({
    required String title,
    required String description,
    required String imageUrl,
    required int areaId,
  }) async {
    final response = await http.post(
      Uri.parse('https://localhost:7218/api/task/report/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'areaId': areaId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create task report');
    }
  }

}
