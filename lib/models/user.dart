class User {
  final int id;
  final String username;
  final String role;
  final bool twoFactorEnabled;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.twoFactorEnabled,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      role: json['role'] as String,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'twoFactorEnabled': twoFactorEnabled,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

