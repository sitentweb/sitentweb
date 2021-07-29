// To parse this JSON data, do
//
//     final getSingleChatRoomModel = getSingleChatRoomModelFromJson(jsonString);

import 'dart:convert';

GetSingleChatRoomModel getSingleChatRoomModelFromJson(String str) => GetSingleChatRoomModel.fromJson(json.decode(str));

String getSingleChatRoomModelToJson(GetSingleChatRoomModel data) => json.encode(data.toJson());

class GetSingleChatRoomModel {
  GetSingleChatRoomModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory GetSingleChatRoomModel.fromJson(Map<String, dynamic> json) => GetSingleChatRoomModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.roomId,
    this.roomEmployer,
    this.roomEmployee,
    this.roomStatus,
    this.roomCreatedAt,
  });

  String roomId;
  String roomEmployer;
  String roomEmployee;
  String roomStatus;
  DateTime roomCreatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    roomId: json["room_id"],
    roomEmployer: json["room_employer"],
    roomEmployee: json["room_employee"],
    roomStatus: json["room_status"],
    roomCreatedAt: DateTime.parse(json["room_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "room_id": roomId,
    "room_employer": roomEmployer,
    "room_employee": roomEmployee,
    "room_status": roomStatus,
    "room_created_at": roomCreatedAt.toIso8601String(),
  };
}
