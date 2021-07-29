import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';

class SendSMS {

  sendNewSms() async {

    var client = http.Client();

    try{

      final response = await client.post(Uri.parse(smsBaseUrl) , body: {
          'sender' : smsSender,
          'smstype' : smsType,
          'unicode' : smsUnicode,
          'message' : "Test OTP 1234",
          'number' : '9691407455'
      } , headers: {
        'apikey' : smsApi
      });

      if(response.statusCode == 200) {
        print('Sms Api is working');
        print(jsonDecode(response.body));
      }else{
        print('Sms return the status code with given below');
        print(response.statusCode);
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

  }

}