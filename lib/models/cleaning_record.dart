import 'tank.dart';

enum PaymentStatus { paid, unpaid, partial }

enum PaymentMode { cash, cheque, upi, card }

class CleaningRecord {
  final int id;
  final int tankId;
  final DateTime dateOfTankCleaned;
  final DateTime nextExpectedDateOfTankCleaning;
  final PaymentStatus paymentStatus;
  final PaymentMode? paymentMode;
  final double totalAmount;
  final double amountDue;
  final String? transactionId;
  final String? chequeNumber;
  final String? chequeBankName;
  final DateTime? chequeDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Tank? tank;

  CleaningRecord({
    required this.id,
    required this.tankId,
    required this.dateOfTankCleaned,
    required this.nextExpectedDateOfTankCleaning,
    required this.paymentStatus,
    this.paymentMode,
    required this.totalAmount,
    required this.amountDue,
    this.transactionId,
    this.chequeNumber,
    this.chequeBankName,
    this.chequeDate,
    this.createdAt,
    this.updatedAt,
    this.tank,
  });

  factory CleaningRecord.fromJson(Map<String, dynamic> json) {
    return CleaningRecord(
      id: json['id'] as int,
      tankId: json['tankId'] as int,
      dateOfTankCleaned: DateTime.parse(json['dateOfTankCleaned'] as String),
      nextExpectedDateOfTankCleaning: DateTime.parse(
        json['nextExpectedDateOfTankCleaning'] as String,
      ),
      paymentStatus: _parsePaymentStatus(json['paymentStatus'] as String),
      paymentMode: json['paymentMode'] != null
          ? _parsePaymentMode(json['paymentMode'] as String)
          : null,
      totalAmount: _parseToDouble(json['totalAmount']),
      amountDue: _parseToDouble(json['amountDue']),
      transactionId: json['transactionId']?.toString(),
      chequeNumber: json['chequeNumber']?.toString(),
      chequeBankName: json['chequeBankName']?.toString(),
      chequeDate: json['chequeDate'] != null
          ? DateTime.tryParse(json['chequeDate'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      tank: json['tank'] != null
          ? Tank.fromJson(json['tank'] as Map<String, dynamic>)
          : null,
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    // Handle num types (int, double)
    if (value is num) {
      return value.toDouble();
    }

    // Handle String types - parse to double
    if (value is String) {
      // Remove any whitespace
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return 0.0;
      }
      return double.tryParse(trimmed) ?? 0.0;
    }

    // For any other type, try to convert to string first, then parse
    try {
      final stringValue = value.toString().trim();
      if (stringValue.isEmpty) {
        return 0.0;
      }
      return double.tryParse(stringValue) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'unpaid':
        return PaymentStatus.unpaid;
      case 'partial':
        return PaymentStatus.partial;
      default:
        return PaymentStatus.unpaid;
    }
  }

  static PaymentMode _parsePaymentMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'cash':
        return PaymentMode.cash;
      case 'cheque':
        return PaymentMode.cheque;
      case 'upi':
      case 'online':
        return PaymentMode.upi;
      case 'card':
        return PaymentMode.card;
      default:
        return PaymentMode.cash;
    }
  }

  String get paymentStatusString {
    switch (paymentStatus) {
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.unpaid:
        return 'unpaid';
      case PaymentStatus.partial:
        return 'partial';
    }
  }

  String? get paymentModeString {
    if (paymentMode == null) return null;
    switch (paymentMode!) {
      case PaymentMode.cash:
        return 'cash';
      case PaymentMode.cheque:
        return 'cheque';
      case PaymentMode.upi:
        return 'upi';
      case PaymentMode.card:
        return 'card';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tankId': tankId,
      'dateOfTankCleaned': dateOfTankCleaned.toIso8601String().split('T')[0],
      'nextExpectedDateOfTankCleaning': nextExpectedDateOfTankCleaning
          .toIso8601String()
          .split('T')[0],
      'paymentStatus': paymentStatusString,
      'paymentMode': paymentModeString,
      'totalAmount': totalAmount,
      'amountDue': amountDue,
      'transactionId': transactionId,
      'chequeNumber': chequeNumber,
      'chequeBankName': chequeBankName,
      'chequeDate': chequeDate?.toIso8601String().split('T')[0],
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tank': tank?.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'tankId': tankId,
      'dateOfTankCleaned': dateOfTankCleaned.toIso8601String().split('T')[0],
      'nextExpectedDateOfTankCleaning': nextExpectedDateOfTankCleaning
          .toIso8601String()
          .split('T')[0],
      'paymentStatus': paymentStatusString,
      'paymentMode': paymentModeString,
      'totalAmount': totalAmount,
      'amountDue': amountDue,
      'transactionId': transactionId,
      'chequeNumber': chequeNumber,
      'chequeBankName': chequeBankName,
      'chequeDate': chequeDate?.toIso8601String().split('T')[0],
    };
  }
}
