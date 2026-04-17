import 'dart:convert';
import 'package:hive/hive.dart';
import '../services/api/api_service.dart';
import '../core/constants/api_constants.dart';
import '../models/dto/deprem_dto.dart';
import '../models/domain/deprem_model.dart';

class DepremRepository {
  final ApiService _apiService = ApiService();
  final Box _cacheBox = Hive.box('cache_deprem');

  Future<List<DepremModel>> getDepremler() async {
    try {
      final response = await _apiService.getRequest(ApiConstants.deprem);
      final responseData = response.data;
      
      final List data = (responseData is Map && responseData.containsKey('data')) 
          ? responseData['data'] 
          : (responseData ?? []);
          
      final list = data.map((json) => DepremDto.fromJson(json)).toList();
      
      // Cache the result
      await _cacheBox.put('last_data', jsonEncode(data));
      
      return list.map((e) => e.toDomain()).toList();
    } catch (e) {
      final cachedJson = _cacheBox.get('last_data');
      if (cachedJson != null) {
        final List decoded = jsonDecode(cachedJson);
        return decoded.map((json) => DepremDto.fromJson(json).toDomain()).toList();
      }
      rethrow;
    }
  }
}
