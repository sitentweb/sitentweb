import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remark_app/apis/jobs/fetch_posted_jobs.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/posted_jobs_model.dart';
import 'package:remark_app/pages/template/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostedJobs extends StatefulWidget {
  const PostedJobs({Key key}) : super(key: key);

  @override
  _PostedJobsState createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var userID;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                          child: FutureBuilder<PostedJobsModel>(
                        future: FetchPostedJobs().fetchPostedJobs(userID),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data.data.length,
                              itemBuilder: (context, index) {
                                var job = snapshot.data.data[index];

                                return Container(
                                  child: JobCard(
                                    userID: userID,
                                    jobID: job.jobId,
                                    jobTitle: job.jobTitle,
                                    companyImage: job.companyLogo,
                                    companyName: job.companyName,
                                    minimumSalary: job.jobMinimumSalary,
                                    maximumSalary: job.jobMaximumSalary,
                                    experience: job.jobExtExperience.isNotEmpty
                                        ? "Experienced"
                                        : "Fresher",
                                    jobSkills: job.jobKeySkills,
                                    companyLocation: job.companyAddress,
                                    timeAgo: '2 hours ago',
                                    jobLink: 'www.google.com',
                                    isUserApplied: true,
                                    isUserSavedThis: false,
                                    applyBtn: 0,
                                  ),
                                );
                              },
                            );
                          } else {
                            return CircularLoading();
                          }
                        },
                      )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
