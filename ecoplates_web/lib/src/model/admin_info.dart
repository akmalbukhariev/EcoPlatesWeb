
import '../constant/admin_role.dart';

class AdminInfo {
  int? id;
  String adminId;
  String? passwordHash;
  String? token;
  AdminRole adminRole;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool deleted;

  AdminInfo({
    this.id,
    required this.adminId,
    this.passwordHash,
    this.token,
    required this.adminRole,
    this.createdAt,
    this.updatedAt,
    this.deleted = false
  });

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'password_hash': passwordHash,
      'token': token,
      'admin_role': adminRole.name, // Assuming AdminRole is an enum
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted': deleted,
    };
  }

  factory AdminInfo.fromJson(Map<String, dynamic> json) {
    return AdminInfo(
      id: json['id'] as int?,
      adminId: json['admin_id'] as String,
      passwordHash: json['password_hash'] as String?,
      token: json['token'] as String?,
      adminRole: AdminRole.values.byName(json['admin_role'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deleted: json['deleted'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdminInfo &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            adminId == other.adminId &&
            passwordHash == other.passwordHash &&
            token == other.token &&
            adminRole == other.adminRole &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt &&
            deleted == other.deleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    adminId.hashCode ^
    passwordHash.hashCode ^
    token.hashCode ^
    adminRole.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    deleted.hashCode;
  }
}
