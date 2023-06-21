import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:remark_app/apis/jobs/all_jobs.dart';
import 'package:remark_app/components/appbar/empty_appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/job_card/job_card_shimmer.dart';
import 'package:remark_app/components/user/register_buttons.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/controllers/job_controller.dart';
import 'package:remark_app/model/jobs/all_jobs_model.dart';
import 'package:remark_app/model/jobs/job_list_model.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';

class Jobs extends StatefulWidget {
  final bool isSearch;
  final List searchData;
  const Jobs({Key key, this.isSearch, this.searchData}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  JobController jobController = Get.put(JobController());
  bool isSearching = false;
  bool isJobFetched = true;
  var userID;
  var userType;
  SharedPreferences pref;
  // int _pageSize = 10;

  final PagingController<int, Job> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    jobController.init();
    super.initState();
  }

  Future<void> _fetchPage(int offset) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userID = pref.getString("userID");

    try {
      List<Job> jobs;

      if (isSearching) {
        print("Searching Data");

        var title = widget.searchData[0];
        var skills = widget.searchData[1];
        var range = widget.searchData[2];
        var location = widget.searchData[3];

        if (location == "Select Location") {
          location = "";
        }

        await AllJobs()
            .getSearchJobs(userID, title, skills, location)
            .then((value) {
          print(value.jobs.toList());
          if (value.status) {
            jobs = value.jobs;
          } else {
            setState(() {
              isJobFetched = false;
            });
          }
        });
      } else {
        await jobController.fetchLimitJobs();
      }

      final isLastPage = jobController.jobList.length <= jobController.pageSize;
      log(isLastPage.toString(), name: 'IS LAST PAGE');
      if (isLastPage) {
        _pagingController.appendLastPage(jobController.jobList);
      } else {
        final nextOffset = offset + jobController.jobList.length;
        _pagingController.appendPage(jobController.jobList, nextOffset);
        log(nextOffset.toString(), name: 'NEXT OFFSET');
      }
    } catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: jobController.isSearchEnabled.isTrue
          ? AppBar(
              iconTheme: IconThemeData.fallback(),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Hero(
                  tag: "splashscreenImage",
                  child: Container(
                      child: Image.asset(
                    application_logo,
                    width: 40,
                  ))),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchJobs(),
                          ));
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.search,
                          color: kDarkColor,
                        )))
              ],
            )
          : EmptyAppBar(),
      body: SafeArea(
        child: Obx(() {
          print(jobController.jobList.length);
          return Container(
            child: Column(
              children: [
                if (jobController.showRegisterAs.isTrue) RegisterAs(),
                Expanded(
                  child: jobController.isFetchingJob.isFalse
                      ? jobController.jobList.length != 0
                          ? ListView.builder(
                              controller: jobController.scrollController,
                              itemCount: jobController.isSearchEnabled.isFalse
                                  ? jobController.jobList.length
                                  : jobController.searchedJobList.length,
                              addAutomaticKeepAlives: true,
                              itemBuilder: (context, index) {
                                var job = jobController.isSearchEnabled.isFalse
                                    ? jobController.jobList[index]
                                    : jobController.searchedJobList[index];

                                return JobCard(
                                  jobID: job.jobId,
                                  userID: job.company.userId,
                                  jobTitle: job.jobTitle,
                                  companyImage: job.company.companyLogo,
                                  companyName: job.company.companyName,
                                  minimumSalary: job.jobMinimumSalary,
                                  maximumSalary: job.jobMaximumSalary,
                                  experience: job.jobExtExperience,
                                  jobSkills: job.jobKeySkills,
                                  companyLocation: job.company.companyAddress,
                                  timeAgo: timeago.format(job.jobCreatedAt),
                                  jobLink: job.jobSlug,
                                  isUserApplied:
                                      job.isUserApplied == "4" ? false : true,
                                  isUserSavedThis: false,
                                  // job.jobSaved == "0" ? false : true,
                                  applyBtn: job.appliedStatus == null
                                      ? 4
                                      : int.parse(job.appliedStatus),
                                );
                              },
                            )
                          : Center(
                              child: EmptyData(
                                message: "No Jobs Found",
                              ),
                            )
                      : Container(
                          height: Get.height,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer(),
                                JobCardShimmer()
                              ],
                            ),
                          ),
                        ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
