import 'package:cleany_app/src/models/area_model.dart';
import 'package:cleany_app/src/models/routine_model.dart';

class TaskModel {
  final String taskId;
  final String title;
  final String? description;
  final List<String>? taskImageUrl;
  final String createdBy;
  final String taskType;
  final AreaModel area;
  final RoutineModel? routine;

  TaskModel({
    required this.taskId,
    required this.title,
    this.description,
    this.taskImageUrl,
    required this.createdBy,
    required this.taskType,
    required this.area,
    this.routine,
  });
  
  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'title': title,
    'description': description,
    'taskImageUrl': taskImageUrl,
    'createdBy': createdBy,
    'taskType': taskType,
    'area': area.toJson(),
    'routine': routine?.toJson(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    taskId: json['taskId'].toString(),
    title: json['title'],
    description: json['description'],
    taskImageUrl: json['taskImageUrl'] != null ? List<String>.from(json['taskImageUrl']) : null,
    createdBy: json['createdBy'],
    taskType: json['taskType'],
    area: AreaModel.fromJson(json['area']),
    routine: json['routine'] != null ? RoutineModel.fromJson(json['routine']) : null,
  );

  static TaskModel empty() => TaskModel(
    taskId: '', 
    title: '', 
    createdBy: '', 
    taskType: '', 
    area: AreaModel(
      areaId: '', 
      name: '', 
      floor: '', 
      building: ''
    )
  );

  @override
  String toString() => 'TaskModel(taskId: $taskId, title: $title, description: $description, taskImageUrl: $taskImageUrl, createdBy: $createdBy, taskType: $taskType, area: $area, routine: $routine)';
}