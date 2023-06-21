// To parse this JSON data, do
//
//     final fetchHiredCandidatesModel = fetchHiredCandidatesModelFromJson(jsonString);

import 'dart:convert';

FetchHiredCandidatesModel fetchHiredCandidatesModelFromJson(String str) =>
    FetchHiredCandidatesModel.fromJson(json.decode(str));

String fetchHiredCandidatesModelToJson(FetchHiredCandidatesModel data) =>
    json.encode(data.toJson());

class FetchHiredCandidatesModel {
  FetchHiredCandidatesModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory FetchHiredCandidatesModel.fromJson(Map<String, dynamic> json) =>
      FetchHiredCandidatesModel(
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
    this.appliedJobId,
    this.jobId,
    this.userId,
    this.employerId,
    this.status,
    this.statusDate,
    this.appliedOn,
    this.aUserId,
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
    this.companyId,
    this.jobTitle,
    this.jobSlug,
    this.jobDescription,
    this.jobKeySkills,
    this.jobEducation,
    this.jobIndustry,
    this.jobHiringCount,
    this.jobMinimumSalary,
    this.jobMaximumSalary,
    this.jobSalaryType,
    this.jobSalaryCommission,
    this.jobSchedule,
    this.jobQualification,
    this.jobExtExperience,
    this.jobStatus,
    this.jobUpdatedOn,
    this.jobCreatedAt,
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
  });

  String appliedJobId;
  String jobId;
  String userId;
  String employerId;
  String status;
  DateTime statusDate;
  DateTime appliedOn;
  String aUserId;
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
  String companyId;
  String jobTitle;
  String jobSlug;
  String jobDescription;
  String jobKeySkills;
  String jobEducation;
  String jobIndustry;
  String jobHiringCount;
  String jobMinimumSalary;
  String jobMaximumSalary;
  String jobSalaryType;
  String jobSalaryCommission;
  String jobSchedule;
  String jobQualification;
  String jobExtExperience;
  String jobStatus;
  DateTime jobUpdatedOn;
  DateTime jobCreatedAt;
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        appliedJobId: json["applied_job_id"],
        jobId: json["job_id"],
        aUserId: json["auser_id"],
        userId: json["user_id"],
        employerId: json["employer_id"],
        status: json["status"],
        statusDate: DateTime.parse(json["status_date"]),
        appliedOn: DateTime.parse(json["applied_on"]),
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
        companyId: json["company_id"],
        jobTitle: json["job_title"],
        jobSlug: json["job_slug"],
        jobDescription: json["job_description"],
        jobKeySkills: json["job_key_skills"],
        jobEducation: json["job_education"],
        jobIndustry: json["job_industry"],
        jobHiringCount: json["job_hiring_count"],
        jobMinimumSalary: json["job_minimum_salary"],
        jobMaximumSalary: json["job_maximum_salary"],
        jobSalaryType: json["job_salary_type"],
        jobSalaryCommission: json["job_salary_commission"],
        jobSchedule: json["job_schedule"],
        jobQualification: json["job_qualification"],
        jobExtExperience: json["job_ext_experience"],
        jobStatus: json["job_status"],
        jobUpdatedOn: DateTime.parse(json["job_updated_on"]),
        jobCreatedAt: DateTime.parse(json["job_created_at"]),
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
      );

  Map<String, dynamic> toJson() => {
        "applied_job_id": appliedJobId,
        "job_id": jobId,
        "user_id": userId,
        "employer_id": employerId,
        "status": status,
        "status_date": statusDate.toIso8601String(),
        "applied_on": appliedOn.toIso8601String(),
        "auser_id": aUserId,
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
        "company_id": companyId,
        "job_title": jobTitle,
        "job_slug": jobSlug,
        "job_description": jobDescription,
        "job_key_skills": jobKeySkills,
        "job_education": jobEducation,
        "job_industry": jobIndustry,
        "job_hiring_count": jobHiringCount,
        "job_minimum_salary": jobMinimumSalary,
        "job_maximum_salary": jobMaximumSalary,
        "job_salary_type": jobSalaryType,
        "job_salary_commission": jobSalaryCommission,
        "job_schedule": jobSchedule,
        "job_qualification": jobQualification,
        "job_ext_experience": jobExtExperience,
        "job_status": jobStatus,
        "job_updated_on": jobUpdatedOn.toIso8601String(),
        "job_created_at": jobCreatedAt.toIso8601String(),
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
      };
}
