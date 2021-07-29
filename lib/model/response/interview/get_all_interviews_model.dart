// To parse this JSON data, do
//
//     final getAllInterviewModel = getAllInterviewModelFromJson(jsonString);

import 'dart:convert';

GetAllInterviewModel getAllInterviewModelFromJson(String str) => GetAllInterviewModel.fromJson(json.decode(str));

String getAllInterviewModelToJson(GetAllInterviewModel data) => json.encode(data.toJson());

class GetAllInterviewModel {
  GetAllInterviewModel({
    this.status,
    this.test,
    this.data,
  });

  bool status;
  String test;
  List<Datum> data;

  factory GetAllInterviewModel.fromJson(Map<String, dynamic> json) => GetAllInterviewModel(
    status: json["status"],
    test: json["test"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "test": test,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.interviewId,
    this.employerId,
    this.employeeId,
    this.interviewTitle,
    this.interviewTime,
    this.interviewType,
    this.interviewReason,
    this.interviewAgreeStatus,
    this.interviewRescheduleStatus,
    this.employeeName,
    this.employeePhoto,
    this.employeeToken,
    this.employerName,
    this.employerLogo,
    this.employerToken,
  });

  String interviewId;
  String employerId;
  String employeeId;
  String interviewTitle;
  String interviewTime;
  String interviewType;
  String interviewReason;
  String interviewAgreeStatus;
  String interviewRescheduleStatus;
  String employeeName;
  String employeePhoto;
  String employeeToken;
  String employerName;
  String employerLogo;
  String employerToken;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    interviewId: json["interview_id"],
    employerId: json["employer_id"],
    employeeId: json["employee_id"],
    interviewTitle: json["interview_title"],
    interviewTime: json["interview_time"],
    interviewType: json["interview_type"],
    interviewReason: json["interview_reason"],
    interviewAgreeStatus: json["interview_agree_status"],
    interviewRescheduleStatus: json["interview_reschedule_status"],
    employeeName: json["employee_name"],
    employeePhoto: json["employee_photo"],
    employeeToken: json["employee_token"],
    employerName: json["employer_name"],
    employerLogo: json["employer_logo"],
    employerToken: json["employer_token"],
  );

  Map<String, dynamic> toJson() => {
    "interview_id": interviewId,
    "employer_id": employerId,
    "employee_id": employeeId,
    "interview_title": interviewTitle,
    "interview_time": interviewTime,
    "interview_type": interviewType,
    "interview_reason": interviewReason,
    "interview_agree_status": interviewAgreeStatus,
    "interview_reschedule_status": interviewRescheduleStatus,
    "employee_name": employeeName,
    "employee_photo": employeePhoto,
    "employee_token": employeeToken,
    "employer_name": employerName,
    "employer_logo": employerLogo,
    "employer_token": employerToken,
  };
}
