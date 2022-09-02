import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/auth/loginModel.dart';

class LoginApi {
  
  Future loginApi(String mobileNumber , String otp) async {
      var client = http.Client();
      LoginApiModel thisResponse;

      try{
        final response = await client.post(Uri.parse(loginApiUrl) , body: {
          'user_mobile' : mobileNumber,
          'user_otp' : otp
        });

        if(response.statusCode == 200){

          thisResponse = loginApiModelFromJson(response.body);

          if(thisResponse.status){
            return thisResponse;
          }else{
            var ErrorMessage = "Login Failed Due to Some reasons";
            return ErrorMessage;
          }

        }else{
          print('wrong status code');
        }


        return thisResponse;

      }catch(e){
        print(e);
      }finally{
        client.close();
      }



  }
  
}