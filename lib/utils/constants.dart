class ApiConstants {
  // Production server URL
  static const String _productionBaseUrl = 'https://jsr.jsrtankcleaning.in';

  // Allow overriding the base URL at build-time: --dart-define=API_BASE_URL=http://192.168.1.10:5000
  // For local development, you can use: --dart-define=API_BASE_URL=http://localhost:5000
  // Android emulator: --dart-define=API_BASE_URL=http://10.0.2.2:5000
  // iOS simulator: --dart-define=API_BASE_URL=http://127.0.0.1:5000
  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    // Priority 1: Environment variable override (for custom builds/local development)
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    // Priority 2: Production server (default for all platforms)
    return _productionBaseUrl;
  }

  // Auth endpoints
  static const String login = '/tank-auth/login';
  static const String me = '/tank-auth/me';
  static const String changePassword = '/tank-auth/change-password';
  static const String setup2FA = '/tank-auth/setup-2fa';
  static const String verify2FA = '/tank-auth/verify-2fa';
  static const String disable2FA = '/tank-auth/disable-2fa';

  // Societies endpoints
  static const String societies = '/tank-societies';

  // Tanks endpoints
  static const String tanks = '/tank-tanks';

  // Cleaning records endpoints
  static const String cleaningRecords = '/tank-cleaning-records';
  static const String upcomingCleanings = '/tank-cleaning-records/upcoming';
  static const String overdueCleanings = '/tank-cleaning-records/overdue';

  // Analytics endpoints
  static const String analyticsDashboard = '/tank-analytics/dashboard';
  static const String analyticsRevenue = '/tank-analytics/revenue';
  static const String analyticsSocietyWise = '/tank-analytics/society-wise';
  static const String analyticsCleaningFrequency =
      '/tank-analytics/cleaning-frequency';
  static const String analyticsPaymentModes = '/tank-analytics/payment-modes';
  static const String analyticsLocationWise = '/tank-analytics/location-wise';

  // Notification endpoints
  static const String notifications = '/notifications';
  static String notificationCleaningRecord(int id) =>
      '$notifications/cleaning-record/$id';
  static const String notificationsBulkCleaningReminders =
      '/notifications/bulk/cleaning-reminders';
  static const String notificationsBulkPaymentReminders =
      '/notifications/bulk/payment-reminders';
  static String notificationSociety(int id) => '$notifications/society/$id';
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String user = 'user_data';
  static const String locale = 'app_locale';
  static const String theme = 'app_theme';
}
