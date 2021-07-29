import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/user/register_buttons.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/get_from_session.dart';
import 'package:remark_app/config/userSetting.dart';
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
      userName = pref.getString("userName");
      userPhoto = pref.getString("userPhoto");
      userEmail = pref.getString("userEmail");
      userBio = pref.getString("userBio");
      userID = pref.getString("userID");
    });

    userType == "2" ? getEmployerUserData() : getEmployeeUserData();
  }

  Future getEmployeeUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var _jobLocation;
    var arrayLocation;

    if (pref.getString("userJobLocation") != "") {
      _jobLocation = jsonDecode(pref.getString("userJobLocation"));
      arrayLocation = _jobLocation['arrayAddress'].join(", ");
    } else {
      arrayLocation = "";
    }

    setState(() {
      userExperience = pref.getString("userExperience") ?? "";
      userQualifications = pref.getString("userQualifications") ?? "";
      userSkills = pref.getString("userSkills") ?? "";
      userLocation = pref.getString("userLocation") ?? "";
      userJobLocation = arrayLocation ?? "";
      userLanguages = pref.getString("userLanguages") ?? "";
    });
  }

  Future getEmployerUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userOrganization = pref.getString("userOrganization");
      userOrganizationType = pref.getString("userOrganizationType");
      print(userOrganization);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return userType == "2"
        ? EmployerViewProfile(context)
        : userType == "0" ? RegisterAs() : EmployeeViewProfile(context);
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
                "${label}",
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
                "${value}",
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
                          radius: 30,
                          backgroundImage:
                              NetworkImage("${base_url}${userPhoto}"),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(userID: userID),
                              ));
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
                          backgroundImage:
                              NetworkImage("${base_url}${userPhoto}"),
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
                          showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => EditProfile(
                                    userID: userID,
                                  ),
                              isDismissible: true,
                              useRootNavigator: true)
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
