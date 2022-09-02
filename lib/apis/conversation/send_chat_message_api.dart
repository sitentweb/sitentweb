import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/send_chat_message_model.dart';

class SendChatMessageApi {

  Future<SendChatMessageModel> sendChatMessage(senderID, receiverID, roomID, message) async {
      var client = http.Client();
      SendChatMessageModel thisResponse;
      
      try{
        
        final response = await client.post(Uri.parse(sendChatMessageApiUrl) , body: {
          "sender_id" : senderID,
          "receiver_id" : receiverID,
          "room_id" : roomID,
          "message" : message
        });

        if(response.statusCode == 200){

          thisResponse = sendChatMessageModelFromJson(response.body);

          return thisResponse;

        }else{
          print("Server Error");
          print(response.statusCode);
        }
        
      }catch(e){
        
      }finally{
        client.close();
      }
  }

}