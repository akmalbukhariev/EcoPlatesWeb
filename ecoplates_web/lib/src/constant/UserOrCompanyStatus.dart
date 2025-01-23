enum UserOrCompanyStatus {
  ACTIVE("ACTIVE"),
  INACTIVE("INACTIVE"),
  BANNED("BANNED");
  //DELETED("DELETED");

  final String value;

  const UserOrCompanyStatus(this.value);

  String getValue() {
    return value;
  }

  static UserOrCompanyStatus fromValue(String value) {
    for (UserOrCompanyStatus status in UserOrCompanyStatus.values) {
      if (status.value.toLowerCase() == value.toLowerCase()) {
        return status;
      }
    }
    throw ArgumentError("Unknown UserOrCompanyStatus value: $value");
  }
}