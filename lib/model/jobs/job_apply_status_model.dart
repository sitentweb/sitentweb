// To parse this JSON data, do
//
//     final jobApplyStatusModel = jobApplyStatusModelFromJson(jsonString);

import 'dart:convert';

JobApplyStatusModel jobApplyStatusModelFromJson(String str) => JobApplyStatusModel.fromJson(json.decode(str));

String jobApplyStatusModelToJson(JobApplyStatusModel data) => json.encode(data.toJson());

class JobApplyStatusModel {
  JobApplyStatusModel({
    this.status,
    this.data,
  });

  bool status;
  int data;

  factory JobApplyStatusModel.fromJson(Map<String, dynamic> json) => JobApplyStatusModel(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}
