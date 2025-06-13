class AreaModel {
  final String areaId;
  final String name;
  final String floor;
  final String building;

  AreaModel({
    required this.areaId,
    required this.name,
    required this.floor,
    required this.building,
  });

  Map<String, dynamic> toJson() => {
        'areaId': areaId,
        'name': name,
        'floor': floor,
        'building': building,
      };

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        areaId: json['areaId'].toString(),
        name: json['name'],
        floor: json['floor'].toString(),
        building: json['building'],
  );

  @override
  String toString() => 'AreaModel(areaId: $areaId, name: $name, floor: $floor, building: $building)';
}
