
class ResponseChangeUserDeletionStatus{
  String? resultMsg;
  String? resultCode;
  //UserDataResponse? resultData;

  ResponseChangeUserDeletionStatus({
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

  factory ResponseChangeUserDeletionStatus.fromJson(Map<String, dynamic> json) {
    return ResponseChangeUserDeletionStatus(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      //resultData: json['resultData'] != null ? UserDataResponse.fromJson(json['resultData']) : null,
    );
  }
}