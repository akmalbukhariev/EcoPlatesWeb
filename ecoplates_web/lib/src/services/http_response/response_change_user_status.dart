
class ResponseChangeUserStatus{
  String? resultMsg;
  String? resultCode;
  //UserDataResponse? resultData;

  ResponseChangeUserStatus({
    this.resultMsg,
    this.resultCode,
    //this.resultData,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
      //'userInfo': resultData?.toJson(),
    };
  }

  factory ResponseChangeUserStatus.fromJson(Map<String, dynamic> json) {
    return ResponseChangeUserStatus(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      //resultData: json['resultData'] != null ? UserDataResponse.fromJson(json['resultData']) : null,
    );
  }
}