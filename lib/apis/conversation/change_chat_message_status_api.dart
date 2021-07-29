import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/change_chat_message_model.dart';

class ChangeChatMessageStatusApi {

  Future<ChangeChatMessageStatusModel> changeChatMessage(receiverID, messageStatus , messageID) async {
    var client = http.Client();

    ChangeChatMessageStatusModel thisResponse;

    try{

      final response = await client.post(Uri.parse(changeChatMessageStatusApiUrl) , body: {
          "receiver_id" : receiverID,
          "message_status" : messageStatus,
          "message_id" : messageID
      });

      if(response.statusCode == 200){

        thisResponse = changeChatMessageStatusModelFromJson(response.body);

        return thisResponse;

      }else{
        print("Server Error in ChangeChatMessageStatus");
        print(response.statusCode);
      }

    }catch(e){
      print("Exception Error in Change Chat Message Status");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

}