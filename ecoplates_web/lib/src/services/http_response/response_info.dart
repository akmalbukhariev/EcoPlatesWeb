
class ResponseInfo{
  String? resultMsg;
  String? resultCode;

  ResponseInfo({
    this.resultMsg,
    this.resultCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
    };
  }

  factory ResponseInfo.fromJson(Map<String, dynamic> json) {
    return ResponseInfo(
      resultMsg: json['resultMsg'] as String?,
      resultCode: json['resultCode'] as String?,
    );
  }
}