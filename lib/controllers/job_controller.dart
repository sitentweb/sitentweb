import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remark_app/apis/jobs/all_jobs.dart';
import 'package:remark_app/config/pageSetting.dart';
import 'package:remark_app/model/jobs/job_list_model.dart';

class JobController extends GetxController {
  RxList<Job> jobList = <Job>[].obs;
  RxList<Job> searchedJobList = <Job>[].obs;
  RxInt jobOffset = 0.obs;
  RxBool showRegisterAs = false.obs;
  ScrollController scrollController = ScrollController();
  RxBool isJobFetched = false.obs;
  RxBool isFetchingJob = true.obs;
  final storage = GetStorage();
  final pageSize = 10;
  RxBool isSearchEnabled = false.obs;
  dynamic searchData = {};

  init() {
    fetchLimitJobs();
    addJobsToList();
  }

  addJobsToList() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        fetchLimitJobs();
        update();
      }
    });
  }

  Future fetchLimitJobs() async {
    var token = storage.read('jwtToken');
    final res = await AllJobs().fetchLimitJobs(jobOffset.value, token: token);

    if (res.status) {
      showRegisterAs(res.showRegister);
      res.jobs.forEach((job) => {jobList.add(job)});
      jobOffset.value = jobList.length + jobOffset.value;
      jobOffset.refresh();
      jobList.refresh();
    } else {
      print(res.message);
      RemarkPageSetting.showSnackbar(title: 'Error', message: res.message);
    }

    isJobFetched(true);
    isFetchingJob(false);
  }

  Future searchJobs(title, skills, location) async {
    print("Searching");
    print({"title": title, "skills": skills, "location": location});
    isSearchEnabled(true);

    isJobFetched(false);
    isFetchingJob(true);

    var token = storage.read('jwtToken');
    final response =
        await AllJobs().getSearchJobs(token, title, skills, location);

    if (response.status) {
      searchedJobList.clear();

      response.jobs.forEach((job) {
        searchedJobList.add(job);
      });
    }

    isFetchingJob(false);
    isJobFetched(true);
    // update();
  }

  reset() {
    isSearchEnabled(false);
    isJobFetched(true);
    isFetchingJob(false);
  }
}
