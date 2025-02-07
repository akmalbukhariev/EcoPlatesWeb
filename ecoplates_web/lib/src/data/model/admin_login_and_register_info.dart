
class AdminLoginAndRegisterInfo {
  String? admin_id;
  String? password;

  AdminLoginAndRegisterInfo({
    required this.admin_id,
    required this.password,
  });

  factory AdminLoginAndRegisterInfo.fromJson(Map<String, dynamic> json) {
    return AdminLoginAndRegisterInfo(
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
