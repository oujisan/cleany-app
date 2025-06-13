class RoutineModel {
  final String time;
  final String startDate;
  final String endDate;
  final List<String> daysOfWeek;

  RoutineModel({
    required this.time,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
  });

  Map<String, dynamic> toJson() => {
    'time': time,
    'startDate': startDate,
    'endDate': endDate,
    'daysOfWeek': daysOfWeek,
  };

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
    time: json['time'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    daysOfWeek: json['daysOfWeek'].cast<String>(),
  );

  static RoutineModel empty() => RoutineModel(time: '', startDate: '', endDate: '', daysOfWeek: []);

  @override
  String toString() {
    return 'RoutineModel{time: $time, startDate: $startDate, endDate: $endDate, daysOfWeek: $daysOfWeek}';
  }
}