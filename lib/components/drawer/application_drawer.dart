import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/pages/auth/login.dart';
import 'package:remark_app/pages/candidates/hired_candidates.dart';
import 'package:remark_app/pages/company/employer_company.dart';
import 'package:remark_app/pages/conversation/employer_conversation.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';
import 'package:remark_app/pages/jobs/applied_jobs.dart';
import 'package:remark_app/pages/jobs/employer_all_jobs.dart';
import 'package:remark_app/pages/jobs/posted_jobs.dart';
import 'package:remark_app/pages/jobs/save_job.dart';
import 'package:remark_app/pages/profile/edit_profile.dart';
import 'package:remark_app/pages/profile/view_profile.dart';
import 'package:remark_app/pages/response/interview/interview_employee.dart';
import 'package:remark_app/pages/response/interview/video_call_screen.dart';
import 'package:remark_app/pages/response/responses.dart';
import 'package:remark_app/pages/support/support.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationDrawer extends StatefulWidget {
  const ApplicationDrawer({Key key}) : super(key: key);

  @override
  _ApplicationDrawerState createState() => _ApplicationDrawerState();
}

class _ApplicationDrawerState extends State<ApplicationDrawer> {
  var userPhoto;
  var userName;
  var userType;
  var userDetail;
  var userID;
  BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  Future _logoutFromSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("userIsLogged", false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userPhoto = pref.getString("userPhoto");
      userName = pref.getString("userName");
      userType = pref.getString("userType");
      userID = pref.getString("userID");
      if (pref.getString("userEmail") == "") {
        userDetail = pref.getString("userMobile");
      } else {
        userDetail = pref.getString("userEmail");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            viewUserPhoto(size , context),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: ListView(
                    children: [
                      MenuList(
                        title: "Home",
                        icon: Icon(Icons.home_rounded),
                        action: () {
                          Navigator.pop(context);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  userType: userType,
                                ),
                              ));
                        },
                      ),
                      if (userType == "2")
                        MenuList(
                          title: "Search Jobs",
                          icon: Icon(FontAwesomeIcons.briefcase),
                          action: () {
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployerAllJobs()
                                ));
                          },
                        ),
                      if (userType == "2")
                        MenuList(
                          title: "Saved Jobs",
                          icon: Icon(FontAwesomeIcons.bookmark),
                          action: () {
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveJobs(
                                          userID: userID,
                                        )));
                          },
                        ),
                      if (userType == "2")
                        MenuList(
                            title: "Posted Jobs",
                            icon: Icon(FontAwesomeIcons.briefcase),
                            action: () {
                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostedJobs(),
                                  ));
                            }),
                      if (userType == "2")
                        MenuList(
                            title: "Companies",
                            icon: Icon(FontAwesomeIcons.briefcase),
                            action: () {
                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployerCompanies(),
                                  ));
                            }),
                      if(userType == "2")
                        MenuList(
                          title: "Hired Candidates",
                          icon: Icon(Icons.verified),
                          action: (){
                            Navigator.pop(context);
                            Navigator.push(context ,MaterialPageRoute(builder: (context) => HiredCandidates()));
                          },
                        ),
                      if (userType == "1")
                        MenuList(
                          title: "Save Jobs",
                          icon: Icon(Icons.favorite),
                          action: ()
                          {
                          Navigator.pop(context);

                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaveJobs(
                                    userID: userID,
                                  ),
                                ));
                          }
                        ),
                      // if (userType == "1")
                      //   MenuList(
                      //     title: "Applied Jobs",
                      //     icon: Icon(Icons.thumb_up),
                      //     action: ()
                      //     {
                      //       Navigator.pop(context);

                      //       Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => AppliedJobs(),
                      //                 ));
                      //           }),
                      if (userType == "1" || userType == "2")
                        MenuList(
                          title: "Conversation",
                          icon: Icon(Icons.message),
                          action: () {
                            Navigator.pop(context);

                            if (userType == "2" || userType == "1") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmployerConversationRoom(),
                                  ));
                            }
                          },
                        ),
                      if (userType == "1" || userType == "2")
                        MenuList(
                          title: "Responses",
                          icon: Icon(Icons.keyboard_return),
                          action: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Responses(initialIndex: 0,),
                                ));
                          },
                        ),
                      MenuList(
                        title: "Support",
                        icon: Icon(Icons.support_agent),
                        action: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Support()
                            ));
                        },
                      ),
                      MenuList(
                        title: "Share",
                        icon: Icon(Icons.share),
                        action: () {
                          Navigator.pop(context);

                          Share.share("Download Remark Application");
                        },
                      ),
                      MenuList(
                        title: "Exit",
                        icon: Icon(Icons.exit_to_app),
                        action: () => exit(0),
                      ),
                      MenuList(
                        title: "Logout",
                        icon: Icon(Icons.logout),
                        action: () async {
                          UserSetting.unsetUserSession();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget viewUserPhoto(Size size , BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.3,
      color: kLightColor,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userPhoto != null
                ? Stack(
                  children: [
                    AvatarGlow(
                        glowColor: Colors.white,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        animate: true,
                        endRadius: 50,
                        shape: BoxShape.circle,
                        curve: Curves.fastOutSlowIn,
                        showTwoGlows: true,
                        child: Material(
                          elevation: 5,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: kDarkColor,
                            radius: 40,
                            backgroundImage: AppSetting.showUserImage(userPhoto),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: InkWell(
                          onTap: () => pushNewScreen(
                            context,
                            screen: EditProfile(userID : userID , userType: userType),
                            withNavBar: true),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                            ),
                            child: Icon(Icons.edit , size: 15, color: kDarkColor, )),
                        ))
                  ],
                )
                : CircularProgressIndicator(),
            SizedBox(
              height: 5,
            ),
            Text(
              "$userName",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$userDetail",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function action;
  final Color bgColor;
  const MenuList({Key key, this.title, this.icon, this.action, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: kLightColor,
      title: Text(title , style: GoogleFonts.poppins(),),
      leading: icon,
      onTap: action,
      hoverColor: kLightColor,
    );
  }
}
