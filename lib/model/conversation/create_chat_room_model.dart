// To parse this JSON data, do
//
//     final createChatRoomModel = createChatRoomModelFromJson(jsonString);

import 'dart:convert';

CreateChatRoomModel createChatRoomModelFromJson(String str) => CreateChatRoomModel.fromJson(json.decode(str));

String createChatRoomModelToJson(CreateChatRoomModel data) => json.encode(data.toJson());

class CreateChatRoomModel {
  CreateChatRoomModel({
    this.status,
    this.roomId,
    this.roomStatus,
  });

  bool status;
  String roomId;
  String roomStatus;

  factory CreateChatRoomModel.fromJson(Map<String, dynamic> json) => CreateChatRoomModel(
    status: json["status"],
    roomId: json["room_id"],
    roomStatus: json["room_status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "room_id": roomId,
    "room_status": roomStatus,
  };
}
