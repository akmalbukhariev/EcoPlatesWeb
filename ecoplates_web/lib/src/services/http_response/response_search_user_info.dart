
import '../../model/user_info.dart';

class ResponseSearchUserInfo{
  String? resultMsg;
  String? resultCode;
  UserInfo? resultData;

  ResponseSearchUserInfo({
    this.resultMsg,
    this.resultCode,
    this.resultData,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
      'userInfo': resultData?.toJson(),
    };
  }

  factory ResponseSearchUserInfo.fromJson(Map<String, dynamic> json) {
    return ResponseSearchUserInfo(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      resultData: json['resultData'] != null ? UserInfo.fromJson(json['resultData']) : null,
    );
  }
}