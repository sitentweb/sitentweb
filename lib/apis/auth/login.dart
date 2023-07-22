import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/auth/authModel.dart';
import 'package:remark_app/model/auth/loginEmailModel.dart';
import 'package:remark_app/model/auth/loginModel.dart';
import 'package:remark_app/model/auth/rakshModel.dart';
import 'package:remark_app/model/global/global_model.dart';

class LoginApi {
  final client = http.Client();

  Future loginApi(String mobileNumber, String otp) async {
    var client = http.Client();
    LoginApiModel thisResponse = LoginApiModel(status: false);

    try {
      final response = await client.post(Uri.parse(loginApiUrl),
          body: {'user_mobile': mobileNumber, 'user_otp': otp});

      if (response.statusCode == 200) {
        thisResponse = loginApiModelFromJson(response.body);
      } else {
        thisResponse.message = "Invalid Response : ${response.statusCode}";
      }

      return thisResponse;
    } on SocketException catch (e) {
    } on FormatException catch (e) {
    } catch (e) {
      print(e);
      thisResponse.message = "Something went wrong";
      return thisResponse;
    } finally {
      client.close();
    }
  }

  Future<LoginEmail> loginWithEmail(email, requestFrom) async {
    var client = http.Client();
    LoginEmail thisResponse =
        LoginEmail(status: false, message: 'Invalid Request', data: null);

    try {
      final response = await client.post(Uri.parse(loginEmailApiUrl),
          body: {"email": email, "requestFrom": requestFrom});

      if (response.statusCode == 200) {
        thisResponse = loginEmailFromJson(response.body);
      } else {
        thisResponse.message = 'Invalid Response: ${response.statusCode}';
      }

      return thisResponse;
    } catch (e) {
      thisResponse.message = 'Something went wrong';

      return thisResponse;
    }
  }

  Future<GlobalModel> login(dynamic loginData) async {
    GlobalModel thisResponse = GlobalModel(status: false);

    try {
      final response = await client.post(Uri.parse(apiUrl['login']), body: {
        "mobile_number": loginData['mobile_number'],
        "email_address": loginData['email_address'],
        "login_type": loginData['login_type'] ?? 'mobile'
      });

      if (response.statusCode == 200) {
        print(response.body);
        thisResponse = GlobalModel(
            status: jsonDecode(response.body)['status'],
            message: jsonDecode(response.body)['message'],
            data: rakshModelFromJson(
                jsonEncode(jsonDecode(response.body)['data'])));

        return thisResponse;
      } else if (response.statusCode == 201) {
        thisResponse = globalModelFromJson(response.body);
        return thisResponse;
      } else {
        thisResponse.message = 'Something went wrong';
        Get.snackbar("Failed", "${response.statusCode} : Error");
        return thisResponse;
      }
    } on SocketException catch (e) {
      thisResponse.message = e.message;
      return thisResponse;
    } on FormatException catch (e) {
      thisResponse.message = e.message;
      return thisResponse;
    } catch (e) {
      thisResponse.message = e.toString();
      return thisResponse;
    }
  }

  Future<AuthModel> verifyOTP(String otp, String token) async {
    AuthModel thisResponse = AuthModel(status: false);

    try {
      final response = await client.post(Uri.parse(apiUrl['verify-otp']),
          body: {"otp": otp}, headers: {"Authorization": token});

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        thisResponse = authModelFromJson(response.body);
        return thisResponse;
      } else if (response.statusCode == 201) {
        var res = jsonDecode(response.body);

        thisResponse.message = res['message'];
        thisResponse.data = res['data'];
        return thisResponse;
      } else {
        thisResponse.message = "Error Response";
        return thisResponse;
      }
    } on SocketException catch (e) {
      thisResponse.message = e.message;
      return thisResponse;
    } catch (e) {
      thisResponse.message = 'Something went wrong';
      return thisResponse;
    }
  }
}
