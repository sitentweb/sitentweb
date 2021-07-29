import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/conversation/create_chat_room_model.dart';
import 'package:remark_app/model/conversation/get_all_room_model.dart';
import 'package:remark_app/model/conversation/get_single_room_model.dart';

class GetRoom {

    Future<GetAllChatRoomModel> getChatRoom(userId) async {
      var client = http.Client();

      GetAllChatRoomModel thisResponse;

      try {

        final response = await client.get(Uri.parse(getAllRooms+"?user_id="+userId));

        if(response.statusCode == 200){

          thisResponse = getAllChatRoomModelFromJson(response.body);

          return thisResponse;

        }else{
          print("Response is wrong ${response.statusCode}");
        }

      }catch(e){
        print("Exception Error!");
        print(e);
      }finally{
        client.close();
      }

      return thisResponse;

    }

    Future<GetSingleChatRoomModel> getSingleChatRoom(String roomID) async {
        var client = http.Client();

        GetSingleChatRoomModel thisResponse;

        try{

          final response = await client.get(Uri.parse(getSingleChatRoomApiUrl+"?room_id="+roomID));

          if(response.statusCode == 200){

            thisResponse = getSingleChatRoomModelFromJson(response.body);

            return thisResponse;

          }else{
            print("Wrong Status ${response.statusCode} , ${getSingleChatRoomApiUrl}");
          }

        }catch(e){
            print("Exception in get single room");
            print(e);
        }finally{
          client.close();
        }

        return thisResponse;

    }

    Future<CreateChatRoomModel> createChatRoom(employerID, employeeID) async {
      CreateChatRoomModel thisResponse = CreateChatRoomModel();

      try{

        final response = await Dio().postUri(Uri.parse(createChatRoomApiUrl) , data: {
          "room_employer" : employerID.toString(),
          "room_employee" : employeeID.toString()
        });


        if(response.statusCode == 200){

          if(response.data['status']){

            thisResponse = createChatRoomModelFromJson(jsonEncode(response.data));

          }else{
            thisResponse = CreateChatRoomModel(
              status: false,
              roomId: "0",
              roomStatus: "0"
            );
          }

          return thisResponse;

        }else{
          print("wrong status code ${response.statusCode}");
        }

      }catch(e){
        print(e);
      }

      return thisResponse;

    }

}