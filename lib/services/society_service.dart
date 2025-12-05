import '../models/society.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class SocietyService {
  static Future<ApiResponse<List<Society>>> getAllSocieties({
    int page = 1,
    int limit = 10,
    String? search,
    String? state,
    String? city,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (state != null && state.isNotEmpty) 'state': state,
      if (city != null && city.isNotEmpty) 'city': city,
    };

    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.societies,
      queryParams: queryParams,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final societies = (response.data as List)
          .map((s) => Society.fromJson(s as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<Society>>(
        success: true,
        data: societies,
        pagination: response.pagination,
      );
    }

    return ApiResponse<List<Society>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Society>> getSocietyById(int id) async {
    final response = await ApiService.get<Map<String, dynamic>>(
      '${ApiConstants.societies}/$id',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Society>(
        success: true,
        data: Society.fromJson(response.data!),
      );
    }

    return ApiResponse<Society>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Society>> createSociety(Society society) async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConstants.societies,
      body: society.toCreateJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Society>(
        success: true,
        message: response.message,
        data: Society.fromJson(response.data!),
      );
    }

    return ApiResponse<Society>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Society>> updateSociety(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiService.put<Map<String, dynamic>>(
      '${ApiConstants.societies}/$id',
      body: updates,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Society>(
        success: true,
        message: response.message,
        data: Society.fromJson(response.data!),
      );
    }

    return ApiResponse<Society>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<void>> deleteSociety(int id) async {
    final response = await ApiService.delete<void>(
      '${ApiConstants.societies}/$id',
    );

    return response;
  }
}

