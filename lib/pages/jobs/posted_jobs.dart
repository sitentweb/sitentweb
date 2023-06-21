import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remark_app/apis/jobs/fetch_posted_jobs.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/job_card/job_card_shimmer.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/controllers/jobs/post_job_controller.dart';
import 'package:remark_app/model/jobs/posted_jobs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostedJobs extends StatefulWidget {
  const PostedJobs({Key key}) : super(key: key);

  @override
  _PostedJobsState createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  PostJobController postJobController = Get.put(PostJobController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var userID;

  @override
  void initState() {
    // TODO: implement initState
    postJobController.initFetchPostedJobs();
    super.initState();
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: SafeArea(child: Obx(() {
        if (postJobController.isLoadingPostedJobs.isFalse) {
          if (postJobController.postedJobs.length > 0) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              child: ListView.builder(
                            itemCount: postJobController.postedJobs.length,
                            itemBuilder: (context, index) {
                              var job = postJobController.postedJobs[index];
                              return Container(
                                child: JobCard(
                                  userID: userID,
                                  jobID: job.jobId,
                                  jobTitle: job.jobTitle,
                                  companyImage: job.company.companyLogo,
                                  companyName: job.company.companyName,
                                  minimumSalary: job.jobMinimumSalary,
                                  maximumSalary: job.jobMaximumSalary,
                                  experience: job.jobExtExperience.isNotEmpty
                                      ? "Experienced"
                                      : "Fresher",
                                  jobSkills: job.jobKeySkills,
                                  companyLocation: job.company.companyAddress,
                                  timeAgo: '2 hours ago',
                                  jobLink: 'www.google.com',
                                  isUserApplied: true,
                                  isUserSavedThis: false,
                                  applyBtn: 0,
                                  isEditable: true,
                                ),
                              );
                            },
                          )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: EmptyData(
              message: "No Job Posted \n Please post atleast one job",
            ));
          }
        }

        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => JobCardShimmer(),
        );
      })),
    );
  }
}
