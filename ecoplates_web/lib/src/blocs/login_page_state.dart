import 'package:ecoplates_web/src/constant/admin_role.dart';

class LoginPageState {
  bool isLoading;
  bool showLoginWindow;
  AdminRole adminRole;
  String? adminId;
  String? password;
  String? token;

  LoginPageState({
    this.isLoading = false,
    this.showLoginWindow = false,
    this.adminRole = AdminRole.SUPER_ADMIN,
    this.adminId,
    this.password,
    this.token
  });

  LoginPageState compyWith({
    bool? isLoading,
    bool? showLoginWindow,
    AdminRole? adminRole,
    String? adminId,
    String? password,
    String? token
  }) {
    return LoginPageState(
        isLoading: isLoading ?? this.isLoading,
        showLoginWindow: showLoginWindow ?? this.showLoginWindow,
        adminRole: adminRole ?? this.adminRole,
        adminId: adminId ?? this.adminId,
        password: password ?? this.password,
        token: token ?? this.token
    );
  }
}