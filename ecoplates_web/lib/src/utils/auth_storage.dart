
import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _authTokenKey = 'auth_token';
  static const String _authRoleKey = 'admin_role';

  // Save the token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Retrieve the token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Check if the user is logged in
  static Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveRole(AdminRole role) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authRoleKey, role.value);
  }

  static Future<AdminRole?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return AdminRole.fromValue(prefs.getString(_authRoleKey) as String);
  }

  // Logout (clear the token)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }
}
