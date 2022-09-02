// To parse this JSON data, do
//
//     final getAllMessageModel = getAllMessageModelFromJson(jsonString);

import 'dart:convert';

GetAllMessageModel getAllMessageModelFromJson(String str) => GetAllMessageModel.fromJson(json.decode(str));

String getAllMessageModelToJson(GetAllMessageModel data) => json.encode(data.toJson());

class GetAllMessageModel {
  GetAllMessageModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory GetAllMessageModel.fromJson(Map<String, dynamic> json) => GetAllMessageModel(
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
    this.messageId,
    this.messageid,
    this.senderId,
    this.receiverId,
    this.roomId,
    this.message,
    this.messageStatus,
    this.messageCreatedAt,
  });

  String messageId;
  String messageid;
  String senderId;
  String receiverId;
  String roomId;
  String message;
  String messageStatus;
  DateTime messageCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    messageId: json["message_id"],
    messageid: json["messageid"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    roomId: json["room_id"],
    message: json["message"],
    messageStatus: json["message_status"],
    messageCreatedAt: DateTime.parse(json["message_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
    "messageid": messageid,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "room_id": roomId,
    "message": message,
    "message_status": messageStatus,
    "message_created_at": messageCreatedAt.toIso8601String(),
  };
}
