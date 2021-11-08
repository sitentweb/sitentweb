import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/apis/dashboard/analytics.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/components/tutorial/tutorial_content.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/dashboard/dashboard_data_model.dart';
import 'package:remark_app/pages/candidates/hired_candidates.dart';
import 'package:remark_app/pages/company/employer_company.dart';
import 'package:remark_app/pages/dashboard/showChart.dart';
import 'package:remark_app/pages/jobs/employer_all_jobs.dart';
import 'package:remark_app/pages/jobs/post_job.dart';
import 'package:remark_app/pages/response/responses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  // GLOBAL KEYS FOR TUTORIALS
  GlobalKey _chartDataKey = GlobalKey();
  GlobalKey _totalCountKey = GlobalKey();
  GlobalKey _addNewPostKey = GlobalKey();


  List<TargetFocus> _targets = <TargetFocus>[];
  Future<DashboardDataModel> _dashboardData;
  int touchedIndex = -1;
  String userType;
  String userID;



  @override
  void initState() {
    // TODO: implement initState
    getUserType();
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
        identify: "Total Counts",
        keyTarget: _totalCountKey,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            builder: (context, controller) {
              return CustomTutorialContent(
                title: "Total Counts",
                content: "Here you will got the total counts of Jobs & Companies",
              );
            },
          )
        ]
    ));
    _targets.add(TargetFocus(
        identify: "Add New Button",
        keyTarget: _addNewPostKey,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => CustomTutorialContent(title: "Add New Job", content: "Here you can post a new job and also can create company",)
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

  List chartLables = [
    {"title": "Company", "color": Colors.orangeAccent},
    {"title": "Jobs", "color": kDarkColor},
    {"title": "Interview", "color": Colors.greenAccent},
    {"title": "Questionnaire", "color": Colors.redAccent}
  ];

  Future getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString('userType');
      userID = pref.getString('userID');
      _dashboardData = AnalyticsData().fetchChartData(userID);
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: _addNewPostKey,
        onPressed: () {
          pushNewScreen(
            context,
            withNavBar: false,
            customPageRoute: MaterialPageRoute(builder: (context) => PostJob()
              ,),
            pageTransitionAnimation: PageTransitionAnimation.fade
          );
        },
        backgroundColor: kDarkColor,
        mini: true,
        child: Icon(Icons.add , color: Colors.white,),
      ),
      body: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: FutureBuilder<DashboardDataModel>(
            future: _dashboardData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.status) {
                  var dashData = snapshot.data.data;
                  return Column(
                    children: [
                      Container(
                        width: size.width,
                        key: _chartDataKey,
                        child: dashData.jobCount != "0" ? ShowChart(
                          company: dashData.companyCount,
                          job: dashData.jobCount,
                          interview: dashData.interViewCount,
                          questionnaire: dashData.questionnaireCount,
                        ) : EmptyData(message: "Chart is not ready \n Please post new job by click + icon",),
                      ),
                      SizedBox(height: 30,),
                      Container(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              showChartLable(
                                  context, "Company", Colors.orangeAccent),
                              showChartLable(context, "Job", Colors.blueAccent)
                            ],
                          ),
                          Row(
                            children: [
                              showChartLable(
                                  context, "Interview", Colors.greenAccent),
                              showChartLable(
                                  context, "Questionnaire", Colors.redAccent)
                            ],
                          )
                        ],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                      Padding(

                        padding: const EdgeInsets.symmetric(vertical: 5.0 , horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DashboardCountData(
                              link: EmployerAllJobs(),
                              key: _totalCountKey,
                              count: dashData.jobCount,
                              title: "Jobs",
                              type: Colors.blueAccent,
                            ),
                            DashboardCountData(
                              link: EmployerCompanies(),
                              count: dashData.companyCount,
                              title: "Company",
                              type: Colors.orangeAccent,
                            ),
                            DashboardCountData(
                              link: HiredCandidates(),
                              count: dashData.hiredCount,
                              title: "Hired",
                              type: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      DashboardCountDataCard(
                        onTap: () => pushNewScreen(
                          context,
                          customPageRoute: MaterialPageRoute(
                              builder: (context) => Responses(initialIndex: 0,),
                          ),
                          withNavBar: false
                        ),
                        title: "Interview",
                        total: dashData.interViewCount,
                        pending: dashData.interViewHoldCount,
                        waiting: dashData.interViewAgreeCount,
                      ),
                      DashboardCountDataCard(
                          onTap: () => pushNewScreen(
                            context,
                            withNavBar: false,
                            customPageRoute: MaterialPageRoute(builder: (context) => Responses(initialIndex: 1,),)
                          ),
                          title: "Questionnaire",
                          total: dashData.questionnaireRoomCount,
                          pending: dashData.questionnaireStartCount,
                          pendingTitle: "Started",
                          waitingTitle: "Submitted",
                          waiting: dashData.questionnaireHoldCount),

                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text("Data Not Found"),
                  );
                }
              } else {
                return CircularLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showChartLable(context, title, color) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 10,
          ),
          SizedBox(
            width: 10,
          ),
          Text(title , style: GoogleFonts.poppins(),)
        ],
      ),
    );
  }
}

class DashboardCountDataCard extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final total;
  final pending;
  final String totalTitle;
  final String pendingTitle;
  final String waitingTitle;
  final waiting;

  const DashboardCountDataCard({
    Key key,
    this.title,
    this.total,
    this.pending,
    this.waiting, this.totalTitle, this.pendingTitle, this.waitingTitle, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Spacer(),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: kDarkColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashboardCountData(
                      count: total,
                      title: totalTitle ?? "Total",
                      type: "success",
                    ),
                    DashboardCountData(
                      count: pending,
                      title: pendingTitle ?? "Pending",
                      type: "warning",
                    ),
                    DashboardCountData(
                      count: waiting,
                      title: waitingTitle ?? "Waiting",
                      type: Colors.grey,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCountData extends StatelessWidget {
  final count;
  final title;
  final type;
  final Widget link;

  const DashboardCountData({Key key, this.count, this.title, this.type , this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = type == "success"
        ? kDarkColor
        : type == "warning"
            ? Colors.deepOrange
            : type == "danger"
                ? Colors.redAccent
                : type;
    return Container(
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context, 
            withNavBar: false,
            screen: link
            );
        },
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.poppins(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(color: color, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
