// To parse this JSON data, do
//
//     final fetchQuizRoomModel = fetchQuizRoomModelFromJson(jsonString);

import 'dart:convert';

FetchQuizRoomModel fetchQuizRoomModelFromJson(String str) => FetchQuizRoomModel.fromJson(json.decode(str));

String fetchQuizRoomModelToJson(FetchQuizRoomModel data) => json.encode(data.toJson());

class FetchQuizRoomModel {
  FetchQuizRoomModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory FetchQuizRoomModel.fromJson(Map<String, dynamic> json) => FetchQuizRoomModel(
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
    this.quizRoomId,
    this.quizId,
    this.employeeId,
    this.employerId,
    this.jobId,
    this.quiz,
    this.quizStartTime,
    this.quizStopTime,
    this.quizTime,
    this.quizExpireTime,
    this.quizStatus,
    this.quizRoomCreatedAt,
    this.title,
    this.userId,
    this.userName,
    this.userUsername,
    this.userPass,
    this.userMobile,
    this.userPhoto,
    this.userToken,
    this.userType,
    this.userProfileComplete,
    this.userCreatedAt,
    this.companyId,
    this.jobTitle,
    this.jobSlug,
    this.jobDescription,
    this.jobEducation,
    this.jobIndustry,
    this.jobHiringCount,
    this.jobMinimumSalary,
    this.jobMaximumSalary,
    this.jobSalaryType,
    this.jobSalaryCommission,
    this.jobSchedule,
    this.jobQualification,
    this.jobStatus,
    this.jobUpdatedOn,
    this.jobCreatedAt,
  });

  String quizRoomId;
  String quizId;
  String employeeId;
  String employerId;
  String jobId;
  String quiz;
  String quizStartTime;
  String quizStopTime;
  String quizTime;
  String quizExpireTime;
  String quizStatus;
  DateTime quizRoomCreatedAt;
  String title;
  String userId;
  String userName;
  String userUsername;
  String userPass;
  String userMobile;
  String userPhoto;
  String userToken;
  String userType;
  String userProfileComplete;
  DateTime userCreatedAt;
  String companyId;
  String jobTitle;
  String jobSlug;
  String jobDescription;
  String jobEducation;
  String jobIndustry;
  String jobHiringCount;
  String jobMinimumSalary;
  String jobMaximumSalary;
  String jobSalaryType;
  String jobSalaryCommission;
  String jobSchedule;
  String jobQualification;
  String jobStatus;
  String jobUpdatedOn;
  String jobCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    quizRoomId: json["quiz_room_id"].toString(),
    quizId: json["quiz_id"].toString(),
    employeeId: json["employee_id"].toString(),
    employerId: json["employer_id"].toString(),
    jobId: json["job_id"].toString(),
    quiz: json["quiz"].toString(),
    quizStartTime: json["quiz_start_time"].toString(),
    quizStopTime: json["quiz_stop_time"].toString(),
    quizTime: json["quiz_time"].toString(),
    quizExpireTime: json["quiz_expire_time"].toString(),
    quizStatus: json["quiz_status"].toString(),
    quizRoomCreatedAt: DateTime.parse(json["quiz_room_created_at"]),
    title: json["title"].toString(),
    userId: json["user_id"].toString(),
    userName: json["user_name"].toString(),
    userUsername: json["user_username"].toString(),
    userPass: json["user_pass"].toString(),
    userMobile: json["user_mobile"].toString(),
    userPhoto: json["user_photo"].toString(),
    userToken: json["user_token"].toString(),
    userType: json["user_type"].toString(),
    userProfileComplete: json["user_profile_complete"].toString(),
    userCreatedAt: DateTime.parse(json["user_created_at"]),
    companyId: json["company_id"].toString(),
    jobTitle: json["job_title"].toString(),
    jobSlug: json["job_slug"].toString(),
    jobDescription: json["job_description"].toString(),
    jobEducation: json["job_education"].toString(),
    jobIndustry: json["job_industry"].toString(),
    jobHiringCount: json["job_hiring_count"].toString(),
    jobMinimumSalary: json["job_minimum_salary"].toString(),
    jobMaximumSalary: json["job_maximum_salary"].toString(),
    jobSalaryType: json["job_salary_type"].toString(),
    jobSalaryCommission: json["job_salary_commission"].toString(),
    jobSchedule: json["job_schedule"].toString(),
    jobQualification: json["job_qualification"].toString(),
    jobStatus: json["job_status"].toString(),
    jobUpdatedOn: json["job_updated_on"].toString(),
    jobCreatedAt: json["job_created_at"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "quiz_room_id": quizRoomId,
    "quiz_id": quizId,
    "employee_id": employeeId,
    "employer_id": employerId,
    "job_id": jobId,
    "quiz": quiz,
    "quiz_start_time": quizStartTime,
    "quiz_stop_time": quizStopTime,
    "quiz_time": quizTime,
    "quiz_expire_time": quizExpireTime,
    "quiz_status": quizStatus,
    "quiz_room_created_at": quizRoomCreatedAt.toIso8601String(),
    "title": title,
    "user_id": userId,
    "user_name": userName,
    "user_username": userUsername,
    "user_pass": userPass,
    "user_mobile": userMobile,
    "user_photo": userPhoto,
    "user_token": userToken,
    "user_type": userType,
    "user_profile_complete": userProfileComplete,
    "user_created_at": userCreatedAt.toIso8601String(),
    "company_id": companyId,
    "job_title": jobTitle,
    "job_slug": jobSlug,
    "job_description": jobDescription,
    "job_education": jobEducation,
    "job_industry": jobIndustry,
    "job_hiring_count": jobHiringCount,
    "job_minimum_salary": jobMinimumSalary,
    "job_maximum_salary": jobMaximumSalary,
    "job_salary_type": jobSalaryType,
    "job_salary_commission": jobSalaryCommission,
    "job_schedule": jobSchedule,
    "job_qualification": jobQualification,
    "job_status": jobStatus,
    "job_updated_on": jobUpdatedOn.toString(),
    "job_created_at": jobCreatedAt.toString(),
  };
}
