import 'society.dart';
import 'cleaning_record.dart';

class Tank {
  final int id;
  final int societyId;
  final String location;
  final int frequencyOfCleaning;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Society? society;
  final List<CleaningRecord>? cleaningRecords;

  Tank({
    required this.id,
    required this.societyId,
    required this.location,
    required this.frequencyOfCleaning,
    this.createdAt,
    this.updatedAt,
    this.society,
    this.cleaningRecords,
  });

  factory Tank.fromJson(Map<String, dynamic> json) {
    return Tank(
      id: json['id'] as int,
      societyId: json['societyId'] as int,
      location: json['location'] as String,
      frequencyOfCleaning: json['frequencyOfCleaning'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      society: json['society'] != null
          ? Society.fromJson(json['society'] as Map<String, dynamic>)
          : null,
      cleaningRecords: json['cleaningRecords'] != null
          ? (json['cleaningRecords'] as List)
              .map((c) => CleaningRecord.fromJson(c as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'societyId': societyId,
      'location': location,
      'frequencyOfCleaning': frequencyOfCleaning,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'society': society?.toJson(),
      'cleaningRecords': cleaningRecords?.map((c) => c.toJson()).toList(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'societyId': societyId,
      'location': location,
      'frequencyOfCleaning': frequencyOfCleaning,
    };
  }
}

