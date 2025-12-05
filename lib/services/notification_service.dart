import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class NotificationService {
  /// Send notification for a specific cleaning record
  static Future<ApiResponse<void>> sendCleaningRecordNotification(
    int cleaningRecordId,
  ) async {
    final response = await ApiService.post<void>(
      ApiConstants.notificationCleaningRecord(cleaningRecordId),
    );

    return response;
  }

  /// Send bulk cleaning reminders
  static Future<ApiResponse<void>> sendBulkCleaningReminders() async {
    final response = await ApiService.post<void>(
      ApiConstants.notificationsBulkCleaningReminders,
    );

    return response;
  }

  /// Send bulk payment reminders
  static Future<ApiResponse<void>> sendBulkPaymentReminders() async {
    final response = await ApiService.post<void>(
      ApiConstants.notificationsBulkPaymentReminders,
    );

    return response;
  }

  /// Send notification for a specific society
  static Future<ApiResponse<void>> sendSocietyNotification(
    int societyId,
  ) async {
    final response = await ApiService.post<void>(
      ApiConstants.notificationSociety(societyId),
    );

    return response;
  }
}








