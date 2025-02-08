
import 'dart:convert';

import 'package:ecoplates_web/src/services/data_provider/http_service_company.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_user.dart';

import '../../model/admin_login_info.dart';
import '../../model/admin_register_info.dart';
import '../http_response/response_admin_info.dart';
import '../http_response/response_admin_login_info.dart';
import 'package:http/http.dart' as http;

import '../http_response/response_all_admin_info.dart';
import '../http_response/response_info.dart';

class HttpServiceAdmin{
  static String SERVER_URL = "http://localhost:8084/ecoplatesadmin/api/v1/admin/";
  static String LOGIN = "${SERVER_URL}login";
  static String GET_ALL_ADMINS = "${SERVER_URL}getAllAdmins";
  static String GET_ADMIN_BY_ID = "${SERVER_URL}getAdminById/";
  static String REGISTER_ADMIN = "${SERVER_URL}register";
  static String DELETE_ADMIN_BY_ID = "${SERVER_URL}deleteAdminById/";

  static String? TOKEN;
  //static String TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOIiwiZXhwIjoxNzcwMjU2NjM0fQ.YP5nae5N1BNx5AZGjkhXoEe1QKKnXRpk8M4K1_WT1_k";

  static void setToken(String token) {
    TOKEN = token;
    HttpServiceUser.setToken(token);
    HttpServiceCompany.setToken(token);
  }

  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (TOKEN != null) 'Authorization': 'Bearer $TOKEN',
    };
  }

  static Future<ResponseAdminLoginInfo?> login({required AdminLoginInfo? data}) async {

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(LOGIN));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(headers);

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

  static Future<ResponseAllAdminInfo?> getAllAdmins() async {

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

  static Future<ResponseAdminInfo?> getAdminById({required String? adminId}) async {

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

  static Future<ResponseInfo?> register({required AdminRegisterInfo? data}) async {

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

  static Future<ResponseInfo?> deleteAdminById({required String? adminId}) async {

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
}