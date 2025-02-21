
import '../../model/notification_info.dart';

class NotificationDataResponse {
  int? total;
  List<NotificationInfo> data;

  NotificationDataResponse({
    this.total,
    required this.data,
  });

  factory NotificationDataResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDataResponse(
      total: json['total'] as int?,
      data: (json['data'] as List<dynamic>)
          .map((userJson) =>
          NotificationInfo.fromJson(userJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'notificationData': data.map((item) => item.toJson()).toList(),
    };
  }
}