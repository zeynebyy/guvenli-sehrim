import 'package:flutter/material.dart';
import '../models/domain/deprem_model.dart';
import '../repositories/deprem_repository.dart';
import 'settings_provider.dart';

class DepremProvider extends ChangeNotifier {
  final _repository = DepremRepository();
  List<DepremModel> _depremler = [];
  bool _isLoading = false;
  String? _error;

  List<DepremModel> get depremler => _depremler;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void update(SettingsProvider settings) {
    // React to settings if needed
  }

  Future<void> fetchDepremler() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _depremler = await _repository.getDepremler();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
