
import '../model/user_info.dart';

class UserDataResponse {
  int? total;

  int? activeUsers;
  int? inactiveUsers;
  int? bannedUsers;
  String? activePercentage;
  String? inactivePercentage;
  String? bannedPercentage;

  List<UserInfo> users;

  UserDataResponse({
    this.total,

    this.activeUsers,
    this.inactiveUsers,
    this.bannedUsers,
    this.activePercentage,
    this.inactivePercentage,
    this.bannedPercentage,

    required this.users,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      total: json['total'] as int?,

      activeUsers: json['active_users'] as int?,
      inactiveUsers: json['inactive_users'] as int?,
      bannedUsers: json['banned_users'] as int?,
      activePercentage: json['active_percentage'] as String?,
      inactivePercentage: json['inactive_percentage'] as String?,
      bannedPercentage: json['banned_percentage'] as String?,

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
