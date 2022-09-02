// To parse this JSON data, do
//
//     final updateQuizModel = updateQuizModelFromJson(jsonString);

import 'dart:convert';

UpdateQuizModel updateQuizModelFromJson(String str) => UpdateQuizModel.fromJson(json.decode(str));

String updateQuizModelToJson(UpdateQuizModel data) => json.encode(data.toJson());

class UpdateQuizModel {
  UpdateQuizModel({
    this.status,
    this.data,
  });

  bool status;
  bool data;

  factory UpdateQuizModel.fromJson(Map<String, dynamic> json) => UpdateQuizModel(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}
