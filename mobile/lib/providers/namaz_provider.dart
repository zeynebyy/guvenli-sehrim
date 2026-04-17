import 'package:flutter/material.dart';
import '../models/domain/namaz_model.dart';
import '../repositories/namaz_repository.dart';

class NamazProvider extends ChangeNotifier {
  final _repository = NamazRepository();
  NamazModel? _namaz;
  bool _isLoading = false;
  String? _error;

  NamazModel? get namaz => _namaz;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNamaz(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _namaz = await _repository.getNamazVakitleri(city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
