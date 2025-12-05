import '../models/tank.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class TankService {
  static Future<ApiResponse<List<Tank>>> getAllTanks({
    int page = 1,
    int limit = 10,
    int? societyId,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (societyId != null) 'societyId': societyId.toString(),
    };

    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.tanks,
      queryParams: queryParams,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final tanks = (response.data as List)
          .map((t) => Tank.fromJson(t as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<Tank>>(
        success: true,
        data: tanks,
        pagination: response.pagination,
      );
    }

    return ApiResponse<List<Tank>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Tank>> getTankById(int id) async {
    final response = await ApiService.get<Map<String, dynamic>>(
      '${ApiConstants.tanks}/$id',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Tank>(
        success: true,
        data: Tank.fromJson(response.data!),
      );
    }

    return ApiResponse<Tank>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Tank>> createTank(Tank tank) async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConstants.tanks,
      body: tank.toCreateJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Tank>(
        success: true,
        message: response.message,
        data: Tank.fromJson(response.data!),
      );
    }

    return ApiResponse<Tank>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<Tank>> updateTank(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiService.put<Map<String, dynamic>>(
      '${ApiConstants.tanks}/$id',
      body: updates,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<Tank>(
        success: true,
        message: response.message,
        data: Tank.fromJson(response.data!),
      );
    }

    return ApiResponse<Tank>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<void>> deleteTank(int id) async {
    final response = await ApiService.delete<void>(
      '${ApiConstants.tanks}/$id',
    );

    return response;
  }
}

