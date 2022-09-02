// To parse this JSON data, do
//
//     final fetchIndustryModel = fetchIndustryModelFromJson(jsonString);

import 'dart:convert';

FetchIndustryModel fetchIndustryModelFromJson(String str) => FetchIndustryModel.fromJson(json.decode(str));

String fetchIndustryModelToJson(FetchIndustryModel data) => json.encode(data.toJson());

class FetchIndustryModel {
  FetchIndustryModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory FetchIndustryModel.fromJson(Map<String, dynamic> json) => FetchIndustryModel(
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
    this.industryId,
    this.industryTitle,
    this.industryLogo,
    this.industryStatus,
    this.industryCreatedAt,
  });

  String industryId;
  String industryTitle;
  String industryLogo;
  String industryStatus;
  DateTime industryCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    industryId: json["industry_id"],
    industryTitle: json["industry_title"],
    industryLogo: json["industry_logo"],
    industryStatus: json["industry_status"],
    industryCreatedAt: DateTime.parse(json["industry_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "industry_id": industryId,
    "industry_title": industryTitle,
    "industry_logo": industryLogo,
    "industry_status": industryStatus,
    "industry_created_at": industryCreatedAt.toIso8601String(),
  };
}
