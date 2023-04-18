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
import 'package:remark_app/model/jobs/all_jobs_model.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Jobs extends StatefulWidget {
  final bool isSearch;
  final List searchData;
  const Jobs({Key key, this.isSearch, this.searchData}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  bool isSearching = false;
  bool isJobFetched = true;
  var userID;
  var userType;
  SharedPreferences pref;
  int _pageSize = 10;

  final PagingController<int, JobList> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    isSearching = widget.isSearch;
    _pagingController.addPageRequestListener((offset) {
      print("fetching pages");
      _fetchPage(offset);
    });
    super.initState();
  }

  Future<void> _fetchPage(int offset) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userID = pref.getString("userID");

    try {
      List<JobList> jobs;

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
            .getSearchJobs(userID, title, skills, range, location)
            .then((value) {
          print(value.data.toJson());
          if (value.status) {
            jobs = value.data.jobList;
          } else {
            setState(() {
              isJobFetched = false;
            });
          }
        });
      } else {
        await AllJobs().fetchAllJobs(userID, offset.toString()).then((value) {
          if (value.data.status) {
            jobs = value.data.jobList;
          } else {
            setState(() {
              isJobFetched = false;
            });
          }
        });
      }

      final isLastPage = jobs.length <= _pageSize;
      log(isLastPage.toString(), name: 'IS LAST PAGE');
      if (isLastPage) {
        _pagingController.appendLastPage(jobs);
      } else {
        final nextOffset = offset + jobs.length;
        _pagingController.appendPage(jobs, nextOffset);
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
  dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isSearch
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
        child: Container(
          child: Column(
            children: [
              if (userType == "0") RegisterAs(),
              Expanded(
                child: isJobFetched
                    ? Container(
                        child: PagedListView(
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<JobList>(
                              itemBuilder: (context, item, index) {
                                var job = item;
                                return JobCard(
                                  jobID: job.jobId,
                                  userID: job.userId,
                                  jobTitle: job.jobTitle,
                                  companyImage: job.companyLogo,
                                  companyName: job.companyName,
                                  minimumSalary: job.jobMinimumSalary,
                                  maximumSalary: job.jobMaximumSalary,
                                  experience: job.jobExtExperience,
                                  jobSkills: job.jobKeySkills,
                                  companyLocation: job.companyAddress,
                                  timeAgo: timeago.format(job.jobCreatedAt),
                                  jobLink: job.jobSlug,
                                  isUserApplied: true,
                                  isUserSavedThis:
                                      job.jobSaved == "0" ? false : true,
                                  applyBtn: int.parse(job.jobAppliedStatus),
                                );
                              },
                              firstPageProgressIndicatorBuilder: (_) =>
                                  Container(
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
                                  )),
                        ),
                      )
                    : Center(
                        child: EmptyData(
                          message: "No Jobs Found",
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
