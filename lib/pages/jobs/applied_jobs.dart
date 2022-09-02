import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/jobs/applied_jobs.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/job_card/job_card_shimmer.dart';
import 'package:remark_app/components/user/register_buttons.dart';
import 'package:remark_app/model/jobs/applied_jobs_model.dart';
import 'package:remark_app/pages/jobs/view_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class AppliedJobs extends StatefulWidget {
  const AppliedJobs({Key key}) : super(key: key);

  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  var userID;
  var userType;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              if (userType == "0") RegisterAs(),
              Expanded(
                  child: Container(
                child: FutureBuilder<AppliedJobsModel>(
                  future: AppliedJobsApi().fetchAppliedJobs(userID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.status) {
                        return ListView.builder(
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            var job = snapshot.data.data[index];
                            return GestureDetector(
                              onTap: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (context) => ViewJob(
                                    userID: userID,
                                    jobID: job.jobId,
                                  ),
                                );
                              },
                              child: JobCard(
                                jobID: job.jobId,
                                userID: job.userId,
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
                                timeAgo: timeAgo.format(job.jobCreatedAt),
                                jobLink: job.jobSlug,
                                isUserApplied: true,
                                isUserSavedThis: false,
                                applyBtn: int.parse(job.jobAppliedStatus),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: EmptyData(
                            message: "Not applied for any job",
                          ),
                        );
                      }
                    } else {
                      return ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) => JobCardShimmer());
                    }
                  },
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
