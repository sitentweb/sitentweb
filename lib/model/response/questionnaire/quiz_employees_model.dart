// To parse this JSON data, do
//
//     final quizEmployeesRoomModel = quizEmployeesRoomModelFromJson(jsonString);

import 'dart:convert';

QuizEmployeesRoomModel quizEmployeesRoomModelFromJson(String str) => QuizEmployeesRoomModel.fromJson(json.decode(str));

String quizEmployeesRoomModelToJson(QuizEmployeesRoomModel data) => json.encode(data.toJson());

class QuizEmployeesRoomModel {
  QuizEmployeesRoomModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory QuizEmployeesRoomModel.fromJson(Map<String, dynamic> json) => QuizEmployeesRoomModel(
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
    this.userId,
    this.userName,
    this.userEmail,
    this.userUsername,
    this.userOrganization,
    this.userOrganizationLogo,
    this.userOrganizationType,
    this.userPass,
    this.userMobile,
    this.userPhoto,
    this.userBio,
    this.userSkills,
    this.userExperience,
    this.userQualifications,
    this.userLanguages,
    this.userLastOtp,
    this.userOtpVerified,
    this.userService,
    this.userResume,
    this.userStatus,
    this.userLocation,
    this.userJobLocation,
    this.userToken,
    this.userType,
    this.userProfileComplete,
    this.userCreatedAt,
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
  DateTime quizExpireTime;
  String quizStatus;
  DateTime quizRoomCreatedAt;
  String userId;
  String userName;
  String userEmail;
  String userUsername;
  String userOrganization;
  String userOrganizationLogo;
  String userOrganizationType;
  String userPass;
  String userMobile;
  String userPhoto;
  String userBio;
  String userSkills;
  String userExperience;
  String userQualifications;
  String userLanguages;
  String userLastOtp;
  String userOtpVerified;
  String userService;
  String userResume;
  String userStatus;
  String userLocation;
  String userJobLocation;
  String userToken;
  String userType;
  String userProfileComplete;
  DateTime userCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    quizRoomId: json["quiz_room_id"],
    quizId: json["quiz_id"],
    employeeId: json["employee_id"],
    employerId: json["employer_id"],
    jobId: json["job_id"],
    quiz: json["quiz"],
    quizStartTime: json["quiz_start_time"],
    quizStopTime: json["quiz_stop_time"],
    quizTime: json["quiz_time"],
    quizExpireTime: DateTime.parse(json["quiz_expire_time"]),
    quizStatus: json["quiz_status"],
    quizRoomCreatedAt: DateTime.parse(json["quiz_room_created_at"]),
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    userUsername: json["user_username"],
    userOrganization: json["user_organization"] == null ? null : json["user_organization"],
    userOrganizationLogo: json["user_organization_logo"],
    userOrganizationType: json["user_organization_type"],
    userPass: json["user_pass"],
    userMobile: json["user_mobile"],
    userPhoto: json["user_photo"],
    userBio: json["user_bio"],
    userSkills: json["user_skills"] == null ? null : json["user_skills"],
    userExperience: json["user_experience"],
    userQualifications: json["user_qualifications"],
    userLanguages: json["user_languages"],
    userLastOtp: json["user_last_otp"],
    userOtpVerified: json["user_otp_verified"],
    userService: json["user_service"],
    userResume: json["user_resume"],
    userStatus: json["user_status"],
    userLocation: json["user_location"],
    userJobLocation: json["user_job_location"],
    userToken: json["user_token"],
    userType: json["user_type"],
    userProfileComplete: json["user_profile_complete"],
    userCreatedAt: DateTime.parse(json["user_created_at"]),
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
    "quiz_expire_time": "${quizExpireTime.year.toString().padLeft(4, '0')}-${quizExpireTime.month.toString().padLeft(2, '0')}-${quizExpireTime.day.toString().padLeft(2, '0')}",
    "quiz_status": quizStatus,
    "quiz_room_created_at": quizRoomCreatedAt.toIso8601String(),
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
    "user_username": userUsername,
    "user_organization": userOrganization == null ? null : userOrganization,
    "user_organization_logo": userOrganizationLogo,
    "user_organization_type": userOrganizationType,
    "user_pass": userPass,
    "user_mobile": userMobile,
    "user_photo": userPhoto,
    "user_bio": userBio,
    "user_skills": userSkills == null ? null : userSkills,
    "user_experience": userExperience,
    "user_qualifications": userQualifications,
    "user_languages": userLanguages,
    "user_last_otp": userLastOtp,
    "user_otp_verified": userOtpVerified,
    "user_service": userService,
    "user_resume": userResume,
    "user_status": userStatus,
    "user_location": userLocation,
    "user_job_location": userJobLocation,
    "user_token": userToken,
    "user_type": userType,
    "user_profile_complete": userProfileComplete,
    "user_created_at": userCreatedAt.toIso8601String(),
  };
}
