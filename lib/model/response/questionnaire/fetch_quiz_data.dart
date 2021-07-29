// To parse this JSON data, do
//
//     final fetchQuizDataModel = fetchQuizDataModelFromJson(jsonString);

import 'dart:convert';

FetchQuizDataModel fetchQuizDataModelFromJson(String str) => FetchQuizDataModel.fromJson(json.decode(str));

String fetchQuizDataModelToJson(FetchQuizDataModel data) => json.encode(data.toJson());

class FetchQuizDataModel {
  FetchQuizDataModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory FetchQuizDataModel.fromJson(Map<String, dynamic> json) => FetchQuizDataModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    quizRoomId: json["quiz_room_id"],
    quizId: json["quiz_id"],
    employeeId: json["employee_id"],
    employerId: json["employer_id"],
    jobId: json["job_id"],
    quiz: json["quiz"],
    quizStartTime: json["quiz_start_time"],
    quizStopTime: json["quiz_stop_time"],
    quizTime: json["quiz_time"],
    quizExpireTime: json["quiz_expire_time"],
    quizStatus: json["quiz_status"],
    quizRoomCreatedAt: DateTime.parse(json["quiz_room_created_at"]),
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
  };
}
