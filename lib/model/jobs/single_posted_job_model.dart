// To parse this JSON data, do
//
//     final singlePostedJobModel = singlePostedJobModelFromJson(jsonString);

import 'dart:convert';

SinglePostedJobModel singlePostedJobModelFromJson(String str) =>
    SinglePostedJobModel.fromJson(json.decode(str));

String singlePostedJobModelToJson(SinglePostedJobModel data) =>
    json.encode(data.toJson());

class SinglePostedJobModel {
  bool status;
  String message;
  JobData jobData;

  SinglePostedJobModel({
    this.status,
    this.message,
    this.jobData,
  });

  factory SinglePostedJobModel.fromJson(Map<String, dynamic> json) =>
      SinglePostedJobModel(
        status: json["status"],
        message: json["message"],
        jobData: JobData.fromJson(json["job_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "job_data": jobData.toJson(),
      };
}

class JobData {
  String jobId;
  String companyId;
  String jobTitle;
  String jobSlug;
  String jobDescription;
  List<String> jobKeySkills;
  String jobEducation;
  String jobIndustry;
  String jobHiringCount;
  String jobMinimumSalary;
  String jobMaximumSalary;
  String jobSalaryType;
  String jobSalaryCommission;
  String jobSchedule;
  String jobQualification;
  List<JobExtExperience> jobExtExperience;
  String jobStatus;
  DateTime jobUpdatedOn;
  DateTime jobCreatedAt;
  Company company;

  JobData({
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
    this.company,
  });

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
        jobId: json["job_id"],
        companyId: json["company_id"],
        jobTitle: json["job_title"],
        jobSlug: json["job_slug"],
        jobDescription: json["job_description"],
        jobKeySkills: List<String>.from(json["job_key_skills"].map((x) => x)),
        jobEducation: json["job_education"],
        jobIndustry: json["job_industry"],
        jobHiringCount: json["job_hiring_count"],
        jobMinimumSalary: json["job_minimum_salary"],
        jobMaximumSalary: json["job_maximum_salary"],
        jobSalaryType: json["job_salary_type"],
        jobSalaryCommission: json["job_salary_commission"],
        jobSchedule: json["job_schedule"],
        jobQualification: json["job_qualification"],
        jobExtExperience: List<JobExtExperience>.from(json["job_ext_experience"]
            .map((x) => JobExtExperience.fromJson(x))),
        jobStatus: json["job_status"],
        jobUpdatedOn: DateTime.parse(json["job_updated_on"]),
        jobCreatedAt: DateTime.parse(json["job_created_at"]),
        company: Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "company_id": companyId,
        "job_title": jobTitle,
        "job_slug": jobSlug,
        "job_description": jobDescription,
        "job_key_skills": List<dynamic>.from(jobKeySkills.map((x) => x)),
        "job_education": jobEducation,
        "job_industry": jobIndustry,
        "job_hiring_count": jobHiringCount,
        "job_minimum_salary": jobMinimumSalary,
        "job_maximum_salary": jobMaximumSalary,
        "job_salary_type": jobSalaryType,
        "job_salary_commission": jobSalaryCommission,
        "job_schedule": jobSchedule,
        "job_qualification": jobQualification,
        "job_ext_experience":
            List<dynamic>.from(jobExtExperience.map((x) => x.toJson())),
        "job_status": jobStatus,
        "job_updated_on": jobUpdatedOn.toIso8601String(),
        "job_created_at": jobCreatedAt.toIso8601String(),
        "company": company.toJson(),
      };
}

class Company {
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

  Company({
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
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
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
      };
}

class JobExtExperience {
  String experienceTitle;
  String experienceYear;
  String experienceMonth;

  JobExtExperience({
    this.experienceTitle,
    this.experienceYear,
    this.experienceMonth,
  });

  factory JobExtExperience.fromJson(Map<String, dynamic> json) =>
      JobExtExperience(
        experienceTitle: json["ExperienceTitle"],
        experienceYear: json["ExperienceYear"],
        experienceMonth: json["ExperienceMonth"],
      );

  Map<String, dynamic> toJson() => {
        "ExperienceTitle": experienceTitle,
        "ExperienceYear": experienceYear,
        "ExperienceMonth": experienceMonth,
      };
}
