import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';

class InquiryApi {
  final client = http.Client();

  Future sendInquiry(
      String name, String mobile, String message, String userId) async {
    var thisResponse = <String, dynamic>{
      "status": false,
      "message": "Invalid Request",
      "data": null
    };

    try {
      final response = await client.post(Uri.parse(sendInquiryApiUrl), body: {
        "name": name,
        "mobile": mobile,
        "message": message,
        "user_id": userId
      });

      if (response.statusCode == 200) {
        thisResponse = jsonDecode(response.body);
      } else {
        thisResponse['message'] = 'Invalid Response: ${response.statusCode}';
      }

      return thisResponse;
    } catch (e) {
      thisResponse['message'] = e.toString();
      return thisResponse;
    }
  }
}
