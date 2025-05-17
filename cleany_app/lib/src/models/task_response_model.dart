class TaskResponseModel {
  final String assignmentId;
  final String taskTitle;
  final String? taskDescription;
  final String? taskImageUrl;
  final String taskCreatedBy;
  final String taskType;
  final String areaId;
  final String areaName;
  final String areaFloor;
  final String areaBuilding;
  final String? routineTime;
  final String? routineStartDate;
  final String? routineEndDate;
  final List<String>? routineDays;
  final String? date;
  String status;
  final String? workedBy;
  final String? proofImageUrl;
  final String? createdAt;
  final String? assignmentAt;
  final String? completedAt;

  TaskResponseModel({
    required this.assignmentId,
    required this.taskTitle,
    this.taskDescription,
    this.taskImageUrl,
    required this.taskCreatedBy,
    required this.taskType,
    required this.areaId,
    required this.areaName,
    required this.areaFloor,
    required this.areaBuilding,
    this.routineTime,
    this.routineStartDate,
    this.routineEndDate,
    this.routineDays,
    this.date,
    required this.status,
    this.workedBy,
    this.proofImageUrl,
    this.createdAt,
    this.assignmentAt,
    this.completedAt,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    final task = json['task'] ?? {};
    final area = task['area'] ?? {};
    final routine = task['routine'];

    return TaskResponseModel(
      assignmentId: json['assigmentId'].toString(), // Sesuai JSON typo
      taskTitle: task['title'] ?? '',
      taskDescription: task['description'],
      taskImageUrl: task['imageUrl'],
      taskCreatedBy: task['createdBy'] ?? '',
      taskType: task['taskType'] ?? '',
      areaId: area['areaId']?.toString() ?? '',
      areaName: area['name'] ?? '',
      areaFloor: area['floor']?.toString() ?? '',
      areaBuilding: area['building'] ?? '',
      routineTime: routine != null ? routine['time'] : null,
      routineStartDate: routine != null ? routine['startDate'] : null,
      routineEndDate: routine != null ? routine['endDate'] : null,
      routineDays:
          routine != null && routine['daysOfWeek'] != null
              ? List<String>.from(routine['daysOfWeek'])
              : null,
      date: json['date'],
      status: json['status'] ?? '',
      workedBy: json['workedBy'],
      proofImageUrl: json['proofImageUrl'],
      createdAt: json['createdAt'],
      assignmentAt: json['assigmentAt'],
      completedAt: json['completeAt'],
    );
  }
}
