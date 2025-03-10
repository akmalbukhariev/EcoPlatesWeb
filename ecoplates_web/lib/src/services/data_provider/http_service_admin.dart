import 'dart:convert';

import 'package:ecoplates_web/src/services/data_provider/http_service_company.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_user.dart';

import '../../model/admin_login_info.dart';
import '../../model/admin_register_info.dart';
import '../../model/notification_register_info.dart';
import '../http_response/notification_data_response.dart';
import '../http_response/response_admin_info.dart';
import '../http_response/response_admin_login_info.dart';
import 'package:http/http.dart' as http;

import '../http_response/response_all_admin_info.dart';
import '../http_response/response_info.dart';
import '../http_response/response_notification_info.dart';

class HttpServiceAdmin{
  //static String SERVER_URL = "http://localhost:8088/ecoplatesadmin/api/v1/admin/"; //for the windows server
  //static String SERVER_URL = "http://localhost:8084/ecoplatesadmin/api/v1/admin/"; //for the local server
  final String SERVER_URL;
  String get LOGIN => "${SERVER_URL}admin/login";
  String get GET_ALL_ADMINS => "${SERVER_URL}admin/getAllAdmins";
  String get GET_ADMIN_BY_ID => "${SERVER_URL}admin/getAdminById/";
  String get REGISTER_ADMIN => "${SERVER_URL}admin/register";
  String get DELETE_ADMIN_BY_ID => "${SERVER_URL}admin/deleteAdminById/";

  String get REGISTER_NOTIFICATION => "${SERVER_URL}notification/register";
  String get GET_ALL_NOTIFICATIONS => "${SERVER_URL}notification/getAllNotifications";

  String? TOKEN;

  HttpServiceAdmin({
    //this.SERVER_URL = "http://176.221.28.246:8088/ecoplatesadmin/api/v1/",
    this.SERVER_URL = "http://localhost:8084/ecoplatesadmin/api/v1/",
  });

  String? getToken() => TOKEN;

  void setToken(String token) {
    TOKEN = token;
  }

  Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (TOKEN != null) 'Authorization': 'Bearer $TOKEN',
    };
  }

  Future<ResponseAdminLoginInfo?> login({required AdminLoginInfo? data}) async {

    try {

      var request = http.Request('POST', Uri.parse(LOGIN));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        //print("Response Headers: ${streamedResponse.headers}");

        if (streamedResponse.headers.containsKey('access-token')) {
          setToken(streamedResponse.headers['access-token']!);
        } else if (jsonData.containsKey('access-token')) {
          setToken(jsonData['access-token']);
        }

        return ResponseAdminLoginInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseAllAdminInfo?> getAllAdmins() async {

    try {

      var request = http.Request('GET', Uri.parse(GET_ALL_ADMINS));
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseAllAdminInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseAdminInfo?> getAdminById({required String? adminId}) async {

    try {

      var request = http.Request('GET', Uri.parse('$GET_ADMIN_BY_ID$adminId'));
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseAdminInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseInfo?> registerAdmin({required AdminRegisterInfo? data}) async {

    try {

      var request = http.Request('POST', Uri.parse(REGISTER_ADMIN));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseInfo?> deleteAdminById({required String? adminId}) async {

    try {

      var request = http.Request('DELETE', Uri.parse('$DELETE_ADMIN_BY_ID$adminId'));
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseInfo?> registerNotification({required NotificationRegisterInfo? data}) async {

    try {

      var request = http.Request('POST', Uri.parse(REGISTER_NOTIFICATION));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseNotificationInfo?> getAllNotifications() async {

    try {

      var request = http.Request('GET', Uri.parse(GET_ALL_NOTIFICATIONS));
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        //print(responseBody);
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseNotificationInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }
}