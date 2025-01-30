import 'package:ecoplates_web/src/data/http_response/user_data_response.dart';

import '../model/user_info.dart';

class ResponseUserInfo{
  String? resultMsg;
  String? resultCode;
  UserDataResponse? resultData;

  ResponseUserInfo({
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

  factory ResponseUserInfo.fromJson(Map<String, dynamic> json) {
    return ResponseUserInfo(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      resultData: json['resultData'] != null ? UserDataResponse.fromJson(json['resultData']) : null,
    );
  }
}

