import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/candidates/all_candidates_api.dart';
import 'package:remark_app/components/candidate_card.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/components/tutorial/tutorial_content.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/all_candidates.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Candidates extends StatefulWidget {
  final bool isSearched;
  final List data;
  const Candidates({Key key, this.data , this.isSearched}) : super(key: key);

  @override
  _CandidatesState createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates> {

  GlobalKey _candidateCard = GlobalKey();
  GlobalKey _saveCandidate = GlobalKey();

  List<TargetFocus> _targets = <TargetFocus>[];
  var userID;
  Future<AllCandidatesModel> _candidatesList;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    showTutorial();
    super.initState();
  }

  saveTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("dashboardTutorial", true);

  }

  void initTargets() {
    _targets.add(TargetFocus(
        identify: "Target 0",
        targetPosition: TargetPosition(
            Size(200 , 100),
            Offset(85 , 100)
        ),
        enableTargetTab: true,
        contents: [
          TargetContent(
            builder: (context, controller) {
              return CustomTutorialContent(
                verticalPadding: 50,
                title: "Chart Analysis",
                content: "This chart will analyze your Jobs, Company, Questionnaire & Interviews",
              );
            },
          )
        ]
    ));
    _targets.add(TargetFocus(
        identify: "Candidate",
        keyTarget: _candidateCard,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            builder: (context, controller) {
              return CustomTutorialContent(
                title: "Candidate",
                content: "Here is a candidate with Name, Location, Skills, Experience, On Tapping this card you will get full details about this candidate",
              );
            },
          )
        ]
    ));
    _targets.add(TargetFocus(
        identify: "Save Candidate",
        keyTarget: _saveCandidate,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) => CustomTutorialContent(title: "Save Candidate", content: "Here you can save this candidate which you can see anytime from menu list",)
          )
        ]
    ));
  }

  void showTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool tut = pref.get("dashboardTutorial") != null ? pref.getBool("dashboardTutorial") ?? false : false;
    print(tut);
    if(!tut){
      initTargets();
      TutorialCoachMark(
        context,
        targets: _targets,
        colorShadow: kDarkColor,
        textSkip: "Skip",
        alignSkip: Alignment.topRight,
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

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

    print(widget.data);

    if(widget.isSearched){
      _candidatesList = AllCandidates().searchCandidates(widget.data[0], widget.data[1], widget.data[2], widget.data[3], userID);
    }else{
      _candidatesList = AllCandidates().fetchCandidates(userID, "0");
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: FutureBuilder<AllCandidatesModel>(
                future: _candidatesList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.data.userList.length,
                      itemBuilder: (context, index) {
                        var employee = snapshot.data.data.userList[index];

                        return CandidateCard(
                          jobID: '0',
                          userID: userID,
                          employeeUserName: employee.userUsername ?? "",
                          employeeName: employee.userName ?? "",
                          employeeExp: employee.userExperience ?? "",
                          employeeID: employee.userId ?? "",
                          employeeImage: employee.userPhoto ?? "",
                          employeeLocation: employee.userLocation ?? "",
                          employeeQualification:
                              employee.userQualifications ?? "",
                          employeeSkills: employee.userSkills ?? "",
                          employeeSaved:
                              employee.candidateSave == "0" ? false : true,
                          employeeCreatedAt:
                              timeago.format(employee.userCreatedAt),
                        );
                      },
                    );
                  } else {
                    return CircularLoading();
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
