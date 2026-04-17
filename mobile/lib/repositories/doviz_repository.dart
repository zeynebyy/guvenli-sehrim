import 'dart:convert';
import 'package:hive/hive.dart';
import '../services/api/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/dto/doviz_dto.dart';
import '../models/domain/doviz_model.dart';

class DovizRepository {
  final ApiService _apiService = ApiService();
  final Box _cacheBox = Hive.box('cache_doviz');

  Future<List<DovizModel>> getDovizKurlari() async {
    try {
      final response = await _apiService.getRequest(ApiConstants.doviz);
      final responseData = response.data;
      
      final List data = (responseData is Map && responseData.containsKey('data')) 
          ? responseData['data'] 
          : (responseData is List ? responseData : []);
          
      final list = data.map((json) => DovizDto.fromJson(json)).toList();
      
      await _cacheBox.put('doviz_cache', jsonEncode(data));
      
      return list.map((e) => e.toDomain()).toList();
    } catch (e) {
      final cachedJson = _cacheBox.get('doviz_cache');
      if (cachedJson != null) {
        final List decoded = jsonDecode(cachedJson);
        return decoded.map((json) => DovizDto.fromJson(json).toDomain()).toList();
      }
      rethrow;
    }
  }
}
