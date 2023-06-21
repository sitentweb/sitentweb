import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/apis/education/education_api.dart';
import 'package:remark_app/apis/industry/industry_api.dart';
import 'package:remark_app/apis/jobs/fetch_posted_jobs.dart';
import 'package:remark_app/apis/jobs/post_job.dart';
import 'package:remark_app/config/pageSetting.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/jobs/job_list_model.dart';
import 'package:remark_app/notifier/select_company_notifier.dart';

class PostJobController extends GetxController {
  RxList<Job> postedJobs = <Job>[].obs;
  TextEditingController jobTitle = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  // TextEditingController jobEducation = TextEditingController();
  RxString jobEducation = "BCOM".obs;
  TextEditingController jobQualification = TextEditingController();
  RxString jobIndustry = "5".obs;
  TextEditingController jobHiring = TextEditingController();
  TextEditingController jobMinimumSalary = TextEditingController();
  TextEditingController jobMaximumSalary = TextEditingController();
  RxString jobType = "Full Time".obs;
  TextEditingController jobSkillInput = TextEditingController();
  RxList jobSkills = [].obs;
  RxList<Map<String, dynamic>> jobExperience = <Map<String, dynamic>>[].obs;
  GlobalKey<FormState> jobExperienceGlobalKey = GlobalKey<FormState>();
  TextEditingController jobExperienceTitle = TextEditingController();
  TextEditingController jobExperienceMonth = TextEditingController();
  TextEditingController jobExperienceYear = TextEditingController();
  RxString jobCompanyId = "0".obs;
  RxBool isShowPage = true.obs;
  List<DropdownMenuItem> educationList = [];
  List<DropdownMenuItem> industryList = [];
  RxBool readyJobPosting = false.obs;
  RxBool isPostingJob = false.obs;
  RxString jobId = "0".obs;
  RxBool isLoadingPostedJobs = false.obs;

  init() async {
    readyJobPosting(false);
    resetJobPostForm();
    await fetchJobEducationList();
    await fetchJobIndustries();
    jobSkills.clear();
    jobExperience.clear();
    jobCompanyId = "0".obs;
    isPostingJob(false);
    readyJobPosting(true);
  }

  initFetchPostedJobs() async {
    postedJobs.clear();
    isLoadingPostedJobs(true);

    final res = await PostJobApi().fetchPostedJobs();

    if (res.status) {
      postedJobs.assignAll(res.jobs);
      postedJobs.refresh();
    } else {
      RemarkPageSetting.showSnackbar(title: "Error", message: res.message);
    }

    isLoadingPostedJobs(false);
    refresh();
  }

  initEditing(id) async {
    resetJobPostForm();
    readyJobPosting(false);
    jobId("0");

    await fetchJobEducationList();
    await fetchJobIndustries();

    final res = await FetchPostedJobs().fetchSinglePostedJob(jobId: id);

    if (res.status) {
      jobCompanyId(res.jobData.companyId);
      jobId(res.jobData.jobId);
      jobTitle.text = res.jobData.jobTitle;
      jobDescription.text = res.jobData.jobDescription;
      jobEducation(res.jobData.jobEducation);
      jobQualification.text = res.jobData.jobQualification;
      res.jobData.jobExtExperience.forEach((experience) {
        jobExperience.add({
          "ExperienceTitle": experience.experienceTitle,
          "ExperienceMonth": experience.experienceMonth,
          "ExperienceYear": experience.experienceYear
        });
      });

      jobIndustry(res.jobData.jobIndustry);

      jobHiring.text = res.jobData.jobHiringCount;

      jobMinimumSalary.text = res.jobData.jobMinimumSalary;

      jobMaximumSalary.text = res.jobData.jobMaximumSalary;

      jobType(res.jobData.jobSchedule);

      res.jobData.jobKeySkills.forEach((skill) {
        jobSkills.add(skill);
      });

      Provider.of<SelectCompanyNotifier>(Get.context, listen: false).select(
          res.jobData.companyId,
          true,
          true,
          Data(
              companyId: res.jobData.company.companyId,
              companyName: res.jobData.company.companyName,
              companyEmail: res.jobData.company.companyEmail,
              companyAddress: res.jobData.company.companyAddress,
              companyDes: res.jobData.company.companyDes,
              companyLogo: res.jobData.company.companyLogo,
              companySlug: res.jobData.company.companySlug,
              companyStatus: res.jobData.company.companyStatus,
              companyWebsite: res.jobData.company.companyWebsite,
              verifiedCompany: res.jobData.company.verifiedCompany));
    } else {
      RemarkPageSetting.showSnackbar(title: 'Failed', message: res.message);
    }

    readyJobPosting(true);
  }

