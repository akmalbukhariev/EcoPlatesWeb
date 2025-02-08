
class AdminLoginInfo {
  String? admin_id;
  String? password;

  AdminLoginInfo({
    required this.admin_id,
    required this.password,
  });

  factory AdminLoginInfo.fromJson(Map<String, dynamic> json) {
    return AdminLoginInfo(
      admin_id: json['admin_id'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_id': admin_id,
      'password': password,
    };
  }
}