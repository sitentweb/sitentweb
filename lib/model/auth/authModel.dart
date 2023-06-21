// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  bool status;
  String message;
  Data data;
  User user;

  AuthModel({
    this.status,
    this.message,
    this.data,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "user": user.toJson(),
      };
}

class Data {
  String id;
  String mobileNumber;
  bool isLogged;
  int generatedOtp;
  LastLogin lastLogin;

  Data({
    this.id,
    this.mobileNumber,
    this.isLogged,
    this.generatedOtp,
    this.lastLogin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mobileNumber: json["mobile_number"],
        isLogged: json["isLogged"],
        generatedOtp: json["generatedOTP"],
        lastLogin: LastLogin.fromJson(json["lastLogin"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile_number": mobileNumber,
        "isLogged": isLogged,
        "generatedOTP": generatedOtp,
        "lastLogin": lastLogin.toJson(),
      };
}

class LastLogin {
  DateTime date;
  int timezoneType;
  String timezone;

  LastLogin({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  factory LastLogin.fromJson(Map<String, dynamic> json) => LastLogin(
        date: DateTime.parse(json["date"]),
        timezoneType: json["timezone_type"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}

class User {
  String userId;
  String userName;
  String userEmail;
  String userUsername;
  dynamic userOrganization;
  String userOrganizationLogo;
  String userOrganizationType;
  String userPass;
  String userMobile;
  String userPhoto;
  String userBio;
  String userDob;
  dynamic userSkills;
  String userExperience;
  String userQualifications;
  String userLanguages;
  String userLastOtp;
  String userOtpVerified;
  String userService;
  String userResume;
  String userDeleted;
  String userStatus;
  String userLocation;
  String userJobLocation;
  String userToken;
  String userJwtToken;
  String userType;
  String userProfileComplete;
  DateTime userCreatedAt;

  User({
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
    this.userDob,
    this.userSkills,
    this.userExperience,
    this.userQualifications,
    this.userLanguages,
    this.userLastOtp,
    this.userOtpVerified,
    this.userService,
    this.userResume,
    this.userDeleted,
    this.userStatus,
    this.userLocation,
    this.userJobLocation,
    this.userToken,
    this.userJwtToken,
    this.userType,
    this.userProfileComplete,
    this.userCreatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userUsername: json["user_username"],
        userOrganization: json["user_organization"],
        userOrganizationLogo: json["user_organization_logo"],
        userOrganizationType: json["user_organization_type"],
        userPass: json["user_pass"],
        userMobile: json["user_mobile"],
        userPhoto: json["user_photo"],
        userBio: json["user_bio"],
        userDob: json["user_dob"],
        userSkills: json["user_skills"],
        userExperience: json["user_experience"],
        userQualifications: json["user_qualifications"],
        userLanguages: json["user_languages"],
        userLastOtp: json["user_last_otp"],
        userOtpVerified: json["user_otp_verified"],
        userService: json["user_service"],
        userResume: json["user_resume"],
        userDeleted: json["user_deleted"],
        userStatus: json["user_status"],
        userLocation: json["user_location"],
        userJobLocation: json["user_job_location"],
        userToken: json["user_token"],
        userJwtToken: json["user_jwt_token"],
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
        "user_organization_logo": userOrganizationLogo,
        "user_organization_type": userOrganizationType,
        "user_pass": userPass,
        "user_mobile": userMobile,
        "user_photo": userPhoto,
        "user_bio": userBio,
        "user_dob": userDob,
        "user_skills": userSkills,
        "user_experience": userExperience,
        "user_qualifications": userQualifications,
        "user_languages": userLanguages,
        "user_last_otp": userLastOtp,
        "user_otp_verified": userOtpVerified,
        "user_service": userService,
        "user_resume": userResume,
        "user_deleted": userDeleted,
        "user_status": userStatus,
        "user_location": userLocation,
        "user_job_location": userJobLocation,
        "user_token": userToken,
        "user_jwt_token": userJwtToken,
        "user_type": userType,
        "user_profile_complete": userProfileComplete,
        "user_created_at": userCreatedAt.toIso8601String(),
      };
}
