import 'package:flutter/material.dart';
import '../models/area_model.dart';
import '../services/area_service.dart';

class AreaProvider extends ChangeNotifier {
  List<AreaModel> _areas = [];
  bool _isLoading = false;

  List<AreaModel> get areas => _areas;
  bool get isLoading => _isLoading;

  Future<void> loadAreas() async {
    _isLoading = true;
    notifyListeners();
    _areas = await AreaService.fetchAreas();
    _isLoading = false;
    notifyListeners();
  }
}
