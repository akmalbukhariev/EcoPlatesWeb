class ResponseAdminLoginInfo{
  String? resultMsg;
  String? resultCode;

  ResponseAdminLoginInfo({
    this.resultMsg,
    this.resultCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
    };
  }

  factory ResponseAdminLoginInfo.fromJson(Map<String, dynamic> json) {
    return ResponseAdminLoginInfo(
      resultMsg: json['resultMsg'] as String?,
      resultCode: json['resultCode'] as String?,
    );
  }
}