// To parse this JSON data, do
//
//     final getAllChatRoomModel = getAllChatRoomModelFromJson(jsonString);

import 'dart:convert';

GetAllChatRoomModel getAllChatRoomModelFromJson(String str) => GetAllChatRoomModel.fromJson(json.decode(str));

String getAllChatRoomModelToJson(GetAllChatRoomModel data) => json.encode(data.toJson());

class GetAllChatRoomModel {
  GetAllChatRoomModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory GetAllChatRoomModel.fromJson(Map<String, dynamic> json) => GetAllChatRoomModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.roomId,
    this.roomEmployer,
    this.roomEmployee,
    this.roomStatus,
    this.roomCreatedAt,
    this.userName,
    this.userId,
    this.userPhoto,
    this.lastMessage,
  });

  String roomId;
  String roomEmployer;
  String roomEmployee;
  String roomStatus;
  DateTime roomCreatedAt;
  String userName;
  String userId;
  String userPhoto;
  String lastMessage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    roomId: json["room_id"],
    roomEmployer: json["room_employer"],
    roomEmployee: json["room_employee"],
    roomStatus: json["room_status"],
    roomCreatedAt: DateTime.parse(json["room_created_at"]),
    userName: json["user_name"] == null ? null : json["user_name"],
    userId: json["user_id"] == null ? null : json["user_id"],
    userPhoto: json["user_photo"] == null ? null : json["user_photo"],
    lastMessage: json["last_message"] == null ? null : json["last_message"],
  );

  Map<String, dynamic> toJson() => {
    "room_id": roomId,
    "room_employer": roomEmployer,
    "room_employee": roomEmployee,
    "room_status": roomStatus,
    "room_created_at": roomCreatedAt.toIso8601String(),
    "user_name": userName == null ? null : userName,
    "user_id": userId == null ? null : userId,
    "user_photo": userPhoto == null ? null : userPhoto,
    "last_message": lastMessage == null ? null : lastMessage,
  };
}
