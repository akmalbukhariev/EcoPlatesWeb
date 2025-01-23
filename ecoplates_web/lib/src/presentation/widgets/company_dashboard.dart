
import 'package:flutter/cupertino.dart';

class CompanyInfo {
  final int? company_id;
  final String? company_name;
  final String? phone_number;
  final String? logo_url;
  final String? rating;
  final double? location_latitude;
  final double? location_longitude;
  final String? working_hours;
  final String? telegram_link;
  final String? social_profile_link;
  String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? deleted;

  CompanyInfo({
    this.company_id,
    this.company_name,
    this.phone_number,
    this.logo_url,
    this.rating,
    this.location_latitude = 0.0,
    this.location_longitude = 0.0,
    this.working_hours,
    this.telegram_link,
    required this.social_profile_link,
    this.status = 'INACTIVE',
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
  });

  bool isBanned(){
    return status == "BANNED";
  }

  void setBanned(bool yes){
    status = yes? "BANNED" : "INACTIVE";
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A'; // Handle null case
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

class CompanyDashBoard extends StatefulWidget{
  const CompanyDashBoard({super.key});

  @override
  State<CompanyDashBoard> createState()  => _CompanyDashBoard();
}

class _CompanyDashBoard extends State<CompanyDashBoard>{
  @override
  Widget build(BuildContext context) {
      return Container();
  }
}