import 'package:flutter/material.dart';
import '../models/domain/aqi_model.dart';
import '../repositories/aqi_repository.dart';

class AqiProvider extends ChangeNotifier {
  final _repository = AqiRepository();
  AqiModel? _aqi;
  bool _isLoading = false;
  String? _error;

  AqiModel? get aqi => _aqi;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAqi(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aqi = await _repository.getAqi(city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
