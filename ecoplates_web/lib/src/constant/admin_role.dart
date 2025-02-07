
enum AdminRole {
  ADMIN("ADMIN"),
  SUPER_ADMIN("SUPER_ADMIN");

  final String value;

  const AdminRole(this.value);

  String getValue() {
    return value;
  }

  static AdminRole fromValue(String value) {
    for (AdminRole status in AdminRole.values) {
      if (status.value.toLowerCase() == value.toLowerCase()) {
        return status;
      }
    }
    throw ArgumentError("Unknown AdminRole value: $value");
  }
}