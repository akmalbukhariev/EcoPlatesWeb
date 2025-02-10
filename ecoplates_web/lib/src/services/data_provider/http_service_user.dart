import 'dart:convert';

import '../../model/change_user_deletion_status.dart';
import '../../model/change_user_status.dart';
import '../../model/pagination_info.dart';
import '../http_response/response_change_deletion_status.dart';
import '../http_response/response_change_user_status.dart';
import '../http_response/response_user_info.dart';
import 'package:http/http.dart' as http;

class HttpServiceUser{
  //static String SERVER_URL = "http://localhost:8084/ecoplatesadmin/api/v1/user/";
  static String SERVER_URL = "http://176.221.28.246:8088/ecoplatesadmin/api/v1/user/";
  static String GET_PAGINATED_USER = "${SERVER_URL}getPaginatedUsers";
  static String CHANGE_USER_STATUS = "${SERVER_URL}changeUserStatus";
  static String CHANGE_USER_DELETION_STATUS = "${SERVER_URL}changeUserDeletionStatus";

  static String? TOKEN;
  //static String TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOIiwiZXhwIjoxNzcwMjU2NjM0fQ.YP5nae5N1BNx5AZGjkhXoEe1QKKnXRpk8M4K1_WT1_k";

  static void setToken(String token) {
    TOKEN = token;
  }

  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (TOKEN != null) 'Authorization': 'Bearer $TOKEN',
    };
  }

  static Future<ResponseUserInfo?> getUserInfo({required Paginationinfo? data}) async {

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

  static Future<ResponseChangeUserStatus?> changeUserStatus({required ChangeUserStatus? data}) async {

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

  static Future<ResponseChangeUserDeletionStatus?> changeUserDeletionStatus({required ChangeUserDeletionStatus? data}) async {

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