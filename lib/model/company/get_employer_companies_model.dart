// To parse this JSON data, do
//
//     final employerCompanyModel = employerCompanyModelFromJson(jsonString);

import 'dart:convert';

EmployerCompanyModel employerCompanyModelFromJson(String str) => EmployerCompanyModel.fromJson(json.decode(str));

String employerCompanyModelToJson(EmployerCompanyModel data) => json.encode(data.toJson());

class EmployerCompanyModel {
    EmployerCompanyModel({
        this.status,
        this.data,
    });

    bool status;
    List<Datum> data;

    factory EmployerCompanyModel.fromJson(Map<String, dynamic> json) => EmployerCompanyModel(
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
        this.companyId,
        this.userId,
        this.companyLogo,
        this.companyName,
        this.companySlug,
        this.companyEmail,
        this.companyWebsite,
        this.companyAddress,
        this.companyDes,
        this.verifiedCompany,
        this.companyStatus,
        this.createdOn,
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

    String companyId;
    String userId;
    String companyLogo;
    String companyName;
    String companySlug;
    String companyEmail;
    String companyWebsite;
    String companyAddress;
    String companyDes;
    String verifiedCompany;
    String companyStatus;
    DateTime createdOn;
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        companyId: json["company_id"],
        userId: json["user_id"],
        companyLogo: json["company_logo"],
        companyName: json["company_name"],
        companySlug: json["company_slug"],
        companyEmail: json["company_email"],
        companyWebsite: json["company_website"],
        companyAddress: json["company_address"],
        companyDes: json["company_des"],
        verifiedCompany: json["verified_company"],
        companyStatus: json["company_status"],
        createdOn: DateTime.parse(json["created_on"]),
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
        "company_id": companyId,
        "user_id": userId,
        "company_logo": companyLogo,
        "company_name": companyName,
        "company_slug": companySlug,
        "company_email": companyEmail,
        "company_website": companyWebsite,
        "company_address": companyAddress,
        "company_des": companyDes,
        "verified_company": verifiedCompany,
        "company_status": companyStatus,
        "created_on": createdOn.toIso8601String(),
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
