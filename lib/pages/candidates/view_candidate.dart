import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/candidates/fetch_candidate_api.dart';
import 'package:remark_app/apis/conversation/get_all_rooms.dart';
import 'package:remark_app/apis/jobs/applied_jobs.dart';
import 'package:remark_app/apis/jobs/fetch_posted_jobs.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/components/tutorial/tutorial_content.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/fetch_candidate.dart';
import 'package:remark_app/model/conversation/create_chat_room_model.dart';
import 'package:remark_app/model/jobs/posted_jobs_model.dart';
import 'package:remark_app/pages/conversation/chat_screen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewCandidate extends StatefulWidget {
  final userUserName;
  final jobID;
  const ViewCandidate({Key key, this.userUserName, this.jobID}) : super(key: key);

  @override
  _ViewCandidateState createState() => _ViewCandidateState();
}

class _ViewCandidateState extends State<ViewCandidate> {

  GlobalKey _showCandidateMenuKey = GlobalKey();
  GlobalKey _hireButtonKey = GlobalKey();

  List<TargetFocus> _targets = <TargetFocus>[];

  bool applyStatus = false;
  var userToken;
  var userID;
  Future<FetchCandidateModel> _fetchCandidateModel;

  _callCandidate(mobileNumber) async {
    var url = "tel:$mobileNumber";
    await canLaunch(url) ? await launch(url) : print("Cant Launch this");
  }

  _mailCandidate(String email) async {
    var mail;
    if (email.isNotEmpty) {
      var url = "mailto:$email";
      await canLaunch(url) ? await launch(url) : print("Can't launch url");
    }
  }

  saveTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("viewCandidateTutorial", true);
  }

  void initTargets() {
    _targets.add(TargetFocus(
        identify: "Menus",
        targetPosition: TargetPosition(
          Size(25 , 25),
          Offset(320, 70)
        ),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CustomTutorialContent(
                title: "More Options",
                content: "Here you will get more options to Call or Email this candidate, Schedule an Interview & Take a Quick Test of this Candidate",
              );
            },
          )
        ]
    ));
    _targets.add(TargetFocus(
        identify: "Hire",
        keyTarget: _hireButtonKey,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) => CustomTutorialContent(title: "Hire Candidate", content: "You can direct hire this candidate",)
          )
        ]
    ));
  }

  void showTutorial() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    bool tut = pref.get("viewCandidateTutorial") != null ? pref.getBool("viewCandidateTutorial") ?? false : false;
    print(tut);
    tut = false;
    if(!tut){
      initTargets();
      TutorialCoachMark(
        context,
        targets: _targets,
        colorShadow: kLightColor,
        textSkip: "Skip",
        alignSkip: Alignment.bottomLeft,
        skipWidget: Container(
          padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 30
          ),
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Text("Skip" , style: GoogleFonts.poppins(
              color: kDarkColor
          ),),
        ),
        onFinish: () {
          saveTutorial();
        },
        onClickTarget: (target) => print('on click target: $target'),
        onSkip: () {
          saveTutorial();
        },
        onClickOverlay: (target) => print('overlay clicked : $target'),
      ).show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    showTutorial();
    fetchCandidateDetails();
    super.initState();
  }

  fetchCandidateDetails() {

   setState(() {
     _fetchCandidateModel = FetchCandidate().fetchCandidate(widget.jobID , widget.userUserName);
   });

  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userToken = pref.getString("userToken");
      userID = pref.getString("userID");
    });
  }


  _changeAppliedJobStatus(status , employeeID , jobID , employerID) async {

     await AppliedJobsApi().updateJobApplied(employeeID, jobID, employerID, status).then((value) {
       print("Status Changed");
     });

  }

  _startChat(String employeeID , employeeName , employeePhoto) async {
    CreateChatRoomModel _chatRoom = await GetRoom().createChatRoom(userID, employeeID);

    print(createChatRoomModelToJson(_chatRoom));

    if(_chatRoom.status){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(imageHero: "", roomId: _chatRoom.roomId, receiverID: userID, senderID: employeeID, userName: employeeName, userImage: employeePhoto,)));
    }

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<FetchCandidateModel>(
          future: _fetchCandidateModel,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            } else if (snapshot.hasData) {
              if (snapshot.data.status) {
                var employee = snapshot.data.data;

                applyStatus = employee.candidateHire == "1" ? true : false;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 40),
                        height: size.height * 0.20,
                        decoration: BoxDecoration(
                            color: kDarkColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: AvatarGlow(
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                          backgroundImage: employee
                                                  .userPhoto.isNotEmpty
                                              ? NetworkImage(
                                                  "${base_url}/${employee.userPhoto}")
                                              : AssetImage(
                                                  "$application_logo"),
                                        ),
                                        endRadius: 30),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 18),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${employee.userName}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                          Text(
                                            employee.userMobile,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 10),
                                    child: IconCircleButton(
                                      key: _showCandidateMenuKey,
                                      backgroundColor: kLightColor,
                                      radius: 40,
                                      iconSize: 8,
                                      icon: FontAwesomeIcons.ellipsisV,
                                      iconColor: Colors.white,
                                      onPressed: () => showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight:
                                                Radius.circular(20))),
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.all(8),
                                            width: size.width,
                                            height: size.height * 0.35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.only(
                                                    topLeft:
                                                    Radius.circular(
                                                        20),
                                                    topRight:
                                                    Radius.circular(
                                                        20))),
                                            child: ListView(
                                              children: [
                                                ListTile(
                                                  title: Text("Call" , style: GoogleFonts.poppins(),),
                                                  onTap: () => _callCandidate(employee.userMobile),
                                                  leading: Icon(Icons.phone),
                                                ),
                                                ListTile(
                                                  title: Text("Mail" , style: GoogleFonts.poppins(),),
                                                  leading: Icon(Icons.mail),
                                                  onTap: () => _mailCandidate(employee.userEmail),
                                                ),
                                                ListTile(
                                                  title: Text("Start Chat" , style: GoogleFonts.poppins(),),
                                                  leading: Icon(Icons.message),
                                                  onTap: () => _startChat(employee.userId , employee.userName , employee.userPhoto),
                                                ),
                                                ListTile(
                                                  title: Text("Schedule Interview" , style: GoogleFonts.poppins(),),
                                                  leading: Icon(Icons.computer),
                                                ),
                                                ListTile(
                                                  title: Text("Take a Quick Test" , style: GoogleFonts.poppins(),),
                                                  leading: Icon(Icons.article),
                                                ),
                                                ListTile(
                                                  title: Text("Share Candidate" , style: GoogleFonts.poppins(),),
                                                  leading: Icon(Icons.share),
                                                  onTap: () async {
                                                    Share.share("Check this candidate " , subject: "${employee.userName}");
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            CandidateDetails(
                              title: "Bio",
                              value: employee.userBio ?? "",
                            ),
                            CandidateDetails(
                              title: "Skills",
                              value: employee.userSkills ?? "",
                            ),
                            CandidateDetails(
                              title: "Experience",
                              value: employee.userExperience ?? "",
                            ),
                            CandidateDetails(
                              title: "Qualification",
                              value: employee.userQualifications ?? "",
                            ),
                            CandidateDetails(
                              title: "Language",
                              value: employee.userLanguages ?? "",
                            ),
                            CandidateDetails(
                              title: "Location",
                              value: employee.userLocation ?? "",
                            ),
                            CandidateDetails(
                              title: "With Remark Since",
                              value: timeago.format(employee.userCreatedAt),
                            ),
                            Divider(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  MaterialButton(
                                      onPressed: () => print("Report"),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Report')
                                        ],
                                      )),
                                  Spacer(),
                                  widget.jobID != "0" ? employee.candidateHire == "0" ? MaterialButton(
                                    onPressed: () {
                                      if(widget.jobID != "0"){
                                        setState(() {
                                          employee.candidateHire = "3";
                                        });

                                        _changeAppliedJobStatus("3" , employee.userId , widget.jobID , userID);

                                      }



                                    },
                                    child: Row(
                                      children: [

                                        Icon(Icons.close , color: Colors.redAccent,),
                                        Text("Reject" , style: TextStyle(
                                          color: Colors.redAccent
                                        ),)
                                      ],
                                    ),
                                  ) : Container() : Container(),
                                  SizedBox(width: 5,),
                                  employee.candidateHire == "0" ? MaterialButton(
                                    key: _hireButtonKey,
                                    color: kDarkColor,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                       if(widget.jobID != "0"){
                                         setState(() {
                                           employee.candidateHire = "1";
                                         });

                                         _changeAppliedJobStatus("1" , employee.userId , widget.jobID , userID);
                                       }else{
                                         Future<PostedJobsModel> jobList = FetchPostedJobs().fetchPostedJobs(userID);
                                         var jobID;
                                         showMaterialModalBottomSheet(context: context,
                                             builder: (context) => Scaffold(
                                               body: SafeArea(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Container(
                                                       padding: EdgeInsets.all(10),
                                                       child: Text("Select a job" , style: GoogleFonts.poppins(
                                                         fontSize: 16,
                                                         fontWeight: FontWeight.bold
                                                       ),),
                                                     ),
                                                     Expanded(
                                                       child: Container(
                                                         child: FutureBuilder<PostedJobsModel>(
                                                           future: jobList,
                                                           builder: (context, snapshot) {
                                                             if(snapshot.hasData){
                                                               return ListView.builder(
                                                                   itemCount: snapshot.data.data.length,
                                                                   itemBuilder: (context, index) {
                                                                      var job = snapshot.data.data[index];
                                                                      return ListTile(
                                                                        onTap: () {
                                                                          Navigator.pop(context);
                                                                          setState(() {
                                                                            jobID = job.jobId;
                                                                            employee.candidateHire = "1";
                                                                          });

                                                                          print("1");
                                                                          print(employee.userId);
                                                                          print(jobID);
                                                                          print(userID);

                                                                          _changeAppliedJobStatus("1" , employee.userId , jobID , userID);
                                                                        },
                                                                        title: Text("${job.jobTitle}" ,style: GoogleFonts.poppins(),),
                                                                        leading: CircleAvatar(
                                                                          radius: 25,
                                                                          backgroundColor: Colors.white,
                                                                          backgroundImage: AppSetting.showUserImage("${job.companyLogo}"),
                                                                        ),
                                                                        subtitle: Text("${job.companyName}" , style: GoogleFonts.poppins(),),
                                                                      );
                                                                   },
                                                               );
                                                             }else{
                                                               return CircularLoading();
                                                             }
                                                           },
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),);



                                       }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.check),
                                        SizedBox(width: 3,),
                                        Text("Hire" , style: GoogleFonts.poppins(),),
                                      ],
                                    ),
                                  ) : Text(employee.candidateHire == "1" ? "Hired" : employee.candidateHire == "3" ? "Rejected" : "" , style: GoogleFonts.poppins(
                                    color: employee.candidateHire == "1" ? kDarkColor : employee.candidateHire == "3" ? Colors.redAccent : Colors.grey,
                                    fontWeight: FontWeight.bold
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return EmptyData(
                  message: "Candidate not found",
                );
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: CircularLoading(),
            );
          },
        ),
      ),
    );
  }
}

class CandidateDetails extends StatelessWidget {
  final title;
  final String value;
  const CandidateDetails({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            Text(value.isNotEmpty ? value : "" , style: GoogleFonts.poppins(),)
          ],
        ));
  }
}
