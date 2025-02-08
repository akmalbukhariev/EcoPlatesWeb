
import 'company_data_response.dart';

class ResponseCompanyInfo{
  String? resultMsg;
  String? resultCode;
  CompanyDataResponse? resultData;

  ResponseCompanyInfo({
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

  factory ResponseCompanyInfo.fromJson(Map<String, dynamic> json) {
    return ResponseCompanyInfo(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      resultData: json['resultData'] != null ? CompanyDataResponse.fromJson(json['resultData']) : null,
    );
  }
}