  fetchJobEducationList() async {
    educationList.clear();

    await EducationApi().fetchEducation().then((educations) {
      educations.data.forEach((education) {
        educationList.add(DropdownMenuItem(
          child: Text(
            "${education.educationName}",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          value: education.educationName,
        ));
      });
    });
  }

  fetchJobIndustries() async {
    industryList.clear();
    await IndustryApi().fetchIndustries().then((industries) {
      industries.data.forEach((industry) {
        industryList.add(DropdownMenuItem(
            child: Text("${industry.industryTitle}",
                style: GoogleFonts.poppins(color: Colors.black)),
            value: industry.industryId));
      });
    });
  }

  setJobEducation(value) {
    jobEducation(value.toString());
  }

  setJobIndustry(value) {
    jobIndustry(value.toString());
  }

  setJobType(value) {
    jobType(value.toString());
  }

  validateAndJsonJobExperience() {
    if (jobExperienceGlobalKey.currentState.validate()) {
      Map<String, dynamic> jobExp = {
        "ExperienceTitle": jobExperienceTitle.text,
        "ExperienceMonth": jobExperienceMonth.text,
        "ExperienceYear": jobExperienceYear.text
      };

      jobExperienceTitle.clear();
      jobExperienceMonth.clear();
      jobExperienceYear.clear();

      addJobExperience(jobExp);
    }
  }

  addJobExperience(Map<String, dynamic> experienceDetails) {
    jobExperience.add(experienceDetails);
  }

  removeJobExperienceAtIndex(index) {
    jobExperience.removeAt(index);
  }

  addSkillToSkillsList() {
    jobSkills.add(jobSkillInput.text);
    jobSkillInput.clear();
  }

  removeJobSkillIndex(index) {
    jobSkills.removeAt(index);
  }

  clearSkillsList() {
    jobSkills.clear();
    jobSkillInput.clear();
  }

  selectCompany(id) {
    jobCompanyId(id);
  }

  postJob() async {
    isPostingJob(true);

    var jobData = jsonEncode({
      "company_status": true,
      "company_id": jobCompanyId.value,
      "job_details": {
        "job_title": jobTitle.text,
        "job_description": jobDescription.text,
        "job_qualification": jobQualification.text,
        "job_education": jobEducation.value,
        "job_industry": jobIndustry.value,
        "job_hiring_count": jobHiring.text,
        "job_minimum_salary": jobMinimumSalary.text,
        "job_maximum_salary": jobMaximumSalary.text,
        "job_salary_type": "Per Year",
        "job_schedule": jobType.value,
        "job_ext_experience": jobExperience,
        "job_key_skills": jobSkills
      }
    });

    await PostJobApi().postJob(jobData).then((value) {
      if (value.status) {
        Get.showSnackbar(GetSnackBar(
          title: "Job Posted",
          message: "Your job will be live soon",
          duration: Duration(seconds: 2),
          snackStyle: SnackStyle.GROUNDED,
        ));

        resetJobPostForm();
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Job Posting Failed",
          message: value.message,
          duration: Duration(seconds: 2),
          snackStyle: SnackStyle.GROUNDED,
        ));
      }
    });

    isPostingJob(false);
  }

  updateJob() async {
    isPostingJob(true);

    var jobData = jsonEncode({
      "company_status": true,
      "company_id": jobCompanyId.value,
      "job_details": {
        "job_title": jobTitle.text,
        "job_description": jobDescription.text,
        "job_qualification": jobQualification.text,
        "job_education": jobEducation.value,
        "job_industry": jobIndustry.value,
        "job_hiring_count": jobHiring.text,
        "job_minimum_salary": jobMinimumSalary.text,
        "job_maximum_salary": jobMaximumSalary.text,
        "job_salary_type": "Per Year",
        "job_schedule": jobType.value,
        "job_ext_experience": jobExperience,
        "job_key_skills": jobSkills
      }
    });

    final res = await PostJobApi().updateJob(jobId.value, jobData);

    if (res.status) {
      final updatedJob = Job.fromJson(res.data);
      await updateToPostedJobs(updatedJob);

      Get.showSnackbar(GetSnackBar(
        title: "Job Updated",
        message: "Your updates will be live soon",
        duration: Duration(seconds: 2),
        snackStyle: SnackStyle.GROUNDED,
      ));
    } else {
      RemarkPageSetting.showSnackbar(
          title: 'Job Update Failed', message: res.message);
    }

    isPostingJob(false);
  }

  updateToPostedJobs(Job updatedJob) async {
    List<Job> updatedJobList = <Job>[];
    postedJobs.forEach((job) {
      if (job.jobId == updatedJob.jobId) {
        job = updatedJob;
      }

      updatedJobList.add(job);
    });

    postedJobs.clear();
    postedJobs.assignAll(updatedJobList);
  }

  resetJobPostForm() async {
    jobTitle.clear();
    jobDescription.clear();
    jobEducation("BCOM");
    jobQualification.clear();
    jobIndustry("");
    jobHiring.clear();
    jobMinimumSalary.clear();
    jobMaximumSalary.clear();
    jobType("Full Time");
    jobSkills.clear();
    jobExperience.clear();
    jobCompanyId("0");
  }
}
