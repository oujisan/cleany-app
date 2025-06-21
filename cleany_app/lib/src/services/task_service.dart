import 'package:cleany_app/core/constant.dart';
import 'package:cleany_app/src/models/task_assignment_model.dart';
import 'package:cleany_app/src/models/verification_model.dart';
import 'package:http/http.dart' as http;
import 'package:cleany_app/core/secure_storage.dart';
import 'dart:convert';

class TaskService {
  String _message = '';
  String _error = '';

  Future<List<Map<String, String>>> fetchReportTasks(String userId) async {
    final url = Uri.parse(AppConstants.apiFetchUserReportTasksUrl(userId));
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
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        if (apiResponse['data'] != null && apiResponse['data'] is List) {
          final List<dynamic> data = apiResponse['data'];

          final tasks =
              data.map<Map<String, String>>((item) {
                return {
                  'assignmentId': item['assigmentId']?.toString() ?? '',
                  'title': item['task']['title'] ?? '',
                  'createdBy': item['task']['createdBy'] ?? '',
                  'status': item['status'] ?? '',
                  'areaName': item['task']['area']['name'] ?? '',
                  'areaBuilding': item['task']['area']['building'] ?? '',
                  'taskType': item['task']['taskType'] ?? '',
                };
              }).toList();
          return tasks;
        } else {
          return [];
        }
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return [];
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchAllReportTasks() async {
    final url = Uri.parse(AppConstants.apiFetchTaskReportUrl());
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
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        if (apiResponse['data'] != null && apiResponse['data'] is List) {
          final List<dynamic> data = apiResponse['data'];

          final tasks =
              data.map<Map<String, String>>((item) {
                return {
                  'assignmentId': item['assigmentId']?.toString() ?? '',
                  'title': item['task']['title'] ?? '',
                  'createdBy': item['task']['createdBy'] ?? '',
                  'status': item['status'] ?? '',
                  'areaName': item['task']['area']['name'] ?? '',
                  'areaBuilding': item['task']['area']['building'] ?? '',
                  'taskType': item['task']['taskType'] ?? '',
                };
              }).toList();
          return tasks;
        } else {
          return [];
        }
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return [];
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchRoutineTasks() async {
    final getUrl = AppConstants.apiFetchRoutineTasksUrl;
    final url = Uri.parse(getUrl);
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
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        if (apiResponse['data'] != null && apiResponse['data'] is List) {
          final List<dynamic> data = apiResponse['data'];

          final tasks =
              data.map<Map<String, String>>((item) {
                return {
                  'assignmentId': item['assigmentId'].toString(),
                  'title': item['task']['title'] ?? '',
                  'status': item['status'] ?? '',
                  'areaName': item['task']['area']['name'] ?? '',
                  'areaBuilding': item['task']['area']['building'] ?? '',
                  'time': item['task']['routine']['time'] ?? '',
                };
              }).toList();

          return tasks;
        }
      }

      _message = apiResponse['message'];
      _error = apiResponse['error'];
      return [];
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return [];
    }
  }

