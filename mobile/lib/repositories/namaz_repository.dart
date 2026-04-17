import 'dart:convert';
import 'package:hive/hive.dart';
import '../services/api/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/dto/namaz_dto.dart';
import '../models/domain/namaz_model.dart';

class NamazRepository {
  final ApiService _apiService = ApiService();
  final Box _cacheBox = Hive.box('cache_namaz');

  Future<NamazModel> getNamazVakitleri(String city) async {
    final cacheKey = 'namaz_$city';
    try {
      final response = await _apiService.getRequest(ApiConstants.namaz, queryParameters: {'city': city});
      
      final responseData = response.data;
      final data = (responseData is Map && responseData.containsKey('data')) 
          ? responseData['data'] 
          : responseData;
      
      await _cacheBox.put(cacheKey, jsonEncode(data));
      
      return NamazDto.fromJson(data).toDomain();
    } catch (e) {
      final cachedJson = _cacheBox.get(cacheKey);
      if (cachedJson != null) {
        return NamazDto.fromJson(jsonDecode(cachedJson)).toDomain();
      }
      rethrow;
    }
  }
}
