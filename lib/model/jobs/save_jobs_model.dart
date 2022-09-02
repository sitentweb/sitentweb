// To parse this JSON data, do
//
//     final saveJobsModel = saveJobsModelFromJson(jsonString);

import 'dart:convert';

SaveJobsModel saveJobsModelFromJson(String str) =>
    SaveJobsModel.fromJson(json.decode(str));

String saveJobsModelToJson(SaveJobsModel data) => json.encode(data.toJson());

class SaveJobsModel {
  SaveJobsModel({
    this.status,
    this.saved,
    this.data,
  });

  bool status;
  bool saved;
  String data;

  factory SaveJobsModel.fromJson(Map<String, dynamic> json) => SaveJobsModel(
        status: json["status"],
        saved: json["saved"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "saved": saved,
        "data": data,
      };
}
