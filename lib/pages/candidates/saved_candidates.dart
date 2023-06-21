import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remark_app/apis/candidates/fetch_candidate_api.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/candidate_card.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/saved_candidates_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class SavedCandidates extends StatefulWidget {
  const SavedCandidates({Key key}) : super(key: key);

  @override
  _SavedCandidatesState createState() => _SavedCandidatesState();
}

class _SavedCandidatesState extends State<SavedCandidates> {
  String userID;
  Future<SavedCandidatesModel> _savedCandidateModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

    getSavedCandidates();
  }

  getSavedCandidates() async {
    setState(() {
      _savedCandidateModel = FetchCandidate().fetchSavedCandidates(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: Get.width,
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Saved Candidates",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<SavedCandidatesModel>(
                  future: _savedCandidateModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.status) {
                        return ListView.builder(
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            final candidate = snapshot.data.data[index];
                            return CandidateCard(
                              jobID: "0",
                              userID: userID,
                              employeeUserName: candidate.userUsername,
                              employeeName: candidate.userName ?? "",
                              employeeCreatedAt:
                                  timeAgo.format(candidate.userCreatedAt),
                              employeeExp: candidate.userExperience ?? "",
                              employeeID: candidate.userId,
                              employeeImage: candidate.userPhoto ?? "",
                              employeeLocation: candidate.userLocation ?? "",
                              employeeQualification:
                                  candidate.userQualifications ?? "",
                              employeeSaved: true,
                              employeeSkills: candidate.userSkills ?? "",
                            );
                          },
                        );
                      } else {
                        return EmptyData(
                          message: "No Candidate Found",
                        );
                      }
                    } else if (snapshot.hasError) {
                      return EmptyData(
                        message: "Something went wrong",
                      );
                    } else {
                      return Center(child: CircularLoading());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
