import 'dart:convert';

import '../../model/change_user_deletion_status.dart';
import '../../model/change_user_status.dart';
import '../../model/pagination_info.dart';
import '../http_response/response_change_deletion_status.dart';
import '../http_response/response_change_user_status.dart';
import '../http_response/response_search_user_info.dart';
import '../http_response/response_user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class HttpServiceUser{
  //static String SERVER_URL = "http://localhost:8088/ecoplatesadmin/api/v1/user/"; //for the windows server
  //static String SERVER_URL = "http://localhost:8084/ecoplatesadmin/api/v1/user/"; //for the local server
  final String SERVER_URL;
  String get GET_PAGINATED_USER => "${SERVER_URL}getPaginatedUsers";
  String get SEARCH_USER => "${SERVER_URL}getUserByPhone/";
  String get CHANGE_USER_STATUS => "${SERVER_URL}changeUserStatus";
  String get CHANGE_USER_DELETION_STATUS => "${SERVER_URL}changeUserDeletionStatus";

  String? TOKEN;

  HttpServiceUser({
    this.SERVER_URL = "http://176.221.28.246:8088/ecoplatesadmin/api/v1/user/",
  });

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

  Future<ResponseUserInfo?> getUserInfo({required Paginationinfo? data}) async {

    try {
      var request = http.Request('POST', Uri.parse(GET_PAGINATED_USER));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseUserInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseSearchUserInfo?> searchUserInfo({required String? phoneNumber}) async {

    try {
      var request = http.Request('GET', Uri.parse("$SEARCH_USER$phoneNumber"));
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseSearchUserInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseChangeUserStatus?> changeUserStatus({required ChangeUserStatus? data}) async {

    try {

      var request = http.Request('PUT', Uri.parse(CHANGE_USER_STATUS));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseChangeUserStatus.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }

  Future<ResponseChangeUserDeletionStatus?> changeUserDeletionStatus({required ChangeUserDeletionStatus? data}) async {

    try {

      var request = http.Request('PUT', Uri.parse(CHANGE_USER_DELETION_STATUS));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(getHeaders());

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);

        return ResponseChangeUserDeletionStatus.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }
}