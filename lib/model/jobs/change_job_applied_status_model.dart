// To parse this JSON data, do
//
//     final updateJobAppliedModel = updateJobAppliedModelFromJson(jsonString);

import 'dart:convert';

UpdateJobAppliedModel updateJobAppliedModelFromJson(String str) => UpdateJobAppliedModel.fromJson(json.decode(str));

String updateJobAppliedModelToJson(UpdateJobAppliedModel data) => json.encode(data.toJson());

class UpdateJobAppliedModel {
  UpdateJobAppliedModel({
    this.status,
    this.data,
  });

  bool status;
  dynamic data;

  factory UpdateJobAppliedModel.fromJson(Map<String, dynamic> json) => UpdateJobAppliedModel(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}