  Future<TaskAssignmentModel> fetchTaskAssignmentDetails(
    String assignmentId,
  ) async {
    final url = Uri.parse(
      AppConstants.apiFetchTaskAssignmentByIdUrl(assignmentId),
    );
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
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
        return TaskAssignmentModel.fromJson(apiResponse['data']);
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return TaskAssignmentModel.empty();
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return TaskAssignmentModel.empty();
    }
  }

  Future<bool> addReportTask({
    required String title,
    required String description,
    required List<String> imageUrlList,
    required int areaId,
  }) async {
    final url = Uri.parse(AppConstants.apiAddReportTaskUrl);

    try {
      final token = await SecureStorage.read(AppConstants.keyToken);

      if (token == null) {
        throw Exception("Token not found");
      }

      final requestBody = {
        "title": title,
        "description": description,
        "imageUrl": imageUrlList,
        "areaId": areaId,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: jsonEncode(requestBody),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> addRoutineTask({
    required String title,
    required String description,
    required String areaId,
    required String time,
    List<String>? imageUrlList,
    required String startDate,
    required String endDate,
    required List<int> days,
  }) async {
    final url = Uri.parse(AppConstants.apiAddRoutineTaskUrl);

    try {
      final token = await SecureStorage.read(AppConstants.keyToken);

      if (token == null) {
        throw Exception("Token not found");
      }

      final requestBody = {
        "title": title,
        "description": description,
        "areaId": areaId,
        "time": time,
        "imageUrl": imageUrlList,
        "startDate": startDate,
        "endDate": endDate,
        "daysOfWeek": days,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: jsonEncode(requestBody),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> updateStatusReportTask({
    required String assignmentId,
    required String status,
  }) async {
    final url = Uri.parse(
      AppConstants.apiUpdateStatusTaskAssignmentUrl(assignmentId),
    );

    try {
      final token = await SecureStorage.read(AppConstants.keyToken);

      if (token == null) {
        throw Exception("Token not found");
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: jsonEncode(status),
      );
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<VerificationModel> fetchVerificationTask(String assignmentId) async {
    final url = Uri.parse(
      AppConstants.apiFetchVerificationByAssignmentIdUrl(assignmentId),
    );
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
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _message = apiResponse['message'];
        return VerificationModel.fromJson(apiResponse['data'][0]);
      } else {
        _message = apiResponse['message'];
        _error = apiResponse['error'];
        return VerificationModel.empty();
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return VerificationModel.empty();
    }
  }

  Future<bool> updateVerificationStatusTask({
    required String assignmentId,
    required String status,
    String? feedback,
  }) async {
    final url = Uri.parse(
      AppConstants.apiUpdateVerificationStatusUrl(assignmentId),
    );

    try {
      final token = await SecureStorage.read(AppConstants.keyToken);

      if (token == null) {
        throw Exception("Token not found");
      }

      final reqBody = {"status": status, "feedback": feedback ?? ''};

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode(reqBody),
      );
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  // Method untuk update report task
  Future<bool> updateReportTask({
    required String taskId,
    required String title,
    required String description,
    required List<String> imageUrlList,
    required int areaId,
  }) async {
    final url = Uri.parse(AppConstants.apiUpdateReportTaskUrl(taskId));

    try {
      final requestBody = {
        'title': title,
        'description': description,
        'imageUrl': imageUrlList,
        'areaId': areaId,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: json.encode(requestBody),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        _message = apiResponse['message'] ?? 'Task berhasil diperbarui';
        return true;
      } else {
        _message = apiResponse['message'] ?? 'Gagal memperbarui task';
        _error = apiResponse['error'] ?? 'Unknown error';
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> updateRoutineTask({
    required String taskId,
    required String title,
    required String description,
    required List<String> imageUrlList,
    required String areaId,
    required String time,
    required String startDate,
    required String endDate,
    required List<int> days,
  }) async {
    final url = Uri.parse(AppConstants.apiUpdateRoutineTaskUrl(taskId));

    try {
      final requestBody = {
        'title': title,
        'description': description,
        'imageUrl': imageUrlList,
        'areaId': areaId,
        'time': time,
        'startDate': startDate,
        'endDate': endDate,
        'daysOfWeek': days,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: json.encode(requestBody),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        _message = apiResponse['message'] ?? 'Task berhasil diperbarui';
        return true;
      } else {
        _message = apiResponse['message'] ?? 'Gagal memperbarui task';
        _error = apiResponse['error'] ?? 'Unknown error';
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> addProofImage({
    required String assignmentId,
    required List<String> imageUrls,
  }) async {
    final url = Uri.parse(
      AppConstants.apiUpdateTaskProofImagesUrl(assignmentId),
    );

    try {
      final token = await SecureStorage.read(AppConstants.keyToken);

      if (token == null) {
        throw Exception("Token not found");
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: jsonEncode(imageUrls),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    final url = Uri.parse(AppConstants.apiDeleteTask(taskId));

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message = responseBody['message'];
        return true;
      } else {
        _message = responseBody['message'];
        _error = responseBody['error'];
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  Future<bool> updateLocationTask({
    required String assignmentId,
    required String latitude,
    required String longitude,
  }) async {
    final url = Uri.parse(AppConstants.apiUpdateLocationAssignmentUrl(assignmentId));

    try {
      final requestBody = {
        'latitude': latitude,
        'longitude': longitude,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization':
              'Bearer ${await SecureStorage.read(AppConstants.keyToken)}',
        },
        body: json.encode(requestBody),
      );

      final apiResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        _message = apiResponse['message'] ?? 'Task berhasil diperbarui';
        return true;
      } else {
        _message = apiResponse['message'] ?? 'Gagal memperbarui task';
        _error = apiResponse['error'] ?? 'Unknown error';
        return false;
      }
    } catch (e) {
      _message = 'Exception occurred';
      _error = e.toString();
      return false;
    }
  }

  String get getMessage => _message;
  String get getError => _error;
}
