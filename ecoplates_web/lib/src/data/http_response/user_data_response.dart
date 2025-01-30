
import '../model/user_info.dart';

class UserDataResponse {
  int? total;
  String? activePercentage;
  int? activeUsers;
  int? inactiveUsers;
  String? bannedPercentage;
  String? inactivePercentage;
  List<UserInfo> users;

  UserDataResponse({
    this.total,
    this.activePercentage,
    this.activeUsers,
    this.inactiveUsers,
    this.bannedPercentage,
    this.inactivePercentage,
    required this.users,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      total: json['total'] as int?,
      activePercentage: json['active_percentage'] as String?,
      activeUsers: json['active_users'] as int?,
      inactiveUsers: json['inactive_users'] as int?,
      bannedPercentage: json['banned_percentage'] as String?,
      inactivePercentage: json['inactive_percentage'] as String?,
      users: (json['users'] as List<dynamic>)
          .map((userJson) => UserInfo.fromJson(userJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active_percentage': activePercentage,
      'active_users': activeUsers,
      'inactive_users': inactiveUsers,
      'banned_percentage': bannedPercentage,
      'inactive_percentage': inactivePercentage,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
