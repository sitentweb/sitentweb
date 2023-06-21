// To parse this JSON data, do
//
//     final globalModel = globalModelFromJson(jsonString);

import 'dart:convert';

GlobalModel globalModelFromJson(String str) =>
    GlobalModel.fromJson(json.decode(str));

String globalModelToJson(GlobalModel data) => json.encode(data.toJson());

class GlobalModel {
  bool status;
  String message;
  dynamic data;

  GlobalModel({
    this.status,
    this.message,
    this.data,
  });

  factory GlobalModel.fromJson(Map<String, dynamic> json) => GlobalModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
