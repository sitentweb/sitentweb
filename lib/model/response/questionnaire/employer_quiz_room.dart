// To parse this JSON data, do
//
//     final employerQuizRoomModel = employerQuizRoomModelFromJson(jsonString);

import 'dart:convert';

EmployerQuizRoomModel employerQuizRoomModelFromJson(String str) => EmployerQuizRoomModel.fromJson(json.decode(str));

String employerQuizRoomModelToJson(EmployerQuizRoomModel data) => json.encode(data.toJson());

class EmployerQuizRoomModel {
  EmployerQuizRoomModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory EmployerQuizRoomModel.fromJson(Map<String, dynamic> json) => EmployerQuizRoomModel(
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
    this.quizId,
    this.quizJobId,
    this.quizEmployerId,
    this.quizTitle,
    this.quiz,
    this.quizStartTime,
    this.quizStopTime,
    this.quizTime,
    this.quizExpireTime,
    this.quizStatus,
    this.quizCreatedAt,
  });

  String quizId;
  String quizJobId;
  String quizEmployerId;
  String quizTitle;
  String quiz;
  String quizStartTime;
  String quizStopTime;
  String quizTime;
  String quizExpireTime;
  String quizStatus;
  DateTime quizCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    quizId: json["quiz_id"],
    quizJobId: json["quiz_job_id"],
    quizEmployerId: json["quiz_employer_id"],
    quizTitle: json["quiz_title"],
    quiz: json["quiz"],
    quizStartTime: json["quiz_start_time"],
    quizStopTime: json["quiz_stop_time"],
    quizTime: json["quiz_time"],
    quizExpireTime: json["quiz_expire_time"],
    quizStatus: json["quiz_status"],
    quizCreatedAt: DateTime.parse(json["quiz_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "quiz_id": quizId,
    "quiz_job_id": quizJobId,
    "quiz_employer_id": quizEmployerId,
    "quiz_title": quizTitle,
    "quiz": quiz,
    "quiz_start_time": quizStartTime,
    "quiz_stop_time": quizStopTime,
    "quiz_time": quizTime,
    "quiz_expire_time": quizExpireTime,
    "quiz_status": quizStatus,
    "quiz_created_at": quizCreatedAt.toIso8601String(),
  };
}
