
class NotificationRegisterInfo {
  String? message;
  String? status;
  String? sends;

  NotificationRegisterInfo({
    required this.message,
    required this.status,
    required this.sends,
  });

  factory NotificationRegisterInfo.fromJson(Map<String, dynamic> json) {
    return NotificationRegisterInfo(
      message: json['message'] as String,
      status: json['status'] as String,
      sends: json['sends'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'sends': sends,
    };
  }
}