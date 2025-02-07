
import '../model/admin_info.dart';

class ResponseAdminInfo{
  String? resultMsg;
  String? resultCode;
  AdminInfo? resultData;

  ResponseAdminInfo({
    this.resultMsg,
    this.resultCode,
    this.resultData,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
      'resultData': resultData?.toJson(),
    };
  }

  factory ResponseAdminInfo.fromJson(Map<String, dynamic> json) {
    return ResponseAdminInfo(
      resultMsg: json['resultMsg'] as String?,
      resultCode: json['resultCode'] as String?,
      resultData: json['resultData'] != null ? AdminInfo.fromJson(json['resultData']) : null,
    );
  }
}