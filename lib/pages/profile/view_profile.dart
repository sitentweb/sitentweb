import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/components/user/register_buttons.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/model/user/fetch_user_data.dart';
import 'package:remark_app/pages/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key key}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String userType;
  String userName;
  String userBio;
  String userPhoto;
  String userExperience;
  String userQualifications;
  String userSkills;
  String userLocation;
  String userJobLocation;
  String userLanguages;
  String userEmail;
  String userID;
  Data user;

  // EXTRA FIELDS
  String userOrganization;
  String userOrganizationType;

  @override
  void initState() {
    // TODO: implement initState
    getUserType();
    super.initState();
  }

  getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
      userID = pref.getString("userID");
      userName = pref.getString("userName");
      userBio = pref.getString("userBio");
      userEmail = pref.getString("userEmail");
      userPhoto = pref.getString("userPhoto");
    });

    print(userID);

    FetchUserDataModel userData = await UserApi().fetchUserData(userID);

    userType == "2"
        ? getEmployerUserData(userData)
        : getEmployeeUserData(userData);
  }

  Future getEmployeeUserData(FetchUserDataModel userData) async {
    if (userData.status) {
      user = userData.data;
    }
    userType == "2"
        ? EmployerViewProfile(context)
        : userType == "0"
            ? RegisterAs()
            : EmployeeViewProfile(context);
    // SharedPreferences pref = await SharedPreferences.getInstance();

    var _jobLocation;
    var arrayLocation;

    if (await UserApi.user("userJobLocation") != "") {
      _jobLocation = jsonDecode(await UserApi.user("userJobLocation"));
      arrayLocation = _jobLocation['stringAddress'];
    } else {
      arrayLocation = "";
    }

    userExperience = await UserApi.user("userExperience") ?? "";
    userQualifications = await UserApi.user("userQualifications") ?? "";
    userSkills = await UserApi.user("userSkills") ?? "";
    userLocation = await UserApi.user("userLocation") ?? "";
    userJobLocation = arrayLocation ?? "";
    userLanguages = await UserApi.user("userLanguages") ?? "";

    setState(() {});
  }

  Future getEmployerUserData(FetchUserDataModel userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    userOrganization = await UserApi.user('userOrganization');
    userOrganizationType = await UserApi.user('userOrganizationType');
    print(userOrganization);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return userType == "2"
        ? EmployerViewProfile(context)
        : userType == "0"
            ? RegisterAs()
            : EmployeeViewProfile(context);
  }

  Widget userDetail(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "$label",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              child: Text(
                "$value",
                style: GoogleFonts.poppins(color: Colors.grey[800]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget EmployerViewProfile(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          color: kDarkColor,
          child: Center(
            child: Column(
              children: [
                userPhoto != null
                    ? Hero(
                        tag: "userPhoto",
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: NetworkImage(base_url + userPhoto),
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "$userName",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Spacer(),
              Container(
                width: size.width,
                padding: EdgeInsets.only(bottom: 20),
                height: size.height * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            userDetail("Profile Summary", userBio),
                            userDetail("Email", userEmail),
                            userDetail("Organization Name", userOrganization),
                            userDetail(
                                "Organization Type",
                                UserSetting.userOrganizationType(
                                    userOrganizationType)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FloatingActionButton(
                        backgroundColor: kDarkColor,
                        onPressed: () {
                          pushNewScreen(context,
                              screen: EditProfile(
                                userID: userID,
                                userType: userType,
                              ),
                              withNavBar: false);
                        },
                        child: Icon(
                          FontAwesomeIcons.pencilAlt,
                          size: 14,
                        ),
                        mini: true,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget EmployeeViewProfile(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          color: kDarkColor,
          child: Center(
            child: Column(
              children: [
                userPhoto != null
                    ? Hero(
                        tag: "userPhoto",
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: NetworkImage(base_url + userPhoto),
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "$userName",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.only(bottom: 20),
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            userDetail("Email", userEmail),
                            userDetail("Profile Summary", userBio),
                            userDetail("Work Experience", userExperience),
                            userDetail("Qualification", userQualifications),
                            userDetail("Skills", userSkills),
                            userDetail("Current Location", userLocation),
                            userDetail("Preferred Location", userJobLocation),
                            userDetail("Languages", userLanguages)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FloatingActionButton(
                        backgroundColor: kDarkColor,
                        onPressed: () => {
                          pushNewScreen(context,
                              screen: EditProfile(
                                userID: userID,
                                userType: userType,
                              ),
                              withNavBar: false)
                        },
                        child: Icon(
                          FontAwesomeIcons.pencilAlt,
                          size: 14,
                        ),
                        mini: true,
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
