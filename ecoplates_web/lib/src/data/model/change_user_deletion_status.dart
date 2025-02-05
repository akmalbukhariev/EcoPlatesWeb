
class ChangeUserDeletionStatus{
  bool deleted; //1 = yes,0 = no
  String phoneNumber;

  ChangeUserDeletionStatus({
    required this.deleted,
    required this.phoneNumber
  });

  Map<String, dynamic> toJson() {
    return{
      'deleted': deleted,
      'phone_number': phoneNumber,
    };
  }

  factory ChangeUserDeletionStatus.fromJson(Map<String, dynamic> json){
    return ChangeUserDeletionStatus(
      deleted: json['deleted'] as bool,
      phoneNumber: json['phone_number'] as String,
    );
  }
}