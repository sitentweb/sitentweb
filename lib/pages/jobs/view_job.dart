import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:remark_app/apis/jobs/similar_jobs_api.dart';
import 'package:remark_app/apis/jobs/view_job.dart';
import 'package:remark_app/components/buttons/apply_button.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/job_card/job_card.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/similar_jobs_model.dart';
import 'package:remark_app/model/jobs/view_job_model.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ViewJob extends StatefulWidget {
  final jobID;
  final userID;
  const ViewJob({Key key, this.jobID, this.userID}) : super(key: key);

  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  var userType;

  bool userSaved = false;

  Future<bool> userSavedThis(bool isLiked) async {
    setState(() {
      userSaved = !userSaved;
    });
    return !isLiked;
  }

  // _saveThis() {
  //   setState(() {
  //     userSaved = true;
  //   });
  // }

  // _unsaveThis() {
  //   setState(() {
  //     userSaved = false;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: FutureBuilder<ViewJobModel>(
        future: ViewJobApi().getJob(widget.userID, widget.jobID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.status) {
              var job = snapshot.data.data;
              print(job.jobKeySkills);
              print(widget.userID);
              print(job.jobId);
              // JOB KEY SKILL JOINED
              var jobSkillList = jsonDecode(job.jobKeySkills);
              var jobSkills = jobSkillList.join(",");

              if (job.jobSaveStatus == "0") {
                userSaved = true;
              } else {
                userSaved = false;
              }

              // JOB EXPERIENCE
              List jobExperienceList = jsonDecode(job.jobExtExperience);
              List expDetails = [];
              String finalExp;

              jobExperienceList.forEach((element) {
                expDetails.add(
                    "${element["ExperienceTitle"]} (${element["ExperienceYear"]} years, ${element["ExperienceMonth"]} months)");
              });

              finalExp = expDetails.join("\n");

              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    alignment: Alignment.topLeft,
                    height: size.height * 0.2,
                    decoration: BoxDecoration(color: kDarkColor),
                    child: Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: Text(
                              job.jobTitle,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              var jobLink =
                                  "https://remarkblehr.in/job-listing-${job.jobSlug}";
                              Share.share("Check out this job $jobLink",
                                  subject: "${job.jobTitle}");
                            },
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        // Icon(Icons.bookmark, color: job.jobSaveStatus == "0" ? Colors.white.withOpacity(0.5) : Colors.white,)
                        LikeButton(
                          size: 20,
                          onTap: userSavedThis,
                          circleColor:
                              CircleColor(start: kLightColor, end: kDarkColor),
                          bubblesColor: BubblesColor(
                              dotPrimaryColor: kLightColor,
                              dotSecondaryColor: kDarkColor,
                              dotLastColor: Colors.greenAccent),
                          likeBuilder: (isLiked) {
                            return Icon(
                              Icons.bookmark,
                              color: userSaved
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              size: 20,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          width: size.width,
                          height: size.height * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () => print("Company Details"),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      AvatarGlow(
                                          shape: BoxShape.circle,
                                          curve: Curves.fastOutSlowIn,
                                          animate: true,
                                          repeat: true,
                                          duration: Duration(milliseconds: 1000),
                                          glowColor: kDarkColor,
                                          showTwoGlows: true,
                                          child: Material(
                                            elevation: 2,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AppSetting.showUserImage(job.companyLogo),
                                            ),
                                          ),
                                          endRadius: 30),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          job.companyName,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              TextLable("Salary",
                                  "${job.jobMinimumSalary} - ${job.jobMaximumSalary} PA"),
                              TextLable("Skills", jobSkills),
                              TextLable("Experience", finalExp),
                              TextLable("Education", job.jobQualification),
                              TextLable("Industry", job.jobIndustryName),
                              TextLable("Description", job.jobDescription),
                              Divider(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    MaterialButton(
                                      onPressed: () => print("clicked"),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Report" , style: GoogleFonts.poppins(),)
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    if (userType == "1")
                                      ApplyButton(
                                        onTap: () {
                                          if(int.parse(job.jobAppliedStatus) == 4){

                                          }else{
                                            print("nothing here");
                                          }
                                        },
                                        padding: EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 35),
                                        abtnType: int.parse(job.jobAppliedStatus),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Similar Jobs" , style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width,
                                height: 260,
                                child: FutureBuilder<SimilarJobsModel>(
                                  future: SimilarJobsApi().similarJobs(job.jobKeySkills, job.jobId , widget.userID),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      if(snapshot.data.status){
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.data.length,
                                          itemBuilder: (context, index) {
                                            var sjob = snapshot.data.data[index];
                                            return JobCard(
                                              userID: sjob.userId,
                                              jobID: sjob.jobId,
                                              companyImage: sjob.companyLogo,
                                              jobTitle: sjob.jobTitle,
                                              applyBtn: int.parse(sjob.jobAppliedStatus),
                                              companyLocation: sjob.companyAddress,
                                              companyName: sjob.companyName,
                                              experience: sjob.jobExtExperience,
                                              isUserApplied: false,
                                              isUserSavedThis: sjob.jobSaved == "0" ? false : true,
                                              jobLink: "https://remarkablehr.in/job-listing-${sjob.jobSlug}",
                                              jobSkills: sjob.jobKeySkills,
                                              maximumSalary: sjob.jobMaximumSalary,
                                              minimumSalary: sjob.jobMinimumSalary,
                                              timeAgo: timeAgo.format(sjob.jobCreatedAt),
                                            );
                                          },
                                        );
                                      }else{
                                        return EmptyData(
                                          message: "No Similar Jobs",
                                        );
                                      }
                                    }else if(snapshot.hasError){
                                      return Text("${snapshot.error}");
                                    }else{
                                      return CircularLoading();
                                    }
                                  },
                                ),
                              )
                            ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else
              return Center(
                child: Text("Data not Fount"),
              );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          } else {
            return Center(
              child: CircularLoading(),
            );
          }

        },
      ),
    );
  }

  Widget TextLable(title, value) {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                color: kDarkColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            value,
            style: GoogleFonts.poppins(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
