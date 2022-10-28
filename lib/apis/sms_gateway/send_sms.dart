import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';

class SendSMS {
  sendNewSms(String mobileNumber, String otp, String signature) async {
    var client = http.Client();
    String sign = "<#>";

    try {
      // final response = await client.post(Uri.parse(smsBaseUrl) , body: {
      //     'key' : smsApi,
      //     'entity' : smsEntity,
      //     'tempid' : smsOTPTempID,
      //     'routeid' : routeid,
      //     'senderid' : smsSender,
      //     'type' : smsType,
      //     'unicode' : smsUnicode,
      //     'msg' : "Dear user, $otp is the OTP for your Remark Account. Please enter this OTP to verify your mobile number. Regards, Remark Team Visko E-Service PVT LTD",
      //     'contacts' : mobileNumber
      // });

      final response = await client.post(Uri.parse(smsBaseUrl), body: {
        'apikey': smsApi,
        'sendername': smsSender,
        'username': smsUsername,
        'smstype': smsType,
        'message':
            "$sign Dear user, $otp is the OTP for your Remark Account. Please enter this OTP to verify your mobile number. Do not share this otp with anyone Regards, Remark Team Visko E-Service PVT LTD NuIRK+TRxtq",
        'numbers': mobileNumber
      });

      if (response.statusCode == 200) {
        print('Sms Api is working');
        print(jsonDecode(response.body));
      } else {
        print('Sms return the status code with given below');
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }
}
