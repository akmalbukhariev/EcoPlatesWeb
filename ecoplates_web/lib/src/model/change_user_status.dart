
import '../constant/user_or_company_status.dart';

class ChangeUserStatus{
  String phoneNumber;
  UserOrCompanyStatus status;

  ChangeUserStatus({
    required this.phoneNumber,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return{
      'phone_number': phoneNumber,
      'status': status.name
    };
  }

  factory ChangeUserStatus.fromJson(Map<String, dynamic> json){
    return ChangeUserStatus(
      phoneNumber: json['phone_number'] as String,
      status: UserOrCompanyStatus.values.byName(json['status'] as String),
    );
  }
}