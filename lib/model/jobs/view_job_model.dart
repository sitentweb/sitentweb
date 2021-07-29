// To parse this JSON data, do
//
//     final viewJobModel = viewJobModelFromJson(jsonString);

import 'dart:convert';

ViewJobModel viewJobModelFromJson(String str) => ViewJobModel.fromJson(json.decode(str));

String viewJobModelToJson(ViewJobModel data) => json.encode(data.toJson());

class ViewJobModel {
  ViewJobModel({
    this.status,
    this.data,
  });

  bool status;
  Data data;

  factory ViewJobModel.fromJson(Map<String, dynamic> json) => ViewJobModel(
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
    this.jobId,
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
    this.jobEducationName,
    this.jobIndustryName,
    this.jobAppliedStatus,
    this.jobSaveStatus,
  });

  String jobId;
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
  String jobEducationName;
  String jobIndustryName;
  String jobAppliedStatus;
  String jobSaveStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    jobId: json["job_id"],
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
    jobEducationName: json["job_education_name"],
    jobIndustryName: json["job_industry_name"],
    jobAppliedStatus: json["job_applied_status"],
    jobSaveStatus: json["job_save_status"],
  );

  Map<String, dynamic> toJson() => {
    "job_id": jobId,
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
    "job_education_name": jobEducationName,
    "job_industry_name": jobIndustryName,
    "job_applied_status": jobAppliedStatus,
    "job_save_status": jobSaveStatus,
  };
}