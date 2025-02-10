

import '../constant/business_type.dart';
import '../constant/user_or_company_status.dart';

class CompanyInfo {
  int? companyId;
  String companyName;
  String phoneNumber;
  String? email;
  String? logoUrl;
  BusinessType businessType;
  int? rating;
  double? locationLatitude;
  double? locationLongitude;
  double? distanceKm;
  String? workingHours;
  String? telegramLink;
  String? socialProfileLink;
  String? passwordHash;
  String? tokenMb;
  UserOrCompanyStatus status;
  String? about;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool deleted;

  CompanyInfo({
    this.companyId,
    required this.companyName,
    required this.phoneNumber,
    this.email,
    this.logoUrl,
    required this.businessType,
    this.rating,
    this.locationLatitude,
    this.locationLongitude,
    this.distanceKm,
    this.workingHours,
    this.telegramLink,
    this.socialProfileLink,
    this.passwordHash,
    this.tokenMb,
    required this.status,
    this.about,
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
  });

  bool isBanned() {
    return status == UserOrCompanyStatus.BANNED;
  }

  void setBanned(bool yes) {
    status = yes ? UserOrCompanyStatus.BANNED : UserOrCompanyStatus.INACTIVE;
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A'; // Handle null case
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'company_name': companyName,
      'phone_number': phoneNumber,
      'email': email,
      'logo_url': logoUrl,
      'business_type': businessType.name,
      'rating': rating,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'distance_km': distanceKm,
      'working_hours': workingHours,
      'telegram_link': telegramLink,
      'social_profile_link': socialProfileLink,
      'password_hash': passwordHash,
      'token_mb': tokenMb,
      'status': status.name,
      'about': about,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted': deleted,
    };
  }

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      companyId: json['company_id'] as int?,
      companyName: json['company_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      logoUrl: json['logo_url'] as String?,
      businessType: BusinessType.values.byName(json['business_type'] as String),
      rating: json['rating'] as int?,
      locationLatitude: (json['location_latitude'] as num?)?.toDouble(),
      locationLongitude: (json['location_longitude'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      workingHours: json['working_hours'] as String?,
      telegramLink: json['telegram_link'] as String?,
      socialProfileLink: json['social_profile_link'] as String?,
      passwordHash: json['password_hash'] as String?,
      tokenMb: json['token_mb'] as String?,
      status: UserOrCompanyStatus.values.byName(json['status'] as String),
      about: json['about'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deleted: json['deleted'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CompanyInfo &&
            runtimeType == other.runtimeType &&
            companyId == other.companyId &&
            companyName == other.companyName &&
            phoneNumber == other.phoneNumber &&
            email == other.email &&
            logoUrl == other.logoUrl &&
            businessType == other.businessType &&
            rating == other.rating &&
            locationLatitude == other.locationLatitude &&
            locationLongitude == other.locationLongitude &&
            distanceKm == other.distanceKm &&
            workingHours == other.workingHours &&
            telegramLink == other.telegramLink &&
            socialProfileLink == other.socialProfileLink &&
            passwordHash == other.passwordHash &&
            tokenMb == other.tokenMb &&
            status == other.status &&
            about == other.about &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt &&
            deleted == other.deleted;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
    companyName.hashCode ^
    phoneNumber.hashCode ^
    email.hashCode ^
    logoUrl.hashCode ^
    businessType.hashCode ^
    rating.hashCode ^
    locationLatitude.hashCode ^
    locationLongitude.hashCode ^
    distanceKm.hashCode ^
    workingHours.hashCode ^
    telegramLink.hashCode ^
    socialProfileLink.hashCode ^
    passwordHash.hashCode ^
    tokenMb.hashCode ^
    status.hashCode ^
    about.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    deleted.hashCode;
  }
}
