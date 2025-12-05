class DashboardStats {
  final Overview overview;
  final List<PaymentStat> payments;
  final Revenue revenue;

  DashboardStats({
    required this.overview,
    required this.payments,
    required this.revenue,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      overview: Overview.fromJson(json['overview'] as Map<String, dynamic>),
      payments: (json['payments'] as List)
          .map((p) => PaymentStat.fromJson(p as Map<String, dynamic>))
          .toList(),
      revenue: Revenue.fromJson(json['revenue'] as Map<String, dynamic>),
    );
  }
}

class Overview {
  final int totalSocieties;
  final int totalTanks;
  final int totalCleanings;
  final int upcomingCleanings;
  final int overdueCleanings;
  final int recentCleanings;

  Overview({
    required this.totalSocieties,
    required this.totalTanks,
    required this.totalCleanings,
    required this.upcomingCleanings,
    required this.overdueCleanings,
    required this.recentCleanings,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      totalSocieties: int.parse(json['totalSocieties'].toString()),
      totalTanks: int.parse(json['totalTanks'].toString()),
      totalCleanings: int.parse(json['totalCleanings'].toString()),
      upcomingCleanings: int.parse(json['upcomingCleanings'].toString()),
      overdueCleanings: int.parse(json['overdueCleanings'].toString()),
      recentCleanings: int.parse(json['recentCleanings'].toString()),
    );
  }
}

class PaymentStat {
  final String paymentStatus;
  final int count;
  final double totalAmount;
  final double totalDue;

  PaymentStat({
    required this.paymentStatus,
    required this.count,
    required this.totalAmount,
    required this.totalDue,
  });

  factory PaymentStat.fromJson(Map<String, dynamic> json) {
    return PaymentStat(
      paymentStatus: json['paymentStatus'] as String,
      count: int.parse(json['count'].toString()),
      totalAmount: double.parse(json['totalAmount'].toString()),
      totalDue: double.parse(json['totalDue'].toString()),
    );
  }
}

double _parseToDouble(dynamic value) {
  if (value == null) {
    return 0.0;
  }

  if (value is num) {
    return value.toDouble();
  }

  final parsed = double.tryParse(value.toString());
  return parsed ?? 0.0;
}

class Revenue {
  final double totalRevenue;
  final double totalDue;
  final double totalCollected;

  Revenue({
    required this.totalRevenue,
    required this.totalDue,
    required this.totalCollected,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      totalRevenue: _parseToDouble(json['totalRevenue']),
      totalDue: _parseToDouble(json['totalDue']),
      totalCollected: _parseToDouble(json['totalCollected']),
    );
  }
}

class RevenueAnalytics {
  final String period;
  final int totalCleanings;
  final double totalRevenue;
  final double totalDue;
  final double totalCollected;

  RevenueAnalytics({
    required this.period,
    required this.totalCleanings,
    required this.totalRevenue,
    required this.totalDue,
    required this.totalCollected,
  });

  factory RevenueAnalytics.fromJson(Map<String, dynamic> json) {
    return RevenueAnalytics(
      period: json['period'] as String,
      totalCleanings: int.parse(json['totalCleanings'].toString()),
      totalRevenue: _parseToDouble(json['totalRevenue']),
      totalDue: _parseToDouble(json['totalDue']),
      totalCollected: _parseToDouble(json['totalCollected']),
    );
  }
}

class SocietyStat {
  final int societyId;
  final String societyName;
  final String city;
  final String state;
  final int totalTanks;
  final int totalCleanings;
  final double totalRevenue;
  final double totalDue;
  final double totalCollected;

  SocietyStat({
    required this.societyId,
    required this.societyName,
    required this.city,
    required this.state,
    required this.totalTanks,
    required this.totalCleanings,
    required this.totalRevenue,
    required this.totalDue,
    required this.totalCollected,
  });

  factory SocietyStat.fromJson(Map<String, dynamic> json) {
    return SocietyStat(
      societyId: json['societyId'] as int,
      societyName: json['societyName'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      totalTanks: int.parse(json['totalTanks'].toString()),
      totalCleanings: int.parse(json['totalCleanings'].toString()),
      totalRevenue: _parseToDouble(json['totalRevenue']),
      totalDue: _parseToDouble(json['totalDue']),
      totalCollected: _parseToDouble(json['totalCollected']),
    );
  }
}

class CleaningFrequencyStat {
  final int frequencyOfCleaning;
  final int tankCount;

  CleaningFrequencyStat({
    required this.frequencyOfCleaning,
    required this.tankCount,
  });

  factory CleaningFrequencyStat.fromJson(Map<String, dynamic> json) {
    return CleaningFrequencyStat(
      frequencyOfCleaning: json['frequencyOfCleaning'] as int,
      tankCount: int.parse(json['tankCount'].toString()),
    );
  }
}

class PaymentModeStat {
  final String? paymentMode;
  final int count;
  final double totalAmount;

  PaymentModeStat({
    required this.paymentMode,
    required this.count,
    required this.totalAmount,
  });

  factory PaymentModeStat.fromJson(Map<String, dynamic> json) {
    return PaymentModeStat(
      paymentMode: json['paymentMode'] as String?,
      count: int.parse(json['count'].toString()),
      totalAmount: double.parse(json['totalAmount'].toString()),
    );
  }
}

class LocationStat {
  final String? state;
  final String? city;
  final int societyCount;
  final int tankCount;

  LocationStat({
    required this.state,
    required this.city,
    required this.societyCount,
    required this.tankCount,
  });

  factory LocationStat.fromJson(Map<String, dynamic> json) {
    return LocationStat(
      state: json['state'] as String?,
      city: json['city'] as String?,
      societyCount: int.parse(json['societyCount'].toString()),
      tankCount: int.parse(json['tankCount'].toString()),
    );
  }
}
