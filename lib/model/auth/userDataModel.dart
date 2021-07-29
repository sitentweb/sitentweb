// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  UserDataModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
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
    this.userId,
    this.userName,
    this.userEmail,
    this.userUsername,
    this.userOrganization,
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

  String userId;
  String userName;
  String userEmail;
  String userUsername;
  String userOrganization;
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    userUsername: json["user_username"],
    userOrganization: json["user_organization"],
    userOrganizationType: json["user_organization_type"],
    userPass: json["user_pass"],
    userMobile: json["user_mobile"],
    userPhoto: json["user_photo"],
    userBio: json["user_bio"],
    userSkills: json["user_skills"],
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
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
    "user_username": userUsername,
    "user_organization": userOrganization,
    "user_organization_type": userOrganizationType,
    "user_pass": userPass,
    "user_mobile": userMobile,
    "user_photo": userPhoto,
    "user_bio": userBio,
    "user_skills": userSkills,
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
