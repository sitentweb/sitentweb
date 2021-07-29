// To parse this JSON data, do
//
//     final startQuizModel = startQuizModelFromJson(jsonString);

import 'dart:convert';

StartQuizModel startQuizModelFromJson(String str) => StartQuizModel.fromJson(json.decode(str));

String startQuizModelToJson(StartQuizModel data) => json.encode(data.toJson());

class StartQuizModel {
  StartQuizModel({
    this.status,
    this.data,
  });

  bool status;
  bool data;

  factory StartQuizModel.fromJson(Map<String, dynamic> json) => StartQuizModel(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}
