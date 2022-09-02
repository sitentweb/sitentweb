// To parse this JSON data, do
//
//     final fetchEducationModel = fetchEducationModelFromJson(jsonString);

import 'dart:convert';

FetchEducationModel fetchEducationModelFromJson(String str) => FetchEducationModel.fromJson(json.decode(str));

String fetchEducationModelToJson(FetchEducationModel data) => json.encode(data.toJson());

class FetchEducationModel {
  FetchEducationModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory FetchEducationModel.fromJson(Map<String, dynamic> json) => FetchEducationModel(
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
    this.id,
    this.educationName,
    this.eductionCreatedAt,
  });

  String id;
  String educationName;
  DateTime eductionCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    educationName: json["education_name"],
    eductionCreatedAt: DateTime.parse(json["eduction_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "education_name": educationName,
    "eduction_created_at": eductionCreatedAt.toIso8601String(),
  };
}
