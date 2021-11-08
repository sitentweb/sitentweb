import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/jobs/job_apply_status.dart';
import 'package:remark_app/apis/jobs/save_jobs_api.dart';
import 'package:remark_app/components/buttons/apply_button.dart';
import 'package:remark_app/components/text/IconText.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/save_jobs_model.dart';
import 'package:remark_app/pages/jobs/view_job.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCard extends StatefulWidget {
  final jobID;
  final String userID;
  final String jobTitle;
  final String companyImage;
  final String companyName;
  final String minimumSalary;
  final String maximumSalary;
  final String experience;
  final String jobSkills;
  final String companyLocation;
  final String timeAgo;
  final String jobLink;
  final bool isUserApplied;
  final bool isUserSavedThis;
  final int applyBtn;

  const JobCard(
      {Key key,
      this.jobTitle,
      this.companyImage,
      this.companyName,
      this.minimumSalary,
      this.maximumSalary,
      this.experience,
      this.companyLocation,
      this.timeAgo,
      this.jobLink,
      this.jobSkills,
      this.applyBtn,
      this.isUserApplied,
      this.isUserSavedThis = false,
      this.jobID,
      this.userID})
      : super(key: key);

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  var userType;
  bool userApplied = false;
  bool userSaved = false;
  int appliedBtn;
  var userResume;
  var userUsername;
  var userID;
  var jobSkills;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobSkills();
    userApplied = widget.isUserApplied ? true : false;
    appliedBtn = widget.applyBtn ?? 0;
    userSaved = widget.isUserSavedThis ?? false;
    getUserData();
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userType = pref.getString("userType");
      userResume = pref.getString("userResume");
      userUsername = pref.getString("userUsername");
      userID = pref.getString("userID");
    });
  }

  getJobSkills() async {
    var skills = "";
     if(widget.jobSkills.isNotEmpty){
       var decode = jsonDecode(widget.jobSkills);
       skills = decode.join(",");
     }else{
       skills = "";
     }

     setState(() {
       jobSkills = skills;
     });
  }

  Future<bool> userSavedThis(bool isLiked) async {
    SaveJobsModel saveJob = await SaveJobsApi().saveJobs(userID, widget.jobID);

    saveJob.status ? print(saveJob.data) : print("error");

    setState(() {
      userSaved = !userSaved;
    });
    return !isLiked;
  }

  Future<bool> userSharedThis(bool isLiked) async {
    Share.share("Check out this job https://remarkablehr.in/job-listing-${widget.jobLink}",
        subject: "${widget.jobTitle}");
    return !isLiked;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 260,
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () => showMaterialModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) => ViewJob(
                          jobID: widget.jobID,
                          userID: widget.userID,
                        )),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.jobTitle,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              backgroundImage: AppSetting.showUserImage(widget.companyImage),
                              radius: 10,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                widget.companyName,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconText(
                            title:
                                '${widget.minimumSalary} - ${widget.maximumSalary} PA',
                            icon: FontAwesomeIcons.rupeeSign,
                            width: 150,
                          ),
                          Spacer(),
                          IconText(
                            title: widget.experience.isNotEmpty ? 'Experienced' : 'Fresher',
                            icon: Icons.add,
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IconText(
                        title: jobSkills ?? "",
                        icon: Icons.thumb_up,
                        width: 250,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconText(
                            title: widget.companyLocation,
                            icon: Icons.location_on,
                            width: 150,
                          ),
                          Spacer(),
                          Text(
                            widget.timeAgo,
                            style: GoogleFonts.poppins(color: Colors.grey , fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  LikeButton(
                    size: 25,
                    onTap: userSharedThis,
                    circleColor:
                        CircleColor(start: kLightColor, end: kDarkColor),
                    bubblesColor: BubblesColor(
                        dotPrimaryColor: kLightColor,
                        dotSecondaryColor: kDarkColor,
                        dotLastColor: Colors.greenAccent),
                    likeBuilder: (isLiked) {
                      return Icon(
                        Icons.share,
                        size: 25,
                        color: Colors.grey,
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  LikeButton(
                    size: 25,
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
                        color: userSaved ? kLightColor : Colors.grey[600],
                        size: 25,
                      );
                    },
                  ),
                  Spacer(),
                  userType == "1"
                      ? ApplyButton(
                          onTap: () =>
                              showApplyDialog(widget.jobTitle, widget.jobID),
                          abtnType: appliedBtn,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        )
                      : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showApplyDialog(jobTitle, jobID) async {
    try {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Apply for this job?" , style: GoogleFonts.poppins(),),
            content: Text("$jobTitle"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("No" , style: GoogleFonts.poppins(),)),
              TextButton(
                  onPressed: () async {
                    if (userResume != null ||
                        userResume.toString().isNotEmpty) {

                      await JobApplyStatusApi()
                          .jobApplyStatus(jobID, userID , widget.userID)
                          .then((response) {
                        if (response.status) {
                          print(widget.userID);
                          print("Applied for this job");
                          userAppliedThisJob();
                        } else {
                          var snackBar = SnackBar(
                            content: Text(
                                "Something went wrong. please again later" , style: GoogleFonts.poppins(),),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    } else {
                      var snackBar = SnackBar(
                        content: Text("Upload Resume first" , style: GoogleFonts.poppins(),),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Yes" , style: GoogleFonts.poppins(),)),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  userAppliedThisJob() {
    setState(() {
      userApplied = true;
      appliedBtn = 0;
    });
  }
}
