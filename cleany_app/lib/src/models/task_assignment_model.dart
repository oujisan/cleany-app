import 'task_model.dart';

class TaskAssignmentModel {
  final String assignmentId;
  final TaskModel task;
  final String? date;
  final String status;
  final String? workedBy;
  final List<String>? proofImageUrl;
  final String createdAt;
  final String? assignmentAt;
  final String? completeAt;

  TaskAssignmentModel({
    required this.assignmentId,
    required this.task,
    this.date,
    required this.status,
    this.workedBy,
    this.proofImageUrl,
    required this.createdAt,
    this.assignmentAt,
    this.completeAt,
  });

  Map<String, dynamic> toJson() => {
    'assignmentId': assignmentId,
    'task': task.toJson(),
    'date': date,
    'status': status,
    'workedBy': workedBy,
    'proofImageUrl': proofImageUrl,
    'createdAt': createdAt,
    'assignmentAt': assignmentAt,
    'completeAt': completeAt,
  };

  factory TaskAssignmentModel.fromJson(Map<String, dynamic> json) =>
      TaskAssignmentModel(
        assignmentId: json['assigmentId'].toString(),
        task: TaskModel.fromJson(json['task']),
        date: json['date'],
        status: json['status'],
        workedBy: json['workedBy'],
        proofImageUrl:
            (json['proofImageUrl'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
        createdAt: json['createdAt'],
        assignmentAt: json['assignmentAt'],
        completeAt: json['completeAt'],
      );

  static TaskAssignmentModel empty() => TaskAssignmentModel(
    assignmentId: '',
    task: TaskModel.empty(),
    date: '',
    status: '',
    workedBy: '',
    proofImageUrl: [],
    createdAt: '',
    assignmentAt: '',
    completeAt: '',
  );

  @override
  String toString() {
    return 'TaskAssignmentModel(assignmentId: $assignmentId, task: $task, date: $date, status: $status, workedBy: $workedBy, proofImageUrl: $proofImageUrl, createdAt: $createdAt, assignmentAt: $assignmentAt, completeAt: $completeAt)';
  }
}
