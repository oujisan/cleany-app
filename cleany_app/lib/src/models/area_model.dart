class AreaModel {
  final int id;
  final String name;
  final String floor;
  final String building;

  AreaModel({
    required this.id,
    required this.name,
    required this.floor,
    required this.building,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['area_id'],
      name: json['area_name'],
      floor: json['floor'],
      building: json['building'],
    );
  }

  String get fullDescription => '$name - Lantai $floor - $building';
}
