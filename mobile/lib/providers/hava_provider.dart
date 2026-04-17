import 'package:flutter/material.dart';
import '../models/domain/hava_model.dart';
import '../repositories/hava_repository.dart';

class HavaProvider extends ChangeNotifier {
  final _repository = HavaRepository();
  HavaModel? _hava;
  bool _isLoading = false;
  String? _error;

  HavaModel? get hava => _hava;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHava(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _hava = await _repository.getHavaDurumu(city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
