import 'dart:convert';
import 'package:hive/hive.dart';
import '../services/api/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/dto/hava_dto.dart';
import '../models/domain/hava_model.dart';

class HavaRepository {
  final ApiService _apiService = ApiService();
  final Box _cacheBox = Hive.box('cache_hava');

  Future<HavaModel> getHavaDurumu(String city) async {
    final cacheKey = 'hava_$city';
    try {
      final response = await _apiService.getRequest(ApiConstants.hava, queryParameters: {'il': city});
      
      // Handle wrapped source/data structure from cache middleware
      final responseData = response.data;
      final cleanedData = (responseData is Map && responseData.containsKey('data')) 
          ? responseData['data'] 
          : responseData;
      
      await _cacheBox.put(cacheKey, jsonEncode(cleanedData));
      
      return HavaDto.fromJson(cleanedData).toDomain();
    } catch (e) {
      final cachedJson = _cacheBox.get(cacheKey);
      if (cachedJson != null) {
        return HavaDto.fromJson(jsonDecode(cachedJson)).toDomain();
      }
      rethrow;
    }
  }
}
