import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';

class JobDetailsCard extends StatelessWidget {
  final String logo;
  final String jobName;
  final String companyName;
  final String jobLocation;
  const JobDetailsCard(
      {Key key, this.logo, this.jobName, this.companyName, this.jobLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kDarkColor, kDarkColor.withOpacity(0.6)]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
              shape: BoxShape.circle,
              curve: Curves.fastOutSlowIn,
              animate: true,
              repeat: true,
              duration: Duration(milliseconds: 1000),
              glowColor: Colors.white,
              showTwoGlows: true,
              child: Material(
                elevation: 2,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: AppSetting.showUserImage(logo),
                ),
              ),
              endRadius: 30),
          Container(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    jobName,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      companyName,
                      style: GoogleFonts.poppins(
                          color: Colors.white54, fontSize: 14),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  color: kDarkColor,
                  child: Text(
                    jobLocation,
                    style: GoogleFonts.poppins(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
