// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) => DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) => json.encode(data.toJson());

class DashboardDataModel {
  DashboardDataModel({
    this.status,
    this.data,
    this.total,
    this.percentage,
    this.percentage2,
  });

  bool status;
  Data data;
  int total;
  double percentage;
  double percentage2;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) => DashboardDataModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    total: json["total"],
    percentage: json["percentage"].toDouble(),
    percentage2: json["percentage2"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "total": total,
    "percentage": percentage,
    "percentage2": percentage2,
  };
}

class Data {
  Data({
    this.companyCount,
    this.jobCount,
    this.interViewCount,
    this.interViewHoldCount,
    this.interViewAgreeCount,
    this.questionnaireCount,
    this.questionnaireRoomCount,
    this.questionnaireStartCount,
    this.questionnaireHoldCount,
    this.hiredCount,
    this.jobAppliedCount,
    this.jobRejectCount,
  });

  String companyCount;
  String jobCount;
  String interViewCount;
  String interViewHoldCount;
  String interViewAgreeCount;
  String questionnaireCount;
  String questionnaireRoomCount;
  String questionnaireStartCount;
  String questionnaireHoldCount;
  String hiredCount;
  String jobAppliedCount;
  String jobRejectCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    companyCount: json["companyCount"],
    jobCount: json["jobCount"],
    interViewCount: json["interViewCount"],
    interViewHoldCount: json["interViewHoldCount"],
    interViewAgreeCount: json["interViewAgreeCount"],
    questionnaireCount: json["questionnaireCount"],
    questionnaireRoomCount: json["questionnaireRoomCount"],
    questionnaireStartCount: json["questionnaireStartCount"],
    questionnaireHoldCount: json["questionnaireHoldCount"],
    hiredCount: json["hiredCount"],
    jobAppliedCount: json["jobAppliedCount"],
    jobRejectCount: json["jobRejectCount"],
  );

  Map<String, dynamic> toJson() => {
    "companyCount": companyCount,
    "jobCount": jobCount,
    "interViewCount": interViewCount,
    "interViewHoldCount": interViewHoldCount,
    "interViewAgreeCount": interViewAgreeCount,
    "questionnaireCount": questionnaireCount,
    "questionnaireRoomCount": questionnaireRoomCount,
    "questionnaireStartCount": questionnaireStartCount,
    "questionnaireHoldCount": questionnaireHoldCount,
    "hiredCount": hiredCount,
    "jobAppliedCount": jobAppliedCount,
    "jobRejectCount": jobRejectCount,
  };
}
