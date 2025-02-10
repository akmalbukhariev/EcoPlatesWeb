
import '../constant/user_or_company_status.dart';

class UserInfo {
  int? userId;
  String phoneNumber;
  String? email;
  String? firstName;
  String? lastName;
  String? fullName;
  double? locationLatitude;
  double? locationLongitude;
  String? profilePictureUrl;
  String? passwordHash;
  String? tokenMb;
  UserOrCompanyStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool deleted;

  UserInfo({
    this.userId,
    required this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.locationLatitude,
    this.locationLongitude,
    this.profilePictureUrl,
    this.passwordHash,
    this.tokenMb,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
  });

  bool isBanned(){
    return status == UserOrCompanyStatus.BANNED;
  }

  void setBanned(bool yes){
    status = yes? UserOrCompanyStatus.BANNED : UserOrCompanyStatus.INACTIVE;
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A'; // Handle null case
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone_number': phoneNumber,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'profile_picture_url': profilePictureUrl,
      'password_hash': passwordHash,
      'token_mb': tokenMb,
      'status': status.name, // Assuming UserOrCompanyStatus is an enum
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted': deleted,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['user_id'] as int?,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String?,
      locationLatitude: (json['location_latitude'] as num?)?.toDouble(),
      locationLongitude: (json['location_longitude'] as num?)?.toDouble(),
      profilePictureUrl: json['profile_picture_url'] as String?,
      passwordHash: json['password_hash'] as String?,
      tokenMb: json['token_mb'] as String?,
      status: UserOrCompanyStatus.values.byName(json['status'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deleted: json['deleted'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserInfo &&
            runtimeType == other.runtimeType &&
            userId == other.userId &&
            phoneNumber == other.phoneNumber &&
            email == other.email &&
            firstName == other.firstName &&
            lastName == other.lastName &&
            fullName == other.fullName &&
            locationLatitude == other.locationLatitude &&
            locationLongitude == other.locationLongitude &&
            profilePictureUrl == other.profilePictureUrl &&
            passwordHash == other.passwordHash &&
            tokenMb == other.tokenMb &&
            status == other.status &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt &&
            deleted == other.deleted;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
    phoneNumber.hashCode ^
    email.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    fullName.hashCode ^
    locationLatitude.hashCode ^
    locationLongitude.hashCode ^
    profilePictureUrl.hashCode ^
    passwordHash.hashCode ^
    tokenMb.hashCode ^
    status.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    deleted.hashCode;
  }
}