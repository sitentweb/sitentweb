// To parse this JSON data, do
//
//     final sendChatMessageModel = sendChatMessageModelFromJson(jsonString);

import 'dart:convert';

SendChatMessageModel sendChatMessageModelFromJson(String str) => SendChatMessageModel.fromJson(json.decode(str));

String sendChatMessageModelToJson(SendChatMessageModel data) => json.encode(data.toJson());

class SendChatMessageModel {
  SendChatMessageModel({
    this.status,
    this.data,
    this.messageId,
  });

  bool status;
  String data;
  int messageId;

  factory SendChatMessageModel.fromJson(Map<String, dynamic> json) => SendChatMessageModel(
    status: json["status"],
    data: json["data"],
    messageId: json["message_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
    "message_id": messageId,
  };
}
