import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/components/tutorial/tutorial_content.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:remark_app/pages/response/interview/create_interview.dart';
import 'package:remark_app/pages/response/interview/interview_employee.dart';
import 'package:remark_app/pages/response/questionnaire/create_questionnaire.dart';
import 'package:remark_app/pages/response/questionnaire/questionnaire.dart';
import 'package:remark_app/pages/response/questionnaire/questionnaire_rooms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Responses extends StatefulWidget {
  final initialIndex;
  const Responses({Key key, this.initialIndex}) : super(key: key);

  @override
  _ResponsesState createState() => _ResponsesState();
}

class _ResponsesState extends State<Responses> {

  GlobalKey _addNewResponseButton = GlobalKey();
  List<TargetFocus> _targets = <TargetFocus>[];
  var userID;
  var userType;
  GlobalKey<ContainedTabBarViewState> _key = GlobalKey();
  int _currTabIndex = 0;

  saveTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("viewCandidateTutorial", true);
  }

  void initTargets() {
    _targets.add(TargetFocus(
        identify: "Menus",
        targetPosition: TargetPosition(
            Size(25 , 25),
            Offset(70, 320)
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
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Hero(tag:"splashscreenImage" ,child: Container(
            child: Image.asset(application_logo , width: 40,))),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchJobs(),));
              },
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.search , color: kDarkColor,)))
        ],
      ),
      drawer: Drawer(
        child: ApplicationDrawer(),
      ),
      floatingActionButton: userType == "2" ? FloatingActionButton(
        key: _addNewResponseButton,
        backgroundColor: kDarkColor,
        onPressed: () {
          print(_currTabIndex);
          if(_currTabIndex == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateInterview()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuestionnaire(),));
          }
        },
         child: Icon(Icons.add , color: Colors.white,),
      ) : Container(),
      body: SafeArea(
        child: ContainedTabBarView(
          initialIndex: widget.initialIndex ?? 0,
          onChange: (thisTab) {
            print(thisTab);
            setState(() {
              _currTabIndex = thisTab;
            });
          },
          key: _key,
          tabs: [
            Text("Interviews" , style: GoogleFonts.poppins(),),
            Text("Questionnaires" , style: GoogleFonts.poppins(),)
          ],
          tabBarProperties: TabBarProperties(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
            indicatorColor: kLightColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
            labelColor: kDarkColor,
            unselectedLabelColor: kLightColor.withOpacity(0.6)
          ),

          tabBarViewProperties: TabBarViewProperties(

            physics: AlwaysScrollableScrollPhysics()
          ),
          views: [
            InterviewScreen(),
            userType == "2" ? QuestionnaireRooms() : Questionnaire()
          ],
        ),
      ),
    );
  }
}

class TabViewHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  const TabViewHeader({Key key, this.icon, this.iconColor, this.title, this.titleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(icon , color: iconColor, size: 15,),
          ),
          SizedBox(width: 5,),
          Container(
            child: Text(title, style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold
            ),),
          )
        ],
      ),
    );
  }
}

