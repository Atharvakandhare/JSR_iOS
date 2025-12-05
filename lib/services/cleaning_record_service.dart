import '../models/cleaning_record.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class CleaningRecordService {
  static Future<ApiResponse<List<CleaningRecord>>> getAllCleaningRecords({
    int page = 1,
    int limit = 10,
    int? tankId,
    int? societyId,
    String? paymentStatus,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (tankId != null) 'tankId': tankId.toString(),
      if (societyId != null) 'societyId': societyId.toString(),
      if (paymentStatus != null && paymentStatus.isNotEmpty)
        'paymentStatus': paymentStatus,
      if (startDate != null && startDate.isNotEmpty) 'startDate': startDate,
      if (endDate != null && endDate.isNotEmpty) 'endDate': endDate,
    };

    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.cleaningRecords,
      queryParams: queryParams,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final records = (response.data as List)
          .map((r) => CleaningRecord.fromJson(r as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<CleaningRecord>>(
        success: true,
        data: records,
        pagination: response.pagination,
      );
    }

    return ApiResponse<List<CleaningRecord>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<CleaningRecord>>> getUpcomingCleanings({
    int days = 7,
  }) async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.upcomingCleanings,
      queryParams: {'days': days.toString()},
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final records = (response.data as List)
          .map((r) => CleaningRecord.fromJson(r as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<CleaningRecord>>(
        success: true,
        data: records,
      );
    }

    return ApiResponse<List<CleaningRecord>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<CleaningRecord>>> getOverdueCleanings() async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.overdueCleanings,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final records = (response.data as List)
          .map((r) => CleaningRecord.fromJson(r as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<CleaningRecord>>(
        success: true,
        data: records,
      );
    }

    return ApiResponse<List<CleaningRecord>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<CleaningRecord>> getCleaningRecordById(int id) async {
    final response = await ApiService.get<Map<String, dynamic>>(
      '${ApiConstants.cleaningRecords}/$id',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<CleaningRecord>(
        success: true,
        data: CleaningRecord.fromJson(response.data!),
      );
    }

    return ApiResponse<CleaningRecord>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<CleaningRecord>> createCleaningRecord(
    CleaningRecord record,
  ) async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConstants.cleaningRecords,
      body: record.toCreateJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<CleaningRecord>(
        success: true,
        message: response.message,
        data: CleaningRecord.fromJson(response.data!),
      );
    }

    return ApiResponse<CleaningRecord>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<CleaningRecord>> updateCleaningRecord(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiService.put<Map<String, dynamic>>(
      '${ApiConstants.cleaningRecords}/$id',
      body: updates,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<CleaningRecord>(
        success: true,
        message: response.message,
        data: CleaningRecord.fromJson(response.data!),
      );
    }

    return ApiResponse<CleaningRecord>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<void>> deleteCleaningRecord(int id) async {
    final response = await ApiService.delete<void>(
      '${ApiConstants.cleaningRecords}/$id',
    );

    return response;
  }
}

