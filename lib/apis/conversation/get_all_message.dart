import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/get_all_messages_model.dart';

class GetAllMessages {
  
  Future<GetAllMessageModel> getAllMessages(senderID, receiverID) async {
      
    var client = http.Client();
    GetAllMessageModel thisResponse;
    
    try{
      
      final response  = await client.get(Uri.parse(getMessages+"?sender_id="+senderID+"&receiver_id="+receiverID));

      if(response.statusCode == 200){

        final decodedData = jsonDecode(response.body);

        print(decodedData['status']);
        if(decodedData['status']){
            thisResponse = getAllMessageModelFromJson(response.body);

        }else{
          thisResponse = GetAllMessageModel(status: false , data: []);
        }

        return thisResponse;


      }else{
        print("Wrong Status Code ${response.statusCode} ");
      }
      
    }catch(e){
      print("Exception Error! on getting messages");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
    
  }
  
}