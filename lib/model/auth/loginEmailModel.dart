// To parse this JSON data, do
//
//     final loginEmail = loginEmailFromJson(jsonString);

import 'dart:convert';

LoginEmail loginEmailFromJson(String str) =>
    LoginEmail.fromJson(json.decode(str));

String loginEmailToJson(LoginEmail data) => json.encode(data.toJson());

class LoginEmail {
  bool status;
  String message;
  Data data;

  LoginEmail({
    this.status,
    this.message,
    this.data,
  });

  factory LoginEmail.fromJson(Map<String, dynamic> json) => LoginEmail(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  bool isEmailRegistered;
  User user;

  Data({
    this.isEmailRegistered,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isEmailRegistered: json["is_email_registered"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "is_email_registered": isEmailRegistered,
        "user": user.toJson(),
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
  String userStatus;
  String userLocation;
  String userJobLocation;
  String userToken;
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
    this.userStatus,
    this.userLocation,
    this.userJobLocation,
    this.userToken,
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
        "user_status": userStatus,
        "user_location": userLocation,
        "user_job_location": userJobLocation,
        "user_token": userToken,
        "user_type": userType,
        "user_profile_complete": userProfileComplete,
        "user_created_at": userCreatedAt.toIso8601String(),
      };
}
