import '../models/analytics.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AnalyticsService {
  static Future<ApiResponse<DashboardStats>> getDashboardStats() async {
    final response = await ApiService.get<Map<String, dynamic>>(
      ApiConstants.analyticsDashboard,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<DashboardStats>(
        success: true,
        data: DashboardStats.fromJson(response.data!),
      );
    }

    return ApiResponse<DashboardStats>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<RevenueAnalytics>>> getRevenueAnalytics({
    String period = 'monthly',
    int? year,
  }) async {
    final queryParams = <String, String>{
      'period': period,
      if (year != null) 'year': year.toString(),
    };

    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.analyticsRevenue,
      queryParams: queryParams,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final analytics = (response.data as List)
          .map((a) => RevenueAnalytics.fromJson(a as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<RevenueAnalytics>>(
        success: true,
        data: analytics,
      );
    }

    return ApiResponse<List<RevenueAnalytics>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<SocietyStat>>> getSocietyWiseStats({
    int limit = 10,
    String sortBy = 'totalRevenue',
    String order = 'DESC',
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'sortBy': sortBy,
      'order': order,
    };

    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.analyticsSocietyWise,
      queryParams: queryParams,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final stats = (response.data as List)
          .map((s) => SocietyStat.fromJson(s as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<SocietyStat>>(
        success: true,
        data: stats,
      );
    }

    return ApiResponse<List<SocietyStat>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<CleaningFrequencyStat>>>
      getCleaningFrequencyStats() async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.analyticsCleaningFrequency,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final stats = (response.data as List)
          .map((s) => CleaningFrequencyStat.fromJson(s as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<CleaningFrequencyStat>>(
        success: true,
        data: stats,
      );
    }

    return ApiResponse<List<CleaningFrequencyStat>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<PaymentModeStat>>> getPaymentModeStats() async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.analyticsPaymentModes,
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final stats = (response.data as List)
          .map((s) => PaymentModeStat.fromJson(s as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<PaymentModeStat>>(
        success: true,
        data: stats,
      );
    }

    return ApiResponse<List<PaymentModeStat>>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<List<LocationStat>>> getLocationWiseStats({
    String groupBy = 'state',
  }) async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConstants.analyticsLocationWise,
      queryParams: {'groupBy': groupBy},
      fromJson: (json) => json as List<dynamic>,
    );

    if (response.success && response.data != null) {
      final stats = (response.data as List)
          .map((s) => LocationStat.fromJson(s as Map<String, dynamic>))
          .toList();

      return ApiResponse<List<LocationStat>>(
        success: true,
        data: stats,
      );
    }

    return ApiResponse<List<LocationStat>>(
      success: false,
      message: response.message,
    );
  }
}

