// Tank import removed to avoid circular dependency
// Import tank.dart only when needed in specific files

class Society {
  final int id;
  final String name;
  final String state;
  final String city;
  final String pincode;
  final String fullAddress;
  final String chairmanName;
  final String chairmanPhone;
  final String chairmanEmail;
  final String secretaryName;
  final String secretaryPhone;
  final String secretaryEmail;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? tanks; // Using dynamic to avoid circular dependency

  Society({
    required this.id,
    required this.name,
    required this.state,
    required this.city,
    required this.pincode,
    required this.fullAddress,
    required this.chairmanName,
    required this.chairmanPhone,
    required this.chairmanEmail,
    required this.secretaryName,
    required this.secretaryPhone,
    required this.secretaryEmail,
    this.createdAt,
    this.updatedAt,
    this.tanks,
  });

  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['id'] as int,
      name: json['name'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      pincode: json['pincode']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
      chairmanName: json['chairmanName']?.toString() ?? '',
      chairmanPhone: json['chairmanPhone']?.toString() ?? '',
      chairmanEmail: json['chairmanEmail']?.toString() ?? '',
      secretaryName: json['secretaryName']?.toString() ?? '',
      secretaryPhone: json['secretaryPhone']?.toString() ?? '',
      secretaryEmail: json['secretaryEmail']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      // Tanks stored as raw JSON to avoid circular dependency
      tanks: json['tanks'] != null ? (json['tanks'] as List) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'city': city,
      'pincode': pincode,
      'fullAddress': fullAddress,
      'chairmanName': chairmanName,
      'chairmanPhone': chairmanPhone,
      'chairmanEmail': chairmanEmail,
      'secretaryName': secretaryName,
      'secretaryPhone': secretaryPhone,
      'secretaryEmail': secretaryEmail,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      // Tanks serialization - convert dynamic list to JSON
      'tanks': tanks
          ?.map((t) {
            if (t is Map<String, dynamic>) {
              return t;
            }
            // If it's already a Tank object, convert to JSON
            try {
              return (t as dynamic).toJson();
            } catch (e) {
              return null;
            }
          })
          .whereType<Map<String, dynamic>>()
          .toList(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'state': state,
      'city': city,
      'pincode': pincode,
      'fullAddress': fullAddress,
      'chairmanName': chairmanName,
      'chairmanPhone': chairmanPhone,
      'chairmanEmail': chairmanEmail,
      'secretaryName': secretaryName,
      'secretaryPhone': secretaryPhone,
      'secretaryEmail': secretaryEmail,
    };
  }
}
