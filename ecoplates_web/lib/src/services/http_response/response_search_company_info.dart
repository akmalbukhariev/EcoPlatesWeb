
import '../../model/company_info.dart';

class ResponseSearchCompanyInfo{
  String? resultMsg;
  String? resultCode;
  CompanyInfo? resultData;

  ResponseSearchCompanyInfo({
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

  factory ResponseSearchCompanyInfo.fromJson(Map<String, dynamic> json) {
    return ResponseSearchCompanyInfo(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      resultData: json['resultData'] != null ? CompanyInfo.fromJson(json['resultData']) : null,
    );
  }
}