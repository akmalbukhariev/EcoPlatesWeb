
class NotificationInfo {
  final int? id;
  final String? message;
  final String status;
  final DateTime? deliveryDate;
  final int sends;

  NotificationInfo({
    this.id,
    this.message,
    this.status = 'Completed',
    this.deliveryDate,
    this.sends = 0,
  });

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'status': status,
      'delivery_date': deliveryDate?.toIso8601String(),
      'sends': sends,
    };
  }

  factory NotificationInfo.fromJson(Map<String, dynamic> json) {
    return NotificationInfo(
      id: json['id'] as int?,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'Completed',
      deliveryDate: json['delivery_date'] != null ? DateTime.parse(json['delivery_date'] as String) : null,
      sends: json['sends'] as int? ?? 0,
    );
  }

  NotificationInfo copyWith({
    int? id,
    String? message,
    String? status,
    DateTime? deliveryDate,
    int? sends,
  }) {
    return NotificationInfo(
      id: id ?? this.id,
      message: message ?? this.message,
      status: status ?? this.status,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      sends: sends ?? this.sends,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationInfo &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            message == other.message &&
            status == other.status &&
            deliveryDate == other.deliveryDate &&
            sends == other.sends;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    message.hashCode ^
    status.hashCode ^
    deliveryDate.hashCode ^
    sends.hashCode;
  }
}
