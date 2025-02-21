import '../../model/notification_info.dart';

class ResponseNotificationInfo{
  String? resultMsg;
  String? resultCode;
  List<NotificationInfo>? resultData;

  ResponseNotificationInfo({
    this.resultMsg,
    this.resultCode,
    this.resultData,
  });

  Map<String, dynamic> toJson() {
    return {
      'resultMsg': resultMsg,
      'resultCode': resultCode,
      'resultData': resultData?.map((e) => e.toJson()).toList(),
    };
  }

  factory ResponseNotificationInfo.fromJson(Map<String, dynamic> json) {
    return ResponseNotificationInfo(
      resultMsg: json['resultMsg'],
      resultCode: json['resultCode'],
      resultData: json['resultData'] != null
          ? (json['resultData'] as List)
          .map((e) => NotificationInfo.fromJson(e))
          .toList()
          : null,
    );
  }
}