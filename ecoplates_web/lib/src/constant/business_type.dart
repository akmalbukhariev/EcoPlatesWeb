
enum BusinessType {
  NONE("NONE"),
  RESTAURANT("RESTAURANT"),
  BAKERY("BAKERY"),
  CAFE("CAFE"),
  FAST_FOOD("FAST_FOOD"),
  SUPERMARKET("SUPERMARKET"),
  OTHER("OTHER");

  final String value;

  const BusinessType(this.value);

  String getValue() {
    return value;
  }

  static BusinessType fromValue(String value) {
    for (BusinessType status in BusinessType.values) {
      if (status.value.toLowerCase() == value.toLowerCase()) {
        return status;
      }
    }
    throw ArgumentError("Unknown BusinessType value: $value");
  }
}