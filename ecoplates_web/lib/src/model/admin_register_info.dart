
class AdminRegisterInfo {
  String? admin_id;
  String? password;
  String? admin_role;

  AdminRegisterInfo({
    required this.admin_id,
    required this.password,
    required this.admin_role,
  });

  factory AdminRegisterInfo.fromJson(Map<String, dynamic> json) {
    return AdminRegisterInfo(
      admin_id: json['admin_id'] as String,
      password: json['password'] as String,
      admin_role: json['admin_role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_id': admin_id,
      'password': password,
      'admin_role': admin_role,
    };
  }
}
