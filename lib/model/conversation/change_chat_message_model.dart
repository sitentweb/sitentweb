// To parse this JSON data, do
//
//     final changeChatMessageStatusModel = changeChatMessageStatusModelFromJson(jsonString);

import 'dart:convert';

ChangeChatMessageStatusModel changeChatMessageStatusModelFromJson(String str) => ChangeChatMessageStatusModel.fromJson(json.decode(str));

String changeChatMessageStatusModelToJson(ChangeChatMessageStatusModel data) => json.encode(data.toJson());

class ChangeChatMessageStatusModel {
  ChangeChatMessageStatusModel({
    this.status,
  });

  bool status;

  factory ChangeChatMessageStatusModel.fromJson(Map<String, dynamic> json) => ChangeChatMessageStatusModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
