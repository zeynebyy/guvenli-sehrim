import 'package:flutter/material.dart';
import '../models/domain/doviz_model.dart';
import '../repositories/doviz_repository.dart';

class DovizProvider extends ChangeNotifier {
  final _repository = DovizRepository();
  List<DovizModel> _dovizList = [];
  bool _isLoading = false;
  String? _error;

  List<DovizModel> get dovizList => _dovizList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDoviz() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dovizList = await _repository.getDovizKurlari();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
