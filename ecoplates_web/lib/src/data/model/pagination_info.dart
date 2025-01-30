class Paginationinfo {
  int pageSize;
  int offset;

  Paginationinfo({
    required this.pageSize,
    required this.offset,
  });

  factory Paginationinfo.fromJson(Map<String, dynamic> json) {
    return Paginationinfo(
      pageSize: json['pageSize'] as int,
      offset: json['offset'] as int,
    );
  }

  // Method to convert an object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'offset': offset,
    };
  }
}
