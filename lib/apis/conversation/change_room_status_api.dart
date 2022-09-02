import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/change_room_status.dart';

class ChangeRoomStatusApi {

  Future<ChangeRoomStatusModel> changeRoomStatus(receiverID, roomID, roomStatus , receiverToken) async {
    var client = http.Client();
    ChangeRoomStatusModel thisResponse;
    try{

      final response = await client.get(Uri.parse(changeRoomStatusApiUrl + "?receiver_id="+receiverID+"&room_id="+roomID+"&room_status="+roomStatus));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){
            thisResponse = changeRoomStatusModelFromJson(response.body);

        }else{
          thisResponse = ChangeRoomStatusModel(status: false);
        }

        return thisResponse;

      }else{
        print("Wrong Status Code on Change Room Status - ${response.statusCode}");
      }

    }catch(e){
      print("Exception While change room status");
      print(e);
    }finally{
      client.close();
    }

  }

}