// To parse this JSON data, do
//
//     final jobListModel = jobListModelFromJson(jsonString);

import 'dart:convert';

JobListModel jobListModelFromJson(String str) =>
    JobListModel.fromJson(json.decode(str));

String jobListModelToJson(JobListModel data) => json.encode(data.toJson());

class JobListModel {
  bool status;
  String message;
  bool showRegister;
  List<Job> jobs;

  JobListModel({
    this.status,
    this.message,
    this.showRegister,
    this.jobs,
  });

  factory JobListModel.fromJson(Map<String, dynamic> json) => JobListModel(
        status: json["status"],
        message: json["message"],
        showRegister: json["showRegister"],
        jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "showRegister": showRegister,
        "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
      };
}

class Job {
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
  Company company;
  String isUserApplied;
  dynamic appliedStatus;

  Job({
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
    this.isUserApplied,
    this.appliedStatus,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
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
        company: Company.fromJson(json["company"]),
        isUserApplied: json["is_user_applied"],
        appliedStatus: json["applied_status"],
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
        "company": company.toJson(),
        "is_user_applied": isUserApplied,
        "applied_status": appliedStatus,
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
