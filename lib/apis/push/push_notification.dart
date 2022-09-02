import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';

class SendPushNotification {

  final client = http.Client();

  send(data , userToken) async {

    try{

      final response = await client.post(Uri.parse(sendPush) , body: {
        "data" : data,
        "to" : userToken
      });

      if(response.statusCode == 200) {

        return jsonDecode(response.body);

      }else{
        print("Wrong Status Code when send push notification");
      }

    }catch(e){
        print('exception in send push notification');
    }finally{
      client.close();
    }

  }

}