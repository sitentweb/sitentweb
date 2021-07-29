import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/candidates/all_candidates_api.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/save_candidate_model.dart';
import 'package:remark_app/pages/candidates/view_candidate.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

class CandidateCard extends StatefulWidget {
  final userID;
  final jobID;
  final employeeName;
  final String employeeImage;
  final employeeUserName;
  final employeeSkills;
  final employeeID;
  final employeeExp;
  final employeeQualification;
  final employeeLocation;
  final employeeCreatedAt;
  final bool employeeSaved;
  const CandidateCard(
      {Key key,
      this.employeeName,
      this.employeeImage,
      this.employeeID,
      this.employeeExp,
      this.employeeLocation,
      this.employeeSkills,
      this.employeeQualification,
      this.employeeUserName,
      this.employeeCreatedAt,
      this.userID,
      this.employeeSaved, this.jobID})
      : super(key: key);

  @override
  _CandidateCardState createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
  bool savedThis = false;

  @override
  void initState() {
    // TODO: implement initState
    savedThis = widget.employeeSaved;
    super.initState();
  }

  Future<bool> userSavedThis(bool isLiked) async {
    SaveCandidateModel saveCandidate =
        await AllCandidates().saveCandidate(widget.userID, widget.employeeID);

    saveCandidate.status ? print(saveCandidate.saved) : print("Error");

    setState(() {
      savedThis = !savedThis;
    });
    return !isLiked;
  }

  Future<bool> userSharedThis(bool isLiked) async {
    Share.share("Check this candidate", subject: "Remark - Candidate");
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) => ViewCandidate(
                      jobID: widget.jobID,
                      userUserName: widget.employeeUserName,
                    ),
                  );
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                                child: CircleAvatar(
                              radius: 22,
                              onBackgroundImageError: (exception, stackTrace) {
                                print(exception);
                              },
                              backgroundColor: Colors.white,
                              backgroundImage: widget.employeeImage.isNotEmpty
                                  ? NetworkImage(
                                      base_url + widget.employeeImage)
                                  : AssetImage(application_logo),
                            )),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.employeeName,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.employeeLocation,
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.chevron_right_outlined,
                                color: kDarkColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Skills",
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.employeeSkills,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: size.width * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Exp",
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.employeeExp,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    LikeButton(
                      size: 25,
                      circleColor:
                          CircleColor(start: kLightColor, end: kDarkColor),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: kLightColor,
                          dotSecondaryColor: kDarkColor,
                          dotLastColor: Colors.greenAccent),
                      onTap: userSharedThis,
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
                      circleColor:
                          CircleColor(start: kLightColor, end: kDarkColor),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: kLightColor,
                          dotSecondaryColor: kDarkColor,
                          dotLastColor: Colors.greenAccent),
                      onTap: userSavedThis,
                      likeBuilder: (isLiked) {
                        return Icon(
                          Icons.bookmark,
                          size: 25,
                          color: savedThis ? kDarkColor : Colors.grey,
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      widget.employeeCreatedAt,
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
