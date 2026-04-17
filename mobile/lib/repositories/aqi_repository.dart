import 'dart:convert';
import 'package:hive/hive.dart';
import '../services/api/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/dto/aqi_dto.dart';
import '../models/domain/aqi_model.dart';

class AqiRepository {
  final ApiService _apiService = ApiService();
  final Box _cacheBox = Hive.box('cache_aqi');

  Future<AqiModel> getAqi(String il) async {
    final cacheKey = 'aqi_$il';
    try {
      final response = await _apiService.getRequest(ApiConstants.kalite, queryParameters: {'il': il});
      
      final responseData = response.data;
      final data = (responseData is Map && responseData.containsKey('data')) 
          ? responseData['data'] 
          : responseData;
      
      await _cacheBox.put(cacheKey, jsonEncode(data));
      
      return AqiDto.fromJson(data).toDomain();
    } catch (e) {
      final cachedJson = _cacheBox.get(cacheKey);
      if (cachedJson != null) {
        return AqiDto.fromJson(jsonDecode(cachedJson)).toDomain();
      }
      rethrow;
    }
  }
}
