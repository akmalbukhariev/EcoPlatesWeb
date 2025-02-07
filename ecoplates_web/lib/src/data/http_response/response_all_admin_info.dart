
import 'package:ecoplates_web/src/data/model/admin_info.dart';

class ResponseAllAdminInfo{
  String? resultMsg;
  String? resultCode;
  List<AdminInfo>? resultData;

  ResponseAllAdminInfo({
    this.resultMsg,
    this.resultCode,
    this.resultData,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
      'resultData': resultData?.map((admin) => admin.toJson()).toList(),
    };
  }

  factory ResponseAllAdminInfo.fromJson(Map<String, dynamic> json) {
    return ResponseAllAdminInfo(
      resultMsg: json['resultMsg'] as String?,
      resultCode: json['resultCode'] as String?,
      resultData: json['resultData'] != null
          ? (json['resultData'] as List<dynamic>)
          .map((item) => AdminInfo.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}