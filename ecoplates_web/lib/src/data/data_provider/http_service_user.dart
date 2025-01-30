import 'dart:convert';

import 'package:ecoplates_web/src/data/model/pagination_info.dart';

import '../http_response/response_user_info.dart';
import 'package:http/http.dart' as http;

class HttpServiceUser{
  static String SERVER_URL = "http://localhost:8083/ecoplatesuser/api/v1/user/admin/";
  static String GET_PAGINATED_USER = "${SERVER_URL}getPaginatedUsers";

  static Future<ResponseUserInfo?> getUserInfo({required Paginationinfo? data}) async {

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(GET_PAGINATED_USER));
      request.body = json.encode(data?.toJson());
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        // Read the response body and decode JSON
        String responseBody = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);
        //print("Received data: ${jsonData}");

        return ResponseUserInfo.fromJson(jsonData);
      } else {
        print("Error: ${streamedResponse.statusCode} - ${streamedResponse.reasonPhrase}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    /*try {
      var response = await http.post(
        Uri.parse(GET_PAGENATED_USER),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(data?.toJson()),
      );

      if (response.statusCode == 200) {
        return ResponseUserInfo.fromJson(json.decode(response.body));
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }*/
    return null;
  }
